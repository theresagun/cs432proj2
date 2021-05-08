set serveroutput on
create or replace package body prj2 as


/* Q3 */

	procedure purchases_made(
	        cust_id in customers.cid%type,
	        p_id out purchases.pid%type,
	        pur_d8 out purchases.pur_date%type,
	        qtyy out purchases.qty%type,
	        unitprice out purchases.unit_price%type,
	        totall out purchases.total%type,
	        status out boolean) is
	        begin
	                select pid, pur_date, qty, unit_price, total into p_id, pur_d8, qtyy, unitprice, totall
	                from purchases where cid = cust_id;
	                status := true;
	        exception
	                when no_data_found then
					status := false;
	 				raise_application_error(-20000, 'CID is invalid. No customers with cid ' || cust_id ||  ' exist');
	end;


	/* Q4 */

	function number_customers(
	        p_id in purchases.pid%type)
	        return number is
	        same_pid number;
			num_products_with_pid number;
			invalid_pid exception;
	        begin
	                select count(*) into same_pid
	                from purchases, customers where purchases.pid = p_id
	                and purchases.cid = customers.cid;
					select count(*) into num_products_with_pid from products where pid = p_id;
					if num_products_with_pid = 0 then
						raise invalid_pid;
					end if;
	                return (same_pid);
			exception
				when invalid_pid then
					raise_application_error(-20000, 'PID is invalid. No product with pid ' || p_id ||  ' exist');

	end;

	/* Q5 */
	procedure add_customer(
	        c_id in customers.cid%type,
	        c_name in customers.name%type,
	        c_telephone# in customers.telephone#%type) is
	        begin
	        insert into customers
	        (cid, name, telephone#, visits_made, last_visit_date)
	        values
	        /* initial value of visits_made is 1 */
	        (c_id, c_name, c_telephone#, 1, sysdate);
	        end;


	/*question 6*/
	procedure add_purchase(
		e_id in Purchases.eid%type,
		p_id in Purchases.pid%type,
		c_id in Purchases.cid%type,
		pur_qty in Purchases.qty%type,
		pur_unit_price in Purchases.unit_price%type)
	as
		reg_price Products.regular_price%type;
	begin
		select regular_price
		into reg_price
		from products
		where pid=p_id;
		insert into Purchases
		values (pur#_seq.nextval,e_id,p_id,c_id,sysdate,pur_qty,pur_unit_price,pur_qty*pur_unit_price,(reg_price-pur_unit_price)*pur_qty);
		commit;
	end;

end;  --end of package?
/
show errors

create or replace package body refcursor1 as
function show_employees
return ref_cursor is
rc ref_cursor;
begin
/* Open a ref cursor for a given query */
open rc for
select * from employees;
return rc;
end;
end;
/
show errors

create or replace package body refcursor2 as
function show_customers
return ref_cursor is
rc ref_cursor;
begin
open rc for
select * from customers;
return rc;
end;
end;
/
show errors

create or replace package body refcursor3 as
function show_products
return ref_cursor is
rc ref_cursor;
begin
open rc for
select * from products;
return rc;
end;
end;
/
show errors

create or replace package body refcursor4 as
function show_purchases
return ref_cursor is
rc ref_cursor;
begin
open rc for
select * from purchases;
return rc;
end;
end;
/
show errors

create or replace package body refcursor5 as
function show_logs
return ref_cursor is
rc ref_cursor;
begin
open rc for
select * from logs;
return rc;
end;
end;
/
show errors

create or replace package body refcursor6 as
function purchases_made(cust_id in customers.cid%type)
return ref_cursor is
rc ref_cursor;
begin
/* Open a ref cursor for a given query */
	open rc for
	select pid, pur_date, qty, unit_price, total
	from purchases where cid = cust_id;
	---status := true;
	return rc;
--
-- exception
-- 		when no_data_found then
-- 		---status := false;
-- 		raise_application_error(-20000, 'CID is invalid. No customers with cid ' || cust_id ||  ' exist');
end;
end;
/
show errors
