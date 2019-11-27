public class Main {
   public static void main(String[] args) {
      InputHandler handler = new InputHandler();
      InputPrompter prompter = new InputPrompter();
      int option = prompter.getInput();
      while (option != 0) {
         String result = handler.handleOption(option);
         System.out.println(result);
         option = prompter.getInput();
      }
      prompter.quit();
   }
}
