-- DAY 3
-- QUESTION 1

select customerNumber,customerName,state,creditLimit from customers 
where state is not null and
creditLimit between 50000 and 100000
order by creditLimit desc;

-- QUESTION 2

SELECT distinct productline FROM products where productLine like '%cars';

-- DAY 4
-- QUESTION 1

select orderNumber,status,coalesce(comments,"-")as comments from orders
where status="Shipped";

-- QUESTION 2

select employeeNumber,firstName,jobTitle,
case
when jobTitle="president" then 'P'
when (jobTitle like "sales Manager%" or jobTitle like 'sale Manager%')then 'SM'
when jobTitle='Sales Rep'then 'SR'
when jobTitle like '%VP%' then 'VP'
else " "
end as JobTitleAbbreviation
from employees
order by jobTitle;


-- DAY 5
-- QUESTION 1

select year(paymentdate) as PaymentYear,min(amount) as Amount from payments
group by paymentyear
order by paymentyear;

-- QUESTION 2

select 
year(orderdate)as Year,
concat("Q",Quarter(orderdate)) as Quarter,
count(distinct customerNumber)as "Unique Customers",
count(orderNumber)as "Total Orders"
from orders 
group by Year,Quarter
order by Year,Quarter;

-- QUESTION 3

select 
date_format(paymentDate,'%b') as  Month,
concat(format(sum(amount)/1000,0),"K") as "Formatted amount"
from payments
group by month
having sum(amount) between 500000 and 1000000
order by sum(amount) desc;

-- DAY 6
-- QUESTION 1

create table journey(
	Bus_ID int not null,
	Bus_Name varchar(100) not null,
	Source_Station varchar(100) not null,
	Destination varchar(100) not null,
	Email varchar(100)unique
);

select*from journey;
desc journey;

-- QUESTION 2

create table vendor(
	Vendor_ID int primary key,
    Name varchar(250)not null,
    Email varchar(250)unique,
    Country varchar(250)default "NA"
);

desc vendor;

-- QUESTION 3

create table movies(
	Movie_ID int primary key,
    Name varchar(250)not null,
    Release_Year varchar(10) default '-',
    Cast varchar(250)not null,
	Gender enum('Male','Female'),
    No_of_shows int check( No_of_shows >=0)
);

desc movies;

-- QUESTION 4

create table Suppliers(
	supplier_id int auto_increment primary key,
    supplier_name varchar(250),
    location varchar(250)
);

create table Product(
	product_id int auto_increment primary key,
	product_name varchar(250) not null unique,
	description text,
	supplier_id int,
    foreign key (supplier_id) references Suppliers(supplier_id)
);  

create table Stock(
	id int auto_increment primary key,
    product_id int,
    balance_stock int,
    foreign key(product_id) references Product(product_id)
);

desc Suppliers;
desc Product;
desc Stock;

-- DAY 7
-- QUESTION 1

select
employeeNumber,
concat(firstName," ",lastname)as "Sales Person",
count(distinct customerNumber)as Unique_Customers
from employees left join customers on
employeeNumber=salesRepEmployeeNumber
group by employeeNumber,"Sales Person"
order by Unique_Customers desc;

-- QUESTION 2

select 
	customers.customerNumber,
    customers.customerName,
    products.productCode,
    products.productName,
    sum(orderdetails.quantityOrdered) as "Ordered Qty",
	sum(products.quantityInStock)as "Total Inventory",
    sum(products.quantityInStock - orderdetails.quantityOrdered)as "Left Qty"
from
	customers
inner join 
    orders
on
    customers.customerNumber = orders.customerNumber
inner join
	orderdetails
on
	orders.orderNumber = orderdetails.orderNumber
inner join
	products
on
	orderdetails.productCode = products.productCode
group by
	customers.customerNumber,
	products.productCode
order by
	customers.customerNumber asc;
    
-- QUESTION 3

create table Laptop(Laptop_Name varchar(250));
insert into Laptop(Laptop_Name) values
("Dell"),
("HP"),
("Lenovo");
select*from Laptop;

create table Colours(Colour_Name varchar(250));
insert into Colours(Colour_Name) values
("Black"),
("Silver"),
("White");
select*from Colours;
    
select Laptop.Laptop_Name, Colours.colour_Name 
from Laptop 
cross join Colours
order by Laptop_Name;

-- QUESTION 4

create table project(
	EmployeeID int primary key,
	FullName varchar(250),
	Gender varchar(25),
	ManagerID int
);

INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);

select*from project;

select mgr.FullName as Manager_Name, emp.FullName as Emp_Name
from project mgr 
inner join project emp
on 
mgr.EmployeeID=emp.ManagerID
order by Manager_Name;

-- DAY 8

create table facility(
	Facility_ID int primary key,
	Name varchar(200),
	State varchar(200),
	Country varchar(200)
);

select* from facility;

alter table facility Modify Facility_id int auto_increment;

alter table facility add City varchar(200) not null;

desc facility;

-- DAY 9

create table university(
	ID int primary key,
	Name varchar(200)
);

INSERT INTO University
VALUES  (1, "       Pune          University     "), 
		(2, "  Mumbai          University     "),
		(3, "     Delhi   University     "),
		(4, "Madras University"),
		(5, "Nagpur University");
        
select*from university;

SET SQL_SAFE_UPDATES=0;
update university set name=trim(both " " from REGEXP_REPLACE(name, ' {1,}',' '))
where id is not null;

-- DAY 10

