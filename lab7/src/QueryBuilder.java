import java.sql.*;

public class QueryBuilder {
   private Connection connection;

   public QueryBuilder(Connection connection) {
      this.connection = connection;
   }

   public String roomsAndRates() {
      String sql =
            "with DaysOccupiedLast180 as (\n" +
            "    select\n" +
            "    Room,\n" +
            "    SUM(DateDiff(Checkout,\n" +
            "    case\n" +
            "        when CheckIn >=  Current_Date - interval 180 day\n" +
            "        then CheckIn\n" +
            "        else Current_Date - interval 180 day\n" +
            "    end\n" +
            "    )) as DaysOccupied\n" +
            "    from lab7_reservations\n" +
            "    join lab7_rooms on Room = RoomCode\n" +
            "    where CheckOut > Current_Date - interval 180 day\n" +
            "    group by Room\n" +
            "),\n" +
            "MostRecentReservation as (\n" +
            "    select Room,\n" +
            "    MAX(CheckIn) as MostRecentCheckin,\n" +
            "    MAX(Checkout) as MostRecentCheckout\n" +
            "    from lab7_reservations\n" +
            "    group by Room\n" +
            ")\n" +
            "select\n" +
            "MostRecentReservation.Room,\n" +
            "ROUND(DaysOccupied / 180, 2) as Popularity,\n" +
            "DATE_ADD(MostRecentCheckout, interval 1 day) as FirstAvailable,\n" +
            "DATEDIFF(MostRecentCheckout,MostRecentCheckin) as LastStayLength,\n" +
            "MostRecentCheckout\n" +
            "from MostRecentReservation\n" +
            "join DaysOccupiedLast180 on DaysOccupiedLast180.Room = MostRecentReservation.Room\n" +
            ";";

      try (Statement statement = connection.createStatement()) {
           ResultSet rs = statement.executeQuery(sql);

           if (rs.next()) {
              String room = rs.getString("Room");
              Float popularity = rs.getFloat("Popularity");
              Date firstAvailable = rs.getDate("FirstAvailable");
              int lastStayLength = rs.getInt("LastStayLength");
              Date mostRecentCheckout = rs.getDate("MostRecentCheckout");
              return String.format("%s\n($%.2f)\n%d\n%i\n%d", room, popularity, firstAvailable, lastStayLength, mostRecentCheckout);
           }
      } catch (SQLException se) {
      }
      return "Failed to run query";
   }

   public String reservations() {
      // TODO: build and execute statement, return string result
      return "";
   }

   public String reservationChange() {
      // TODO: build and execute statement, return string result
      return "";
   }

   public String reservationCancellation() {
      // TODO: build and execute statement, return string result
      return "";
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
