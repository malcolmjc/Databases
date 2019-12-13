import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class QueryBuilder {
   private Connection connection;

   public QueryBuilder(Connection connection) {
      this.connection = connection;
   }

   public String roomsAndRates() {
      String sql = "with DaysOccupiedLast180 as (\n" +
            "    select \n" +
            "    Room,\n" +
            "    SUM(DateDiff(Checkout,\n" +
            "    case \n" +
            "        when CheckIn >=  Current_Date - interval 180 day\n" +
            "        then CheckIn\n" +
            "        else Current_Date - interval 180 day\n" +
            "    end\n" +
            "    )) as DaysOccupied\n" +
            "    from lab7_reservations\n" +
            "    where CheckOut > Current_Date - interval 180 day\n" +
            "    group by Room\n" +
            "),\n" +
            "MostRecentReservation as (\n" +
            "    select Room,\n" +
            "    MAX(CheckIn) as MostRecentCheckin,\n" +
            "    MAX(Checkout) as MostRecentCheckout\n" +
            "    from lab7_reservations\n" +
            "    where CheckOut <= Current_Date\n" +
            "    group by Room\n" +
            "),\n" +
            "FirstAvailables as (\n" +
            "   select\n" +
            "   Room,\n" +
            "   Case\n" +
            "    When not exists (\n" +
            "     select * from lab7_reservations r2\n" +
            "     where r1.Room = r2.Room\n" +
            "     and CheckIn <= Current_Date\n" +
            "     and CheckOut > Current_Date\n" +
            "    )\n" +
            "    then Current_Date\n" +
            "    else (\n" +
            "       select MIN(CheckOut) from lab7_reservations r2\n" +
            "       where CheckOut > CURRENT_DATE\n" +
            "       and r2.Room = r1.Room\n" +
            "       and not exists (\n" +
            "        select Room from lab7_reservations r3 \n" +
            "        where r3.Room = r2.Room\n" +
            "        and r2.CheckOut = r3.CheckIn\n" +
            "       ) \n" +
            "    )\n" +
            "   end as FirstAvailable\n" +
            "   from lab7_reservations r1\n" +
            "   group by room\n" +
            ")\n" +
            "select \n" +
            "MostRecentReservation.Room,\n" +
            "RoomName,\n" +
            "Beds,\n" +
            "bedType,\n" +
            "maxOcc,\n" +
            "basePrice,\n" +
            "decor,\n" +
            "-- new info\n" +
            "ROUND(DaysOccupied / 180, 2) as Popularity,\n" +
            "FirstAvailable,\n" +
            "DATEDIFF(MostRecentCheckout,MostRecentCheckin) as LastStayLength,\n" +
            "MostRecentCheckout\n" +
            "from MostRecentReservation\n" +
            "join DaysOccupiedLast180 on DaysOccupiedLast180.Room = MostRecentReservation.Room\n" +
            "join FirstAvailables on FirstAvailables.Room = MostRecentReservation.Room\n" +
            "join lab7_rooms on FirstAvailables.Room = RoomCode\n" +
            "order by Popularity desc\n" +
            ";";

      try (Statement statement = connection.createStatement()) {
           ResultSet rs = statement.executeQuery(sql);

           String resultString = "";
           while (rs.next()) {
              String room = rs.getString("Room");
              Float popularity = rs.getFloat("Popularity");
              Date firstAvailable = rs.getDate("FirstAvailable");
              int lastStayLength = rs.getInt("LastStayLength");
              Date mostRecentCheckout = rs.getDate("MostRecentCheckout");

              resultString += String.format("\nRoom: %s\nPopularity: %.2f\nFirst Available: %tF\nLast Stay Length: %d\nMost RecentCheckout: %tF\n",
              room, popularity, firstAvailable, lastStayLength, mostRecentCheckout);
           }
           return resultString;
      } catch (SQLException se) {
         return "Failed to run query";
      }
   }

   public List<Room> reservations(Reservation reservation) {
      List<Object> params = new ArrayList<Object>();
      String sql = "with UnavailableRooms as (\n" +
            "    select distinct Room from lab7_reservations\n" +
            "    where (CheckIn <= ? and CheckOut > ?)\n" +
            "    or (CheckIn < ? and CheckIn >= ?)\n" +
            ")\n" +
            "select * from lab7_rooms\n" +
            "where RoomCode not in (\n" +
            "    select * from UnavailableRooms\n" +
            ")\n" +
            "and ? + ? <= maxOcc\n" +
            "and (? = bedType or ? = 'Any')\n" +
            "and (? = RoomCode or ? = 'Any')";

      params.add(reservation.beginDate);
      params.add(reservation.beginDate);
      params.add(reservation.endDate);
      params.add(reservation.beginDate);
      params.add(reservation.numChildren);
      params.add(reservation.numAdults);
      params.add(reservation.bedType);
      params.add(reservation.bedType);
      params.add(reservation.roomCode);
      params.add(reservation.roomCode);

      try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
         int i = 1;
         for (Object p : params) {
            preparedStatement.setObject(i++, p);
         }

         try (ResultSet rs = preparedStatement.executeQuery()) {
            List<Room> availableRooms = new ArrayList<>();
            while (rs.next()) {
               Room room = new Room(
                     rs.getString("RoomCode"),
                     rs.getString("RoomName"),
                     rs.getString("bedType"),
                     rs.getString("decor"),
                     rs.getInt("beds"),
                     rs.getInt("maxOcc"),
                     rs.getFloat("basePrice")
               );
               availableRooms.add(room);
            }
            return availableRooms;
         }
      } catch (SQLException se) {
         return null;
      }
   }

   public String makeReservation(Room room, Reservation reservation) {
      Scanner reader = new Scanner(System.in);

      System.out.println("Confirm Reservation (y/n)");
      System.out.println(reservation.firstName + ", " + reservation.lastName);
      System.out.println(room.roomCode + ", " + room.roomName + ", " + room.bedType);
      System.out.println(reservation.beginDate + " - " + reservation.endDate);
      System.out.println("Adults: " + reservation.numAdults);
      System.out.println("Children: " + reservation.numChildren);

      String answer = reader.next();
      if (!answer.equals("y")) {
         return "Returning to main menu...";
      }
      String sql = "Insert Into lab7_reservations (\n" +
            "    Code,Room,CheckIn,Checkout,Rate,\n" +
            "    LastName,FirstName,Adults,Kids\n" +
            ") Values (\n" +
            "    ?,?,?,?,(DateDiff(?,?) * 1.18),\n" +
            "    ?,?,?,?\n" +
            ")";

      String maxCodeSql = "select MAX(Code) from lab7_reservations";

      try (Statement statement = connection.createStatement()) {
         ResultSet rs = statement.executeQuery(maxCodeSql);
         int maxCode = rs.getInt(0);

         List<Object> params = new ArrayList<Object>();
         params.add(maxCode + 1);
         params.add(room.roomCode);
         params.add(reservation.beginDate);
         params.add(reservation.endDate);
         // Number of weekdays multipled by room base rate
         // TODO: Number of weekend days multiplied by 110% of the room base rate
         // An 18% tourism tax applied to the total of the above two calculations
         params.add(reservation.endDate);
         params.add(reservation.beginDate);
         params.add(reservation.lastName);
         params.add(reservation.firstName);
         params.add(reservation.numAdults);
         params.add(reservation.numChildren);

         PreparedStatement preparedStatement = connection.prepareStatement(sql);
         int i = 1;
         for (Object p : params) {
            preparedStatement.setObject(i++, p);
         }
         preparedStatement.execute(sql);
         return "Reservation confirmed!";
      } catch (SQLException se) {
         return "Failed to run query";
      }
   }

   public String reservationChange() {
      // TODO: build and execute statement, return string result
      return "";
   }

   public String reservationCancellation(String roomCode) {
      List<Object> params = new ArrayList<Object>();
      String sql = "delete from lab7_reservations\n" +
            "    where CODE = ?;";
      params.add(roomCode);

      try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
         preparedStatement.setInt(1, 2);
         preparedStatement.executeUpdate();

         return("\nRecord deleted successfully\n");

      } catch (SQLException se) {
         return "Failed to run query";
      }
      // TODO: Confirm the cancellation
   }

   public String detailedReservationInformation() {
      // TODO: build and execute statement, return string result
      return "";
   }

   public String revenue() {
      // TODO: build and execute statement, return string result
      return "";
   }
}
