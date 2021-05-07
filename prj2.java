import java.util.*;
import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class prj2 {
        public static void main (String args []) throws SQLException {
        try
        {
        OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
        ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
        // get user input
        Scanner sc = new Scanner(System.in);
        System.out.println("Enter your username: ");
        String username = sc.nextLine();
        System.out.println("Enter your password: ");
        String password = sc.nextLine();
        Connection conn = ds.getConnection(username, password);
        System.out.println("Successful connection.");
        int x = 1;
        while(x == 1) {
                System.out.println("Welcome to the RBMS Database PL/SQL System! Please select from the following operations to preform the operation of your choice.");
                //System.out.println("1 : Generate unique values for pur#.");
                //System.out.println("2 : Generate unique values for log#.");
                System.out.println("1 : Show Employees table."); // Abby
                System.out.println("2 : Show Customers table."); // Abby
                System.out.println("3 : Show Products table."); // Abby
                System.out.println("4 : Show Purchases table."); // Abby
                System.out.println("5: Show Logs table."); // Abby
		// Kate (3-5 on doc, 6-8 on here) . Theresa 9
                System.out.println("6 : call purchases_made(cid) - Given cid, returns name and every purchase the customer has made");
                System.out.println("7 : call number_customers(pid) - Given pid, report the number of customers who have purchased this product.");
                System.out.println("8 : add_customer(cid, name, telephone#) - Given cid, name, telephone#, add new customer to Customers table.");
                System.out.println("9 : add_purchase(eid, pid, cid, qty, unit_price) - Given eid, pid, cid, qty, and unit price, add new purchase to Purchases table");
                System.out.println("12 : Quit");
                Scanner sc1 = new Scanner(System.in);
                System.out.println("Enter your selection (1-12): ");
                int selection = sc1.nextInt();
                System.out.println("Selection is " + selection);
                // Do selection
                if(selection == 1) { // Show employees table
			CallableStatement cs = conn.prepareCall("begin ? := refcursor1.show_employees(); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
        		ResultSet rs = (ResultSet)cs.getObject(1);
			while(rs.next()) {
				System.out.println(rs.getString(1) + "\t");
			}
		}
                Scanner sc2 = new Scanner(System.in);
                System.out.println("Do you want to make another selection? (1 for yes/ 2 for no): ");
                int again = sc2.nextInt();
                if(again == 2) {
                        x = 0;
                        System.out.println("Closing connection");
                        conn.close();
                }
                }
        }
        catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n" + ex.getMessage());}
        catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
        }
}
