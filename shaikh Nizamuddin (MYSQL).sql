USE `classicmodels`;

Q1 - A 
select * from employees;
select employeenumber,firstname,lastname from employees where jobtitle="sales rep" and reportsto = "1102";

Q1 - B
select * from productlines;
select distinct productline from productlines where productline like "%car%";

Q2 
select * from customers;
select customernumber,
       customername,
       case
when country in("USA","CANADA") then "NORTH AMERICA" when country in("UK","GERMANY","FRANCE") then "Europe"
else "others" END
   as customersegment from customers;


Q3 - A
SELECT productCode, SUM(quantityOrdered) AS totalQuantity
FROM OrderDetails
GROUP BY productCode
ORDER BY totalQuantity DESC
LIMIT 10;

Q3 - B
select * from payments; 
SELECT
    EXTRACT(MONTH FROM paymentDate) AS paymentMonth,
    COUNT(*) AS totalPayments
FROM Payments
GROUP BY paymentMonth
HAVING COUNT(*) > 20
ORDER BY totalPayments DESC;

Q4 - A
CREATE DATABASE Customers_Orders;
USE Customers_Orders;

CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20)
);

select * from customers;
Q4 - B
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CHECK (total_amount > 0)
);
select * from orders;

Q5

select c.country, 
count(status) as order_count
from customers c
inner join orders o
where c.customernumber = o.customernumber
group by c.country
having count (status) 
order by order_count desc
limit 5;


Q6 
CREATE TABLE project (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    Gender ENUM('Male', 'Female') NOT NULL,
    ManagerID INT
);
      
INSERT INTO project (EmployeeID, FullName, Gender, ManagerID)
VALUES (1, 'Pranaya','Male', 3),
       (2, 'Priyanka','Female', 1),
       (3, 'Preety','Female', null),
       (4, 'Anurag','Male', 1),
       (5, 'Sambit','Male', 1),
       (6, 'Rajesh','Male', 3);
  
  INSERT INTO project (EmployeeID, FullName, Gender, ManagerID)
VALUES (7, 'Hina','Female', 3);  

select * from project;
       
SELECT e.FullName AS EmployeeName, m.FullName AS ManagerName
FROM project e
LEFT JOIN project m ON e.ManagerID = m.EmployeeID;

Q7 
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50)
);

a)
ALTER TABLE facility
MODIFY COLUMN Facility_ID INT AUTO_INCREMENT PRIMARY KEY;
b)
ALTER TABLE facility
ADD COLUMN city VARCHAR(100) NOT NULL AFTER Name;
select * from facility;

Q8 
select * from orders;
select * from orderdetails;
select * from products;
select * from productlines; 



CREATE VIEW product_category_sales AS
SELECT 
    pl.productLine AS productLine,
    SUM(od.quantityOrdered * od.priceEach) AS total_sales,
    COUNT(DISTINCT (o.orderNumber)) AS number_of_orders
FROM 
    products as p 
JOIN 
    OrderDetails as od ON p.productCode = od.productCode
JOIN 
    Productlines as pl ON pl.productLine = p.productLine
JOIN 
    Orders as o ON o.orderNumber = od.orderNumber
GROUP BY 
productLine
having number_of_orders;
    
SELECT * FROM product_category_sales;


Q9
select * from customers;
select * from payments;

DELIMITER //

CREATE PROCEDURE Get_country_payments(IN input_year INT, IN input_country VARCHAR(100))
BEGIN
    SELECT 
        YEAR(p.paymentDate) AS year,
        c.country,
        Concat(round(SUM(p.amount) / 1000, 0),"k") AS total_amount
    FROM 
        payment p
    JOIN 
        customers c ON p.customernumber = c.customernumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country
    GROUP BY 
        YEAR, c.country;
END //

call Get_country_payments(2003,"france");


	Q10 - A
    select * from customers;
    select * from orders;
SELECT 
    c.customername,
    COUNT(o.ordernumber) AS order_count, 
    dense_rank() OVER (ORDER BY COUNT(o.ordernumber) DESC) AS order_freqency_rank
FROM 
    Customers as c
inner JOIN 
    Orders as o ON c.customernumber = o.customernumber
GROUP BY 
    c.customername
ORDER BY 
    order_count desc;
    
  Q10 - B   
    select * from orders;
    select year (orderdate) as year,
    monthname(orderdate) as month_name,
    count(ordernumber) as total_orders,
    lag(count(ordernumber)) over(order by year(orderdate)) as prv_orders,
    concat(round((count(ordernumber)-lag(count(ordernumber)) over(order by year(orderdate)))/
lag(count(ordernumber)) over(order by year(orderdate))*100,0),"%") as YOY_changes
from orders 
group by year, month_name;
    
Q11 
select * from products;
select avg(buyprice) as avg_buyprice from products;
select productline,count(*) as total
from products
where buyprice >(select avg(buyprice) from products) 
group by productline
order by total desc; 

Q12 
delimiter // 
create procedure emp_eh( in empid int, emp_name varchar(50), in email_address varchar(50) ) 
begin 
declare exit handler for 1048 select "DO NOT ENTER NULL VALUES" as message;
declare exit handler for 1062 select "DO NOT ENTER DUPLICATE VALUES" as message;
declare exit handler for sqlexception select "ERROR OCCURED" as message;

insert into emptbl2 values (empid,emp_name,email_address);
select * from emp_eh;
end // 

call emp_eh(1, null, "LOIHKJNS@MSD");
call emp_eh(2, "Nizamuddin", "nizamuddinshaikh026@gmail.com");


Q13 
create table emp_bit(name varchar(50), occupation varchar(50), working_date date, working_hours int); 
select * from emp_bit; 

insert into emp_bit(name,occupation,working_date, working_hours) values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  


delimiter // 
create trigger before_insert_emp_bit
before insert on emp_bit
for each row 
begin
if new.working_hours < 0 then set new.working_hours = ABS(new.working_hours);
end if;
end // 

select * from emp_bit;


Thank you!!!!! 
