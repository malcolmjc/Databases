import java.sql.Connection;
import java.sql.Date;
import java.util.List;
import java.util.Scanner;

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

      List<Room> availableRooms = queryBuilder.reservations(reservation);
      if (availableRooms == null) {
         return "Failed to run query";
      } else if (availableRooms.isEmpty()) {
         // TODO: if no rooms available, offer 5 suggested rooms
         return "TODO";
      } else {
         // TODO: offer option to book one of the available rooms
         System.out.println("OPTION 0: CANCEL");
         for (int i = 0; i < availableRooms.size(); i++) {
            System.out.println("OPTION " + (i+1) + ":\n" + availableRooms.get(i) + "\n");
         }
         int userChoice = reader.nextInt();
         if (userChoice == 0) {
            return "Going back to the main menu...";
         } else {
            return queryBuilder.makeReservation(availableRooms.get(userChoice - 1), reservation);
         }
      }
   }

   private String reservationChange() {

      return queryBuilder.reservationChange();
   }

   private String reservationCancellation() {
      Scanner reader = new Scanner(System.in);

      System.out.print("Reservation to be cancelled: ");
      String roomCode = reader.next();

      return queryBuilder.reservationCancellation(roomCode);
   }

   private String detailedReservationInformation() {

      return queryBuilder.detailedReservationInformation();
   }

   private String revenue() {

      return queryBuilder.revenue();
   }
}
