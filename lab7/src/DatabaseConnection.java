import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
   private static Connection connection = null;

   private DatabaseConnection() { }
   public static Connection getConnection() {
      if (connection == null) {
         try {
            establishConnection();
         } catch (SQLException se) {
            System.err.println(se.getMessage());
            System.err.println("Unable to connect to database");
            System.exit(1);
         }
      }
      System.out.println("Connected to database");
      return connection;
   }

   private static void establishConnection() throws SQLException {
      connection = DriverManager.getConnection(System.getenv("LAB7_JDBC_URL"),
            System.getenv("LAB7_JDBC_USER"),
            System.getenv("LAB7_JDBC_PW"));
   }
}
