import java.util.Date;

public class Reservation {
   String firstName,lastName,roomCode,bedType;
   Date beginDate,endDate;
   int numChildren,numAdults;

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
}
