create or replace package prj2 as
/* should we be returning here */
procedure show_employees;

procedure purchases_made
(cid in Purchases.cid%type, name out Customers.name%type, pid out Purchases.pid%type, pur_date out Purchases.pur_date%type, qty out Purchases.qty%type, unit_price out Purchases.unit_price%type, total out Purchases.total%type);

function number_customers
(pid in Customers.cid%type)
return integer;

procedure add_customer
(c_id in Customers.cid%type, c_name in Customers.name%type, c_telephone# in Customers.telephone#%type);

procedure add_purchase
(e_id in Purchases.eid%type, p_id in Purchases.pid%type, c_id in Purchases.cid%type, pur_qty in Purchases.qty%type, pur_unit_price in Purchases.unit_price%type);

end;
/
show errors
