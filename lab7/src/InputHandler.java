import java.sql.Connection;

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

   private String roomsAndRates() {

      return queryBuilder.roomsAndRates();
   }

   private String reservations() {

      return queryBuilder.reservations();
   }

   private String reservationChange() {

      return queryBuilder.reservationChange();
   }

   private String reservationCancellation() {

      return queryBuilder.reservationCancellation();
   }

   private String detailedReservationInformation() {

      return queryBuilder.detailedReservationInformation();
   }

   private String revenue() {

      return queryBuilder.revenue();
   }
}
