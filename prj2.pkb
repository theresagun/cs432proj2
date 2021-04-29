/* Hello world */
set serveroutput on
/* ABBY 1-5 */
/* Q1 */
create sequence pur#_seq
start with 100001
increment by 1;

create or replace trigger trig_pur#
before insert on purchases
for each row

begin
select pur#_seq.NEXTVAL
into :new.pur#
from dual;

end;

/

create sequence log#_seq
start with 1001
increment by 1;

create or replace trigger trig_log#
before insert on logs
for each row

begin
select log#_seq.NEXTVAL
into :new.log#
from dual;

end;

/* Q2 */
create or replace procedure show_employees(eid NUMBER) is
begin
for ro in (select * from employees)
loop
DBMS_output.put_line(ro.eid || ',' || ro.name || ',' || ro.telephone# || ',' || ro.email);
end loop;
end;
/
show errors

create or replace procedure show_customers(cid NUMBER) is
begin
for ro in (select * from customers)
loop
DBMS_output.put_line(ro.cid || ',' || ro.name || ',' || ro.telephone# || ',' || ro.visits_made || ',' || ro.last_visit_date);
end loop;
end;
/
show errors

create or replace procedure show_products(pid NUMBER) is
begin
for ro in (select * from products)
loop
DBMS_output.put_line(ro.pid || ',' || ro.name || ',' || ro.qoh || ',' || ro.qoh_threshold || ',' || ro.regular_price || ',' || ro.regular_price || ',' || ro.discnt_rate);
end loop;
end;
/
show errors

create or replace procedure show_purchases(pur# NUMBER) is
begin
for ro in (select * from purchases)
loop
DBMS_output.put_line(ro.pur# || ',' || ro.eid || ',' || ro.pid || ',' || ro.cid || ',' || ro.pur_date || ',' || ro.qty || ',' || ro.unit_price || ',' || ro.total || ',' || ro.saving);
end loop;
end;
/
show errors

create or replace procedure show_logs(log# NUMBER) is
begin
for ro in (select * from logs)
loop
DBMS_output.put_line(ro.log# || ',' || ro.user_name || ',' || ro.operation || ',' || ro.op_time || ',' || ro.table_name || ',' || ro.tuple_pkey);
end loop;
end;
/
show errors

/* Q3 */
create or replace procedure purchases_made(
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
                when no_data_found then status := false;
end;
/
show errors

/* Q4 */
create or replace function number_customers(
        p_id in purchases.pid%type)
        return number is
        same_pid number;
        begin
                select count(*) into same_pid
                from purchases, customers where purchases.pid = p_id
                and purchases.cid = customers.cid;
                return (same_pid);
end;
/
show errors

/* Q5 */
create or replace procedure add_customer(
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
/
show errors

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
