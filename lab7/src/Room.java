public class Room {
   String roomCode,roomName,bedType,decor;
   int beds,maxOcc;
   Float basePrice;
   public Room(
         String roomCode,
         String roomName,
         String bedType,
         String decor,
         int beds,
         int maxOcc,
         Float basePrice
   ) {
      this.roomCode = roomCode;
      this.roomName = roomName;
      this.bedType = bedType;
      this.decor = decor;
      this.beds = beds;
      this.maxOcc = maxOcc;
      this.basePrice = basePrice;
   }

   @Override public String toString() {
      return String.format("Name: %s, Code: %s\nBeds: %d, Bed Type: %s\nMax Occupancy: %d, Decor: %s\nPrice: %.2f",
            roomName, roomCode, beds, bedType, maxOcc, decor, basePrice);
   }
}
