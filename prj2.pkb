/* Hello world */

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
	values (333,e_id,p_id,c_id,sysdate,pur_qty,pur_unit_price,pur_qty*pur_unit_price,pur_qty*pur_unit_price-reg_price);
commit;
end;
/
