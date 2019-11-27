import java.util.Scanner;

public class InputPrompter {
   private String prompt = "(0) Quit\n" +
      "(1) Rooms and Rates\n" +
      "(2) Reservations\n" +
      "(3) Reservation Change\n" +
      "(4) Reservation Cancellation\n" +
      "(5) Detailed Reservation Information\n" +
      "(6) Revenue\n";
   private Scanner reader = new Scanner(System.in);

   public int getInput() {
      System.out.println(prompt);
      return this.reader.nextInt();
   }

   public void quit() {
      this.reader.close();
   }
}
