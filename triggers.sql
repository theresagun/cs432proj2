---sets date format to get date and time for log entry
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS ';

-- all triggers put an entry into the logs table

/*Q7*/
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

/* end Q7 */


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


--theresas for #6
--trigger for checking the qoh of a product before inserting a purchase into the table
create or replace trigger check_qty
before insert on purchases
for each row
declare
	qty_avail products.qoh%type;
	qty_insuf exception; --user defined exception for when there is not enough qoh
begin
	select qoh
	into qty_avail
	from products
	where pid=:new.pid; -- the previous sql statement saves the qoh so we can compare it to the requested quantity next
	if(qty_avail<:new.qty) then raise qty_insuf; -- check if we have enough qoh, if not then we raise a user defined exception
	end if; -- if we do have enough then the trigger is completed and the insertion on the purchases table occurs
exception
	when qty_insuf then
	raise_application_error(-20001,'Insufficient quantity in stock.'); -- raise user defined exception so that the insert on purchases doesnt occur
end;
/
show errors

--trigger for updating the qoh to reflect it after a purchase was made
create or replace trigger upd_qoh
after insert on purchases
for each row
declare
	qtyoh products.qoh%type;
	qty_thresh products.qoh_threshold%type;
begin
	select qoh
	into qtyoh
	from products
	where pid=:new.pid; -- the previous sql statement saves the current qoh of the product
	select qoh_threshold
	into qty_thresh
	from products
	where pid=:new.pid; -- the previous sql statement saves the threshold for this product
	update products
	set qoh = qtyoh-:new.qty
	where pid = :new.pid; -- the previous sql statement updates the products table to show the qoh after the purchase was made (what remains)
	if((qtyoh-:new.qty)<qty_thresh) then --check if the updated quantity is below the threshold that we previously saved
		dbms_output.put_line('The current qoh of the product is below the required threshold and new supply is required.'); --if it is below the threshold then we need to increase the qoh
		update products
		set qoh = qty_thresh + 10
		where pid = :new.pid; --the previous sql statement updates the qoh for this product to be the threshold + 10
		dbms_output.put_line('After getting new supply, the qoh of the product is now ' || (qty_thresh + 10));
	end if;
end;
/
show errors

--trigger for updating the customers info after a purchase is made
create or replace trigger upd_cust
after insert on purchases
for each row
declare
	lvd customers.last_visit_date%type;
begin
	select last_visit_date
	into lvd
	from customers
	where cid = :new.cid; -- save the customers last visit date
	if(to_char(:new.pur_date, 'MM/DD/YYYY') != to_char(lvd, 'MM/DD/YYYY')) then -- if the customer did not already make a purchase on this date then
		update customers
		set last_visit_date = :new.pur_date, visits_made = visits_made + 1
		where cid = :new.cid; -- updates the customers table to show the last_visit_date is today and increment the visits_made
	end if;

end;
/
show errors
