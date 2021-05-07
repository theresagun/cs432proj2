import java.util.*;
import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class prj1 {
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
                System.out.println("1 : Generate unique values for pur#.");
                System.out.println("2 : Generate unique values for log#.");
                System.out.println("3 : Show Employees table.");
                System.out.println("4 : Show Customers table.");
                System.out.println("5 : Show Products table.");
                System.out.println("6 : Show Purchases table.");
                System.out.println("7: Show Logs table.");
                System.out.println("8 : call purchases_made(cid) - Given cid, returns name and every purchase the customer has made");
                System.out.println("9 : call number_customers(pid) - Given pid, report the number of customers who have purchased this product.");
                System.out.println("10 : add_customer(cid, name, telephone#) - Given cid, name, telephone#, add new customer to Customers table.");
                System.out.println("11 : add_purchase(eid, pid, cid, qty, unit_price) - Given eid, pid, cid, qty, and unit price, add new purchase to Purchases table");
                System.out.println("12 : Quit");
                Scanner sc1 = new Scanner(System.in);
                System.out.println("Enter your selection (1-12): ");
                int selection = sc1.nextInt();
                System.out.println("Selection is " + selection);
                // Do selection
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
