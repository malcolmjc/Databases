import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.text.ParseException;

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

   public String reservations(Reservation reservation) {
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
            String resultString = "";
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
               resultString += "\n" + room.toString() + "\n";
            }
            // TODO: offer option to book one of the available rooms
            // TODO: if no rooms available, offer 5 suggested rooms
            return resultString;
         }
      } catch (SQLException se) {
         return "Failed to run query";
      }
   }
   
   public Reservation getReservation(String rescode) {
	  List<Object> params = new ArrayList<Object>();
      String sql = "select * from lab7_reservations where CODE = ?;";
	  params.add(rescode);
	  
	  try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
	     int i = 1;
		 for (Object p : params){
		    preparedStatement.setObject(i++, p);
		 }
		 
		 try (ResultSet rs = preparedStatement.executeQuery()) {
		    if(rs.next() == false){
			   return null;
			}
			else{
			   Reservation ret = new Reservation(
			      rs.getString("FirstName"),
				  rs.getString("LastName"),
				  "AAA",
				  "type",
				  rs.getDate("CheckIn"),
				  rs.getDate("CheckOut"),
				  rs.getInt("Kids"),
				  rs.getInt("Adults")
			   );
			   
			   return ret;
			}
		 }
	  } catch (SQLException se){
         return null;
	  }
   }

   public String reservationChange(List params) {
      String sql = "update lab7_reservations\n" +
            "set FirstName = ?, LastName = ?, CheckIn = ?, CheckOut = ?, Kids = ?, Adults = ?\n" +
            "where CODE = ?;";
			
      try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
	     int i = 1;
		 for (Object p : params){
		    preparedStatement.setObject(i++, p);
		 }
		 preparedStatement.executeUpdate();
		 
		 return "Record updated successfully";
      } catch(SQLException se){
         return "Failed to run query";
	  }
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
   }

   public String detailedReservationInformation(Reservation reservation) {
      List<Object> params = new ArrayList<Object>();
      String sql = "select CODE, Room, RoomName, Checkin, Checkout, Rate, LastName, FirstName, Adults, Kids\n" +
            "from lab7_reservations, lab7_rooms\n" +
            "where Room = Roomcode\n" +
            "and FirstName LIKE concat(\"%\" , ?, \"%\")\n" +
            "and LastName LIKE concat(\"%\" , ?, \"%\")\n" +
            "and Checkin >= ? and Checkin <= ?\n" +
            "and Checkout >= ? and Checkout <= ?\n" +
            "and Room LIKE concat(\"%\" , ?, \"%\")\n" +
            "and CODE LIKE concat(\"%\" , ?, \"%\");";

      params.add(reservation.firstName);
      params.add(reservation.lastName);
      params.add(reservation.checkin);
      params.add(reservation.checkout);
      params.add(reservation.checkin);
      params.add(reservation.checkout);
      params.add(reservation.roomCode);
      params.add(reservation.resCode);

      try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
         int i = 1;
         for (Object p : params) {
            preparedStatement.setObject(i++, p);
         }

         try (ResultSet rs = preparedStatement.executeQuery()) {
            String resultString = "";
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			Calendar c = Calendar.getInstance();
            while (rs.next()) {
			   String myin = df.format(rs.getDate("CheckIn"));
			   String myout = df.format(rs.getDate("CheckOut"));
			   try{
			      c.setTime(df.parse(myin));
			   }catch(ParseException e){
			      e.printStackTrace();
			   }
			   c.add(Calendar.DAY_OF_MONTH, 1);  
			   String newin = df.format(c.getTime());
			   
			   try{
				  c.setTime(df.parse(myout));
			   }catch(ParseException e){
				  e.printStackTrace();
			   }
			   c.add(Calendar.DAY_OF_MONTH, 1);
			   String newout = df.format(c.getTime());
			   
               Reservation res = new Reservation(
                     Integer.toString(rs.getInt("CODE")),
                     rs.getString("Room"),
                     rs.getString("RoomName"),
                     newin,
                     newout,
                     rs.getFloat("Rate"),
					 rs.getString("FirstName"),
					 rs.getString("LastName"),
					 rs.getInt("Kids"),
                     rs.getInt("Adults")
               );
               resultString += "\n" + res.toString() + "\n";
            }
            return resultString;
         }
      } catch (SQLException se) {
         return "Failed to run query";
      }
   }

   public String revenue() {
      String sql = "with monthlyReservations as (\n" +
            "   select CODE, Room, Rate, checkin, monthname(checkin) as InMonth, checkout, monthname(checkout) as OutMonth, datediff(checkout, checkin) as nightsStayed from lab7_reservations\n" +
            "   join lab7_rooms on Room = RoomCode\n" +
            "   where year(checkin) = '2019'\n" +
            "   group by CODE, monthname(checkin), monthname(checkout)\n" +
            "),\n" +
            "sameMonth as (\n" +
            "   select CODE, Room, InMonth, nightsStayed, Rate from monthlyReservations\n" +
            "   where InMonth = OutMonth\n" +
            "),\n" +
            "differentMonths as (\n" +
            "   select CODE, Room, InMonth, OutMonth, nightsStayed, Rate,\n" +
            "   nightsStayed - (dayofmonth(checkout)-1) as InMonthNights,\n" +
            "   (nightsStayed - (nightsStayed - (dayofmonth(checkout)-1))) as OutMonthNights from monthlyReservations\n" +
            "   where InMonth != OutMonth\n" +
            "),\n" +
            "sameMonthTotals as (\n" +
            "   select Room, InMonth as month, sum(nightsStayed * Rate) as resTotal from monthlyReservations\n" +
            "   group by Room, InMonth\n" +
            "),\n" +
            "differentMonthTotals as (\n" +
            "   select Room, InMonth, sum(InMonthNights * Rate) as InMonthTotals, \n" +
            "   OutMonth, sum(OutMonthNights * Rate) as OutMonthTotals from differentMonths\n" +
            "   group by Room, InMonth, OutMonth\n" +
            ")\n" +
            "select * from sameMonthTotals s, differentMonthTotals d" +
            ";";


      try (Statement statement = connection.createStatement()) {
           ResultSet rs = statement.executeQuery(sql);

           String resultString = "";
           while (rs.next()) {
              String room_s = rs.getString("s.Room");
              String month = rs.getString("s.month");
              Float monthlyTotalSame = rs.getFloat("s.resTotal");
              String room_d = rs.getString("d.Room");
              String inMonth = rs.getString("d.InMonth");
              Float inMonthTotals = rs.getFloat("d.InMonthTotals");
              String outMonth = rs.getString("d.OutMonth");
              Float outMonthTotals = rs.getFloat("d.OutMonthTotals");

              int monthlySame = Math.round(monthlyTotalSame);
              int inTotals = Math.round(inMonthTotals);
              int outTotals = Math.round(outMonthTotals);

              // resultString += String.format("\nRoom: %s, Month: %s, MonthlyRevenue: %f, OverlapRevenue(checkin): %f, OverlapRevenue(checkout): %f\n",
              //     room_s, month, monthlyTotalSame, inMonthTotals,outMonthTotals);

              if (room_d.equals(room_s) && month.equals(inMonth)) {
                  resultString += String.format("\nRoom: %s, Month: %s, MonthlyRevenue: %d, OverlapRevenue: %d\n",
                  room_s, month, monthlySame, inTotals);
              }
              else if (room_d.equals(room_s) && month.equals(outMonth)) {
                  resultString += String.format("\nRoom: %s, Month: %s, MonthlyRevenue: %d, OverlapRevenue: %d\n",
                  room_s, month, monthlySame, outTotals);
              }
           }
           return resultString;
      } catch (SQLException se) {
         return "Failed to run query";
      }  
   }
}