create view products_status as 
select 
year(o.orderdate)  as Year,
concat(
round(count(od.quantityordered*od.priceEach)),
'(',
round((sum(od.quantityordered*od.priceEach)/ sum(sum(od.quantityordered*od.priceEach)) over()) *100),
'%)'
)as "Value"
from orders o
join
orderdetails od
on o.ordernumber=od.ordernumber
group by year(o.orderdate);

select * from products_status;

-- DAY 11
-- QUESTION 1

DELIMITER //
create procedure `GetCustomerLevel` (in CUST int)
begin
	declare lct_creditlimit integer;
	select creditLimit into lct_creditlimit from customers where customerNumber=CUST;
	case
		when lct_creditlimit > 100000 then
			select "Platinum" as Result;
		when lct_creditlimit between 25000 and 100000 then
			select "Gold" as Result;
		when lct_creditlimit < 25000 then
			select "Silver" as Result;
		else
			select "Out of range" as Result;
	end case;
end //
DELIMITER ;

call assignment.GetCustomerLevel(103);

select*from Customers;

-- QUESTION 2

DELIMITER //
create procedure `Get_country_payments` (in input_year int,input_country varchar(250))
begin
	select
		year(paymentDate)as Year,
        country as Country,
        concat(format(sum(amount)/1000,0), 'K')as 'Total Amount'
	from payments
    inner join customers on payments.customerNumber=customers.customerNumber
    where year(paymentDate)=input_year 
		and country=input_country
	group by Year,Country;
end //
DELIMITER ;

call assignment.Get_country_payments(2003,'france');

-- DAY 12
-- QUESTION 1

with X as (
select
	year(orderdate) as Year,
    Monthname(orderdate) as Month,
    count(orderdate)as Total_Orders
    from
		orders
        group by 
			Year,Month
)
select 
	Year,
    Month,
	Total_Orders as 'Total Orders',
    concat(round(100*(( Total_Orders - LAG(Total_orders) over (order by year)) / LAG(Total_orders) over (order by year)),0),'%') as "% YoY Changes" from X;
    
-- QUESTION 2

create table emp_udf (
	Emp_ID int auto_increment primary key,
	Name varchar(250),
	DOB date
);

INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), ("Aman", "1992-08-15"), ("Meena", "1998-07-28"), ("Ketan", "2000-11-21"), ("Sanjay", "1995-05-21");

select*from Emp_UDF;

DELIMITER //
create function calculate_age(date_of_birth date)returns varchar(50)
deterministic
begin
	declare years int;
    declare months int;
    declare age varchar(50);
    
    set years=timestampdiff(year,date_of_birth,curdate());
    set months=timestampdiff(month,date_of_birth,curdate())%12;
    
    set age=concat(years,' years',months, 'months');
    
    return age;
end //

DELIMITER ;
    
select
emp_id,
name,
dob,
calculate_age(dob) as age
from emp_udf;

-- DAY 13
-- QUESTION 1

select customerNumber,customerName
from customers
where customerName Not in (select customerNumber from orders);


-- QUESTION 2

select c.customerNumber,c.customerName,count(o.ordernumber) as 'Total Orders'
from customers c
left join orders o on c.customerNumber=o.customerNumber
group by c.customerNumber,c.customerName

union
select c.customerNumber,c.customerName,0 as 'Total Orders'
from customers c
where c.customerNumber not in (select distinct customerNumber from orders)

union
select o.customerNumber,null as customerName,count(o.ordernumber) as 'Total Orders'
from orders o
where o.customerNumber not in (select distinct customerNumber from customers)
group by o.customerNumber;

-- QUESTION 3

select ordernumber,max(quantityordered) as QunatityOrders
from orderdetails o
where quantityordered < (
	select max(quantityordered)
    from orderdetails od
    where od.orderNumber=o.orderNumber
)
group by orderNumber;

-- QUESTION 4

select 
	ordernumber,
    count(ordernumber) as TotalProduct
from orderdetails
group by ordernumber
having count(orderNumber) > 0;
select
	max(TotalProduct) as 'Max(Total)',
    min(TotalProduct) as 'Min(Total)'
    from(
      select 
		ordernumber,
		count(ordernumber) as TotalProduct
	  from orderdetails
      group by ordernumber
      having count(orderNumber) > 0
	)as ProductCounts;
    
-- QUESTION 5

select productline,count(*) as Total
from products
where buyprice > (
	select avg(buyprice)
	from products
)
group by productline;

-- DAY 14

create table Emp_EH(
	EmpID int primary key,
	EmpName varchar(250),
	EmailAddress varchar(250)
);

DELIMITER //
CREATE PROCEDURE `InsertTableRecord`(in ID int, EmpName varchar(250), EmailAddress varchar(250))
BEGIN
Declare DuplicateEntry condition for 1062;

declare exit handler for DuplicateEntry
select 'Error Occurred (Please enter unique ID in EMPID column)' Message;

insert into Emp_EH(EmpID,EmpName,EmailAddress) values (ID,EmpName,EmailAddress);
select*from EMP_EH;
END //
DELIMITER ;

select*from EMP_EH;

call assignment.InsertTableRecord(106, 'ram', 'ram@gmail.com');

-- DAY 15

create table Emp_BIT(
	Name varchar(250),
	Occupation varchar(250),
	Working_date varchar(250),
	Working_hours int
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

INSERT INTO Emp_BIT VALUES
('Lokesh', 'Scientist', '2020-10-04', -12),
('Mahesh', 'Teacher', '2020-10-04', -10); 

select*from Emp_BIT;
