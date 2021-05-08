create or replace package refcursor1 as
type ref_cursor is ref cursor;
function show_employees
return ref_cursor;
end;
/
show errors

create or replace package refcursor6 as
   type ref_cursor is ref cursor;
   function purchases_made(cust_id in customers.cid%type)
   return ref_cursor;
end;
/
show errors

create or replace package prj2 as
/* should we be returning here */
/*
function show_employees2
(eid out Employees.eid%type, name out Employees.name%type, telephone# out Employees.telephone#%type, email out Employees.email%type);

function show_customers
(cid out Customers.cid%type, name out Customers.name%type, telephone# out Customers.telephone#%type, visits_made out Customers.visits_made%type, last_visit_date out Customers.last_visit_date%type);

function show_products(pid out Products.pid%type, name out Products.name%type, qoh out Products.qoh%type, qoh_threshold out Products.qoh_threshold%type, regular_price out Products.regular_price%type, discnt_rate out Products.discnt_date%type);

function show_purchases(pur# out Purchases.pur#%type, eid out Purchases.eid%type, pid out Purchases.pid%type, cid out Purchases.cid%type, pur_date out Purchases.pur_date%type, unit_price out Purchases.unit_price%type, total out Purchases.total%type, saving out Purchases.saving%type);

function show_logs(log# out Logs.log#%type, user_name out Logs.user_name%type, operation out Logs.operation%type, op_time out Logs.op_time%out, table_name out Logs.table_name%out, tuple_pkey out Logs.tuple_pkey%type);

create or replace package refcursor1 as
type ref_cursor is ref cursor;
function show_employees2
return ref_cursor;
*/
-- procedure purchases_made
-- (cid in Purchases.cid%type, name out Customers.name%type, pid out Purchases.pid%type, pur_date out Purchases.pur_date%type, qty out Purchases.qty%type, unit_price out Purchases.unit_price%type, total out Purchases.total%type);


function number_customers
(p_id in purchases.pid%type)
return number;

procedure add_customer
(c_id in Customers.cid%type, c_name in Customers.name%type, c_telephone# in Customers.telephone#%type);

procedure add_purchase
(e_id in Purchases.eid%type, p_id in Purchases.pid%type, c_id in Purchases.cid%type, pur_qty in Purchases.qty%type, pur_unit_price in Purchases.unit_price%type);

end;
/
show errors
