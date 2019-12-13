import java.sql.Connection;
import java.sql.Date;
import java.util.Scanner;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

public class InputHandler {
   private Connection connection;
   private QueryBuilder queryBuilder;

   public InputHandler() {
      connection = DatabaseConnection.getConnection();
      queryBuilder = new QueryBuilder(connection);
   }

   public String handleOption(int option) {
      switch (option) {
         case 0:
            return null;
         case 1:
            return roomsAndRates();
         case 2:
            return reservations();
         case 3:
            return reservationChange();
         case 4:
            return reservationCancellation();
         case 5:
            return detailedReservationInformation();
         case 6:
            return revenue();
         default:
            return "Unknown Option Selected";
      }
   }

   // R1
   private String roomsAndRates() {
      return queryBuilder.roomsAndRates();
   }

   // R2
   private String reservations() {
      Scanner reader = new Scanner(System.in);

      System.out.print("First name: ");
      String firstName = reader.next();

      System.out.print("Last name: ");
      String lastName = reader.next();

      System.out.print("Room code (or Any): ");
      String roomCode = reader.next();

      System.out.print("Desired bed type (or Any): ");
      String bedType = reader.next();

      System.out.print("Desired beginning of stay YYYY-MM-DD: ");
      Date beginDate = Date.valueOf(reader.next());

      System.out.print("Desired ending of stay YYYY-MM-DD: ");
      Date endDate = Date.valueOf(reader.next());

      System.out.print("Number of children: ");
      int numChildren = reader.nextInt();

      System.out.print("Number of adults: ");
      int numAdults = reader.nextInt();

      Reservation reservation = new Reservation(firstName, lastName, roomCode, bedType,
            beginDate, endDate, numChildren, numAdults);
      return queryBuilder.reservations(reservation);
   }

   private String reservationChange() {
      Scanner reader = new Scanner(System.in);
	  SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	  Calendar c = Calendar.getInstance();
	  
	  System.out.println("Enter the reservation code you want to update: ");
	  String rescode = reader.nextLine();
	  
	  Reservation orig = queryBuilder.getReservation(rescode);
	  if (orig == null){
         return "Reservation not found";
	  }
	  
	  System.out.println("New first name (Leave blank for no change): ");
	  String fname = reader.nextLine();
	  if (fname.isEmpty()){
	     fname = orig.firstName;
	  }
	  
	  System.out.println("New last name (Leave blank for no change): ");
	  String lname = reader.nextLine();
	  if (lname.isEmpty()){
	     lname = orig.lastName;
	  }
	  
	  System.out.println("New check in YYYY-MM-DD (Leave blank for no change): ");
	  String checkin = reader.nextLine();
	  if (checkin.isEmpty()){
         checkin = df.format(orig.beginDate);
		 try{
		    c.setTime(df.parse(checkin));
		 }catch(ParseException e){
			 e.printStackTrace();
		 }
		 c.add(Calendar.DAY_OF_MONTH, 1);
		 checkin = df.format(c.getTime());
	  }
	  
	  System.out.println("New check out YYYY-MM-DD (Leave blank for no change): ");
	  String checkout = reader.nextLine();
	  if (checkout.isEmpty()){
	     checkout = df.format(orig.endDate);
		 try{
		    c.setTime(df.parse(checkout));
		 }catch(ParseException e){
			 e.printStackTrace();
		 }
		 c.add(Calendar.DAY_OF_MONTH, 1);
		 checkout = df.format(c.getTime());
	  }
	  
	  System.out.println("Number of kids (Leave blank for no change): ");
	  String kids = reader.nextLine();
	  if (kids.isEmpty()){
		  kids = Integer.toString(orig.numChildren);
	  }
	  
	  System.out.println("Number of adults (Leave blank for no change): ");
	  String adults = reader.nextLine();
	  if (adults.isEmpty()){
		  adults = Integer.toString(orig.numAdults);
	  }
	  
	  List<Object> params = new ArrayList<Object>();
	  params.add(fname);
	  params.add(lname);
	  params.add(checkin);
	  params.add(checkout);
	  params.add(kids);
	  params.add(adults);
	  params.add(rescode);
	  
      return queryBuilder.reservationChange(params);
   }

   private String reservationCancellation() {
      Scanner reader = new Scanner(System.in);

      System.out.println("Reservation to be cancelled: ");
      String roomCode = reader.next();
	  
	  char resp;
	  do{
	     System.out.println("Are you sure you want to cancel this reservation? (y/n)");
	     resp = reader.next().charAt(0);
	  } while (resp != 'y' && resp != 'n' && resp != 'Y' && resp !='N');
	  if(resp == 'y' || resp == 'Y'){
	     return queryBuilder.reservationCancellation(roomCode);
	  }
	  else{
	     return "No reservation cancelled";
	  }
   }

   private String detailedReservationInformation() {
      Scanner reader = new Scanner(System.in);
		
	  System.out.println("First Name (Leave blank for any):");
	  String firstname = reader.nextLine();

	  System.out.println("Last Name (Leave blank for any):");
	  String lastname = reader.nextLine();
		
	  System.out.println("Checkin YYYY-MM-DD (Leave blank for any):");
	  String userInput = reader.nextLine();
	  String checkin = "0000-1-1";
	  if (!userInput.isEmpty()){
	     checkin = userInput;
	  }
		
	  System.out.println("Checkout YYYY-MM-DD (Leave blank for any):");
	  userInput = reader.nextLine();
	  String checkout = "9999-12-31";
	  if (!userInput.isEmpty()){
	     checkout = userInput;
	  }
		
	  System.out.println("Room Code (Leave blank for any):");
	  String roomcode = reader.nextLine();
		
	  System.out.println("Reservation Code (Leave blank for any):");
	  String rescode = reader.nextLine();
	  
	  Reservation myres = new Reservation(rescode, roomcode, "", checkin, checkout, 0.0f, firstname, lastname, 0, 0);
	  
      return queryBuilder.detailedReservationInformation(myres);
   }

   private String revenue() {

      return queryBuilder.revenue();
   }
}
