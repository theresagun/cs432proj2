---sets date format to get date and time for log entry
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS ';

-- all triggers put an entry into the logs table

---trigger for when a tuple is inserted into Customers table
create or replace trigger new_customer
 after insert on Customers
 for each row
 begin
	insert into logs values(log#_seq.nextval, USER, 'insert',
	Sysdate, 'customers', :new.cid);
 end;
/
show errors

---trigger for when the visits_made attribute of a customer is updated
create or replace trigger update_customer_visits
after update of visits_made on Customers
for each row
begin
   insert into logs values(log#_seq.nextval, USER, 'update', Sysdate, 'customers', :new.cid);
end;
/
show errors

---trigger for when a tuple is inserted into Purchases table
create or replace trigger new_purchase
after insert on Purchases
for each row
begin
   insert into logs values(log#_seq.nextval, USER, 'insert', Sysdate, 'purchases', :new.pur#);
end;
/
show errors

---trigger for when the last_visit_date attribute of a customer is updated
create or replace trigger update_last_visit_date
 after update of last_visit_date on Customers
 for each row
 begin
	insert into logs values(log#_seq.nextval, USER, 'update', Sysdate, 'customers', :new.cid);
 end;
/
show errors

---trigger for when the qoh attribute of a Product is updated
create or replace trigger update_qoh
  after update of qoh on Products
  for each row
  begin
	 --- dbms_output.put_line("trigger worked")
	 insert into logs values(log#_seq.nextval, USER, 'update', Sysdate, 'products', :new.pid);
  end;
 /
 show errors



 create or replace trigger trig_pur#
 before insert on purchases
 for each row

 begin
 select pur#_seq.NEXTVAL
 into :new.pur#
 from dual;

 end;
/
show errors


 create or replace trigger trig_log#
 before insert on logs
 for each row

 begin
 select log#_seq.NEXTVAL
 into :new.log#
 from dual;

 end;
/
show errors
