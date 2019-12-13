import java.sql.Date;

public class Reservation {
   String firstName,lastName,roomCode,bedType,roomName,checkout,checkin,resCode;
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
   
   public Reservation (
         String resCode,
		 String roomCode,
		 String roomName,
		 String checkin,
		 String checkout,
		 float rate,
		 String firstName,
		 String lastName,
		 int numChildren,
		 int numAdults) {
	
      this.resCode = resCode;
	  this.roomCode = roomCode;
	  this.roomName = roomName;
	  this.checkin = checkin;
	  this.checkout = checkout;
	  this.rate = rate;
	  this.firstName = firstName;
	  this.lastName = lastName;
	  this.numChildren = numChildren;
	  this.numAdults = numAdults;
   }
		 
   public String toString(){
      String result = "Reservation Code: " + resCode + "\n" +
	     "Room Name: " + roomName + ", Room Code: " + roomCode + "\n" +
		 "Check In: " + checkin + ", Checkout: " + checkout + "\n" +
		 "Last Name: " + lastName + ", First Name: " + firstName + "\n" +
		 "Adults: " + numAdults + ", Kids: " + numChildren + "\n" +
		 "Rate: " + rate;
	  return result;
   }
		 
}
