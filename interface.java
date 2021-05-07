// usage:  1. compile: javac -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar jdbcdemo1.java
//         2. execute: java -cp /usr/lib/oracle/18.3/client64/lib/ojdbc8.jar jdbcdemo1.java
import java.sql.*;
import oracle.jdbc.*;
import java.math.*;
import java.io.*;
import java.awt.*;
import oracle.jdbc.pool.OracleDataSource;

public class jdbcdemo1 {

   public static void main (String args []) throws SQLException {
    try
    {

      //Connection to Oracle server. Need to replace username and
      //password by your username and your password. For security
      //consideration, it's better to read them in from keyboard.
      OracleDataSource ds = new oracle.jdbc.pool.OracleDataSource();
      ds.setURL("jdbc:oracle:thin:@castor.cc.binghamton.edu:1521:acad111");
      Connection conn = ds.getConnection("USERNAME", "PASSWORD");
      
      System.out.ln("Connection success");

      //close the result set, statement, and the connection
      rset.close();
      stmt.close();
      conn.close();
   }
     catch (SQLException ex) { System.out.println ("\n*** SQLException caught ***\n");}
     catch (Exception e) {System.out.println ("\n*** other Exception caught ***\n");}
  }
