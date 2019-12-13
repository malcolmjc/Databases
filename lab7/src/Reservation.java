import java.sql.Date;

public class Reservation {
   String firstName,lastName,roomCode,bedType,resCode;
   Date beginDate,endDate;
   int numChildren,numAdults;
   float rate;

   public Reservation(
         String firstName,
         String lastName,
         String roomCode,
         String bedType,
         Date beginDate,
         Date endDate,
         int numChildren,
         int numAdults) {
      this.firstName = firstName;
      this.lastName = lastName;
      this.roomCode = roomCode;
      this.bedType = bedType;
      this.beginDate = beginDate;
      this.endDate = endDate;
      this.numChildren = numChildren;
      this.numAdults = numAdults;
   }

   @Override public String toString() {
      return String.format("Name: %s,%s, Reservation Code: %s\nRoom Code: %s, Rate: %.2f\n%s thru %s\n%d Adults, %d Kids",
            firstName, lastName, resCode, roomCode, rate, beginDate, endDate, numAdults, numChildren);
   }
}
