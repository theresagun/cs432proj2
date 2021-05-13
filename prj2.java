import java.util.*;
import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

//DO WE HAVE TO CALL TRIGGERS/SEQUENCES FILE?

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
                System.out.println("5 : Show Logs table."); // Abby
		// Kate (3-5 on doc, 6-8 on here) . Theresa 9
                System.out.println("6 : call purchases_made(cid) - Given cid, returns name and every purchase the customer has made");
                System.out.println("7 : call number_customers(pid) - Given pid, report the number of customers who have purchased this product.");
                System.out.println("8 : add_customer(cid, name, telephone#) - Given cid, name, telephone#, add new customer to Customers table.");
                System.out.println("9 : add_purchase(eid, pid, cid, qty, unit_price) - Given eid, pid, cid, qty, and unit price, add new purchase to Purchases table");
                System.out.println("10 : Quit");
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
 			System.out.println("eid" + "\t" + "name" + "\t" + "telephone#" +
                        "\t" + "email");
			while(rs.next()) {
				System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" + rs.getString(4));
			}
		}
		else if(selection == 2) {
			CallableStatement cs = conn.prepareCall("begin ? := refcursor2.show_customers(); end;");
			cs.registerOutParameter(1, OracleTypes.CURSOR);
			cs.execute();
			ResultSet rs = (ResultSet)cs.getObject(1);
			System.out.println("cid" +
                        "\t" + "name" + "\t" + "telephone#" + "\t" + "visits_made" + "\t" + "last_visit_date");
			while(rs.next()) {
				System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" +
				rs.getString(4) + "\t\t" + rs.getString(5));
			}
		}

		else if(selection == 3) {
                        CallableStatement cs = conn.prepareCall("begin ? := refcursor3.show_products(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        ResultSet rs = (ResultSet)cs.getObject(1);
                        System.out.println("pid" + "\t\t" + "name" + "\t\t" +
                        "qoh" + "\t\t" + "qoh_threshold" + "\t\t" + "regular_price" + "\t\t" + "discnt_rate");
			int line_num = 0;
			while(rs.next()) {
				if(line_num < 7) {
				System.out.println(rs.getString(1) + "\t\t" +  rs.getString(2) + "\t\t" + rs.getString(3) + "\t\t" + rs.getString(4) + "\t\t\t" + rs.getString(5) +"\t\t\t\t" + rs.getString(6));	}	
					else {
			//	System.out.println("here");
				System.out.println(rs.getString(1) + "\t\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t\t" + rs.getString(4) + "\t\t\t" + rs.getString(5) + "\t\t\t\t" + rs.getString(6));	}			line_num = line_num + 1;	}}
		else if(selection == 4) {
                        CallableStatement cs = conn.prepareCall("begin ? := refcursor4.show_purchases(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
                        ResultSet rs = (ResultSet)cs.getObject(1);
			System.out.println("pur#" + "\t" + "eid" + "\t" + "pid" + "\t" + "cid" + "\t" + "pur_date" + "\t"
			+ "\t\t" + "qty" + "\t" + "unit_price" + "\t" + "total" + "\t\t" + "saving");
                        while(rs.next()) {
                                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" +
                                rs.getString(4) + "\t" + rs.getString(5) + "\t" + "\t" + rs.getString(6) + "\t" + rs.getString(7) + "\t\t" + rs.getString(8) + "\t\t" + rs.getString(9));        }
		}
		else if(selection == 5) {
                        CallableStatement cs = conn.prepareCall("begin ? := refcursor5.show_logs(); end;");
                        cs.registerOutParameter(1, OracleTypes.CURSOR);
                        cs.execute();
			//System.out.println("executing");
                        ResultSet rs = (ResultSet)cs.getObject(1);
			System.out.println("log#" + "\t" + "user_name" + "\t" + "operation" + "\t" + "op_time" +
			"\t" + "\t" + "table_name" + "\t" + "tuple_pkey");
                        while(rs.next()) {
				//System.out.println("here");
                                System.out.println(rs.getString(1) + "\t" + rs.getString(2) + "\t" + rs.getString(3) + "\t" +
                                 "\t" + rs.getString(4) + "\t" + rs.getString(5) + "\t" + rs.getString(6));
			}
                }

        else if (selection == 6){
			//Prepare to call stored procedure:
			CallableStatement cs = conn.prepareCall("begin ? := refcursor6.purchases_made(?); end;");
			//register the out parameter (the first parameter)
			cs.registerOutParameter(1, OracleTypes.CURSOR);

			// Input cid  from keyboard
			BufferedReader  readKeyBoard;
			String         cid;
			readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
			System.out.print("Please enter Customer cid: ");
			cid = readKeyBoard.readLine();
			cid = cid.replace("\n", "").replace("\r", "");
			cs.setString(2, cid);


			Statement s = conn.createStatement();
			s.executeUpdate("begin dbms_output.enable(); end;");
			// execute and retrieve the result set

			try{
				cs.executeQuery();
			} catch (SQLException e){
				if(e.getErrorCode() == 20000){
					//if qoh < quantity of purchase
					System.out.println("'CID is invalid. No customers with cid '" + cid +  " ' exist'");
				}
				else{
					System.out.println(e.getMessage());
				}
				s.executeUpdate("begin dbms_output.disable(); end;");
		                Scanner sc2 = new Scanner(System.in);
              			System.out.println("Do you want to make another selection? (1 for yes/ 2 for no): ");
                		int again = sc2.nextInt();
                		if(again == 2) {
                        		x = 0;
                        		System.out.println("Closing connection");
                        		conn.close();
                		}
				cs.close();
				continue;
			}



			//cs.execute();
			ResultSet rs = (ResultSet)cs.getObject(1);

			// print the results
			System.out.println("pid" + "\t" + "pur_date" + "\t\t" + "qty" + "\t" + "unit_price" + "\t" + "total");
			while (rs.next()) {
				//System.out.println(" the qty is" + rs.getString(3));
				System.out.println(rs.getString(1) + "\t" +
					rs.getString(2) + "\t" + rs.getString(3) +
					"\t" + rs.getString(4) +
					"\t\t" + rs.getString(5));
			}
			cs.close();

		}

		else if (selection == 7){
			CallableStatement cs = conn.prepareCall("{? = call number_customers(?)}");
			// Input cid  from keyboard
			BufferedReader  readKeyBoard;
			String         pid;
			readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
			System.out.print("Please enter Product pid: ");
			pid = readKeyBoard.readLine();
			cs.setString(2, pid);

			cs.registerOutParameter(1, Types.NUMERIC);

			//cs.executeUpdate();
			// execute and retrieve the result set


			Statement s = conn.createStatement();
			s.executeUpdate("begin dbms_output.enable(); end;");
			// execute and retrieve the result set

			try{
				cs.executeQuery();
			} catch (SQLException e){
				if(e.getErrorCode() == 20000){
					//if qoh < quantity of purchase
					System.out.println("'PID is invalid. No product with pid '" + pid + "' exist");
				}
				else{
					System.out.println(e.getMessage());
				}
				s.executeUpdate("begin dbms_output.disable(); end;");
		                Scanner sc2 = new Scanner(System.in);
              			System.out.println("Do you want to make another selection? (1 for yes/ 2 for no): ");
                		int again = sc2.nextInt();
                		if(again == 2) {
                        		x = 0;
                        		System.out.println("Closing connection");
                        		conn.close();
                		}
				cs.close();
				continue;
			}

			// print the results
			Integer num = cs.getInt(1);
			System.out.println(num + " customers have purchased product with pid '" + pid + "'");
			cs.close();

		}
		else if(selection == 8){ //add customer
			//get info to add customer via user input
			BufferedReader readKeyBoard;
        		String cid;
			String name;
			String phone;
        		readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
        		System.out.print("Please Enter CID:");
        		cid = readKeyBoard.readLine();
			System.out.print("Please Enter Customer name:");
        		name = readKeyBoard.readLine();
			System.out.print("Please Enter Customer phone number:");
        		phone = readKeyBoard.readLine();
			//prep to call procedure
			CallableStatement cs = conn.prepareCall("begin add_customer(:1,:2,:3); end;");
        		cs.setString(1, cid);
        		cs.setString(2, name);
        		cs.setString(3, phone);
			//execute
			cs.executeQuery();
			//no out parameter to handle so close the callable statement
			cs.close();
			System.out.println("Successfully added customer "+name);
		}
		else if(selection == 10) { // quit
			System.out.println("Closing connection");
			conn.close();
		}
		else if(selection == 9){ //add purchase
			//get info to add a purchase via user input
			BufferedReader readKeyBoard;
        		String eid;
			String pid;
			String cid;
			String qty;
			String price;
        		readKeyBoard = new BufferedReader(new InputStreamReader(System.in));
        		System.out.print("Please Enter EID:");
        		eid = readKeyBoard.readLine();
			System.out.print("Please Enter PID:");
        		pid = readKeyBoard.readLine();
			System.out.print("Please Enter CID:");
        		cid = readKeyBoard.readLine();
			System.out.print("Please Enter quantity:");
        		qty = readKeyBoard.readLine();
			System.out.print("Please Enter unit price:");
        		price = readKeyBoard.readLine();
			//prep to call procedure
			CallableStatement cs = conn.prepareCall("begin add_purchase(:1,:2,:3,:4,:5); end;");
        		cs.setString(1, eid);
        		cs.setString(2, pid);
        		cs.setString(3, cid);
        		cs.setString(4, qty);
        		cs.setString(5, price);
			//prep output receiving so we can see the dbms output
			Statement s = conn.createStatement();
			s.executeUpdate("begin dbms_output.enable(); end;");
			//execute
			try{
				cs.executeQuery();
			} catch (SQLException e){
				//if there are a sql exception...
				if(e.getErrorCode() == 20001){
					//user defined exception for when qoh < quantity of purchase
					System.out.println("Insufficient quantity in sock.");
				}
				else{
					//different error. probably input wrong id values
					System.out.println("Invalid input parameters.");
				}
				//continue the program...
				//disable the output so we no longer receive it
				s.executeUpdate("begin dbms_output.disable(); end;");
				//does the user want to continue?
		                Scanner sc2 = new Scanner(System.in);
              			System.out.println("Do you want to make another selection? (1 for yes/ 2 for no): ");
                		int again = sc2.nextInt();
                		if(again == 2) {
                        		x = 0;
                        		System.out.println("Closing connection");
                        		conn.close();
                		}
				cs.close();
				continue;
			}
			//need to get dbms output
			CallableStatement call = conn.prepareCall("declare num integer := 2; begin dbms_output.get_lines(?, num); end;");
			call.registerOutParameter(1, Types.ARRAY, "DBMSOUTPUT_LINESARRAY");
			call.execute();
			Array array = null;
			array = call.getArray(1);
			if(array != null){ //check if there is output
				//for each dbms output line, print to java interface
				Arrays.stream((Object[])array.getArray()).forEach(System.out::println);
			}//if there is no ouput then do nothing with array
			//need to disable output until needed again
			s.executeUpdate("begin dbms_output.disable(); end;");
			cs.close();
			System.out.println("Successfully added purchase.");
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
