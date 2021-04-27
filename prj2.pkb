/* Hello world */
set serveroutput on
/*question 6*/
create or replace procedure add_purchase(
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
	values (8221,e_id,p_id,c_id,sysdate,pur_qty,pur_unit_price,pur_qty*pur_unit_price,(reg_price-pur_unit_price)*pur_qty);
	commit;
end;
/
create or replace trigger check_qty
before insert on purchases
for each row
declare 
	qty_avail products.qoh%type;
	qty_insuf exception;
begin
	select qoh 
	into qty_avail
	from products
	where pid=:new.pid;
	if(qty_avail<:new.qty) then raise qty_insuf;
	end if;
exception
	when qty_insuf then
	raise_application_error(-20001,'Insufficient quantity in stock.');
end;
/
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
	where pid=:new.pid;
	select qoh_threshold
	into qty_thresh
	from products
	where pid=:new.pid;
	update products
	set qoh = qtyoh-:new.qty
	where pid = :new.pid;
	if((qtyoh-:new.qty)<qty_thresh) then
		dbms_output.put_line('The current qoh of the product is below the required threshold and new supply is required.');
		update products
		set qoh = qty_thresh + 10
		where pid = :new.pid;
		dbms_output.put_line('After getting new supply, the qoh of the product is now ' || (qty_thresh + 10));
	end if;
end;
/
create or replace trigger upd_cust
after insert on purchases
for each row
declare
	lvd customers.last_visit_date%type;
begin
	select last_visit_date
	into lvd
	from customers
	where cid = :new.cid;
	if(to_char(:new.pur_date, 'MM/DD/YYYY') != to_char(lvd, 'MM/DD/YYYY')) then
		update customers
		set last_visit_date = :new.pur_date, visits_made = visits_made + 1
		where cid = :new.cid;
	end if;
end;
/	
