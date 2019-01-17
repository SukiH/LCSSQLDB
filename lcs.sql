/*
Author: Suki Harrison
Student ID: 17655881
Creation Date: 2019-01-05
Purpose: CMP2060M Assessment Item 2
Title: Lincoln Computer Surgery Database Script
Contents:
Line 32    Clear Historical Database (Commented Out)
Line 34    Create New Database
Line 36    Create Strong Entities as Tables
Line 80    Create Weak Entities as Tables
Line 110    Create Many-to-Many tables
Line 125    Create Multi Valued Tables
Line 131    Add Table Constraints
Line 132    Add Foreign Keys to tables
Line 166    DDL Ends & DML starts
Line 169    Add additional default values
Line 176    Insert Sample Data
Line 286    Delete a record
Line 289    Update a record
Line 292    Select all staff
Line 295    Left Join Select
Line 300    Inner Join Select
Line 304    Right Join Select
Line 308    Union Select
Line 313    Duplicate Database
Line 353    Create User in Database
Line 358    Create Stored Procedure
Line 374    Call Stored Procedure
Notes:
    We have left the two lines of code at the begining commented out so that we can rerun this script again. Uncomment these lines to wipe all data this script created and recreate it all*/
#DROP USER IF EXISTS 'lcsUser';
#DROP DATABASE IF EXISTS lcs; # Clear previous iteration of this Database so we can start fresh
CREATE DATABASE IF NOT EXISTS  lcs; # Create the new database for us to work on

#Starting Table Creation
CREATE TABLE IF NOT EXISTS lcs.Customer (
    email varchar(255) NOT NULL,
    date_Of_Birth datetime,
    name varchar(255),
    house_No varchar(255),
    street varchar(255),
    city varchar(255),
    post_Code varchar(20),
    PRIMARY KEY (email));  

CREATE TABLE IF NOT EXISTS lcs.Locations(
    name varchar(255) NOT NULL,
    price integer,
    PRIMARY KEY (name));

CREATE TABLE IF NOT EXISTS lcs.Staff(
    email varchar(255) NOT NULL,
    name varchar(255),
    PRIMARY KEY (email));

CREATE TABLE IF NOT EXISTS lcs.Services(
    name varchar(255) NOT NULL,
    items_Name varchar(255),
    price integer,
    PRIMARY KEY (name));

CREATE TABLE IF NOT EXISTS lcs.Items(
    name varchar(255) NOT NULL,
    stock integer,
    PRIMARY KEY (name));

CREATE TABLE IF NOT EXISTS lcs.Statuses(
    name varchar(255) NOT NULL,
    PRIMARY KEY (name));

CREATE TABLE IF NOT EXISTS lcs.Third_Party_Supplier(
    name varchar(255) NOT NULL,
    house_No varchar(255),
    street varchar(255),
    city varchar(255),
    post_Code varchar(20),
    PRIMARY KEY (name));

#Weak Entity Creation
CREATE TABLE IF NOT EXISTS lcs.Customer_Order(
    order_Date datetime NOT NULL,
    staff_Email varchar (255) NOT NULL,
    customer_Email varchar (255) NOT NULL,
    status_Name varchar (255) NOT NULL,
    locations_Name varchar (255) NOT NULL,
    house_No varchar(255),
    street varchar(255),
    city varchar(255),
    post_Code varchar(20),
    PRIMARY KEY (order_Date));

CREATE TABLE IF NOT EXISTS lcs.Invoice(
    issue_Date datetime NOT NULL,
    cust_Order_Date datetime NOT NULL,
    staff_Email varchar (255) NOT NULL,
    order_Staff_Email varchar (255) NOT NULL,
    customer_Email varchar (255) NOT NULL,
    status_Name varchar (255) NOT NULL,
    completion_Date dateTime,
    PRIMARY KEY (issue_Date));

CREATE TABLE IF NOT EXISTS lcs.Purchase_Order(
    order_Date datetime NOT NULL,
    supplier_Name varchar(255) NOT NULL,
    status_Name varchar (255) NOT NULL,
    description varchar(255),
    PRIMARY KEY (order_Date));

#Many to Many Table Creation
CREATE TABLE IF NOT EXISTS lcs.Ordered_Services(
    service_Name varchar(255) NOT NULL,
    cust_Order_Date datetime NOT NULL,
    staff_Email varchar(255) NOT NULL,
    customer_Email varchar(255) NOT NULL,
    discount integer,
    quantity integer);

CREATE TABLE IF NOT EXISTS lcs.Ordered_Items(
    item_Name varchar(255) NOT NULL,
    purchase_Order_Date datetime NOT NULL,
    supplier_Name varchar(255) NOT NULL,
    cost_Per_Item integer);

#Multi-Value table creation
CREATE TABLE IF NOT EXISTS lcs.Customer_Numbers(
    tel_Number varchar(255) NOT NULL,
    customer_Email varchar(255) NOT NULL,
    PRIMARY KEY (tel_Number));

#Adding Table Constraints
#Adding Foreign Keys to tables
ALTER TABLE lcs.Customer_Order
ADD CONSTRAINT fk_Cust_Order_Staff FOREIGN KEY (staff_Email) REFERENCES lcs.Staff (email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Cust_Order_Customer FOREIGN KEY (customer_Email) REFERENCES lcs.Customer (email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Cust_Order_Status FOREIGN KEY (status_Name) REFERENCES lcs.Statuses (name) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Cust_Order_Location FOREIGN KEY (locations_Name) REFERENCES lcs.Locations (name) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE lcs.Invoice
ADD CONSTRAINT fk_Invoice_Cust_Order FOREIGN KEY (cust_Order_Date) REFERENCES lcs.Customer_Order (order_Date) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Invoice_Order_Staff FOREIGN KEY (order_Staff_Email) REFERENCES lcs.Customer_Order (staff_Email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Invoice_Customer FOREIGN KEY (customer_Email) REFERENCES lcs.Customer_Order (customer_Email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Invoice_Staff FOREIGN KEY (staff_Email) REFERENCES lcs.Staff (email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Invoice_Status FOREIGN KEY (status_Name) REFERENCES lcs.Statuses (name) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE lcs.Purchase_Order
ADD CONSTRAINT fk_Purchase_Order_Supplier FOREIGN KEY (supplier_Name) REFERENCES lcs.Third_Party_Supplier (name) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Purchase_Order_Status FOREIGN KEY (status_Name) REFERENCES lcs.Statuses (name) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE lcs.Ordered_Services
ADD CONSTRAINT fk_Ordered_Services_Service FOREIGN KEY (service_Name) REFERENCES lcs.Services (name) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Ordered_Services_Cust_Order FOREIGN KEY (cust_Order_Date) REFERENCES lcs.Customer_Order (order_Date) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Ordered_Services_Staff FOREIGN KEY (staff_Email) REFERENCES lcs.Customer_Order (staff_Email) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Ordered_Services_Customer FOREIGN KEY (customer_Email) REFERENCES lcs.Customer_Order (customer_Email) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE lcs.Ordered_Items
ADD COLUMN quantity integer AFTER supplier_Name, #We add a column here that we realised we had missed before. We wouldn't do this in a real deployment for a client, but the CRG requires it.
ADD CONSTRAINT fk_Ordered_Items_Item FOREIGN KEY (item_Name) REFERENCES lcs.Items (name) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Ordered_Items_Purchase_Order FOREIGN KEY (purchase_Order_Date) REFERENCES lcs.Purchase_Order (order_Date) ON UPDATE CASCADE ON DELETE RESTRICT,
ADD CONSTRAINT fk_Ordered_Items_Supplier FOREIGN KEY (supplier_Name) REFERENCES lcs.Purchase_order (supplier_Name) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE lcs.Customer_Numbers
ADD CONSTRAINT fk_Customer_Numbers_Customer FOREIGN KEY (customer_Email) REFERENCES lcs.Customer (email) ON UPDATE CASCADE ON DELETE CASCADE;

/*########DDL STOPS########
###########################
#########DML BEGINS######*/

#Adding additional default values
ALTER TABLE lcs.Locations ALTER price SET DEFAULT 0;

ALTER TABLE lcs.Services ALTER price SET DEFAULT 0;

ALTER TABLE lcs.Items ALTER stock SET DEFAULT 0;

#The following Insert Sample Data
#Insert Sample Data into the customer table
INSERT INTO lcs.Customer (email, date_Of_Birth, name, house_No, street, city, post_Code) VALUES
('Steve@example.com', '1993-02-23', 'Steve', '1', '1st Street', '1st City', 'LN1 1ST'),
('killer@1337hax.gg', '1987-06-14', 'Tara', '2', '2nd Street', '1st City', 'LN2 2ND'),
('Dude@Geoff.com', '1971-11-30', 'Geoff', '3', '3rd Street', '1st City', 'LN3 3RD'),
('pleb@plebians.com', '1996-01-01', 'Plebus', '4', '4th Street', '1st City', 'LN4 4TH'),
('Dave@smash.com', '1964-07-08', 'Dave', '5', '5th Street', '1st City', 'LN5 5TH');

#Insert Sample Data into the Staff table
INSERT INTO lcs.Staff (email, name) VALUES
('jez@lcs.uk','Jez'),
('yan@lcs.uk','Yan'),
('soma@lcs.uk','Soma'),
('atir@lcs.uk','Atir'),
('ben@lcs.uk','Benjamin');

#Insert Sample Data into the Locations table
INSERT INTO lcs.Locations (name, price) VALUES
('LCS', 0),
('Lincoln_Univeristy', 5),
('Customer_House', 50), 
('Asda_Hykeham', 20);

#Insert Sample Data into the Items table
INSERT INTO lcs.Items (name, stock) VALUES
('GPU', 5),
('MOBO', 5),
('CPU', 5),
('RAM', 20),
('Modem', 5),
('Network_Cable', 20),
('Network_Switch',10),
('HDD', 0);

#Insert Sample Data into the Services table
INSERT INTO lcs.Services (name, items_Name, price) VALUES
('Upgrade_GPU','GPU',250),
('Upgrade_MOBO','MOBO',250),
('Upgrade_CPU','CPU',200),
('Upgrade_RAM','RAM',50),
('Hardware_Repair',NULL,50),
('Software_Error',NULL,15),
('Networking_Cables','Network_Cable',10),
('Networking_Switches','Network_Switch',400),
('Internet','Modem',50),
('User_Training',NULL,50),
('Back_Up',NULL,20),
('Restore',NULL,0),
('Anti_Virus',NULL,30),
('Maintenance',NULL,25);

#Insert Sample Data into the Statuses table
INSERT INTO lcs.Statuses (name) VALUES
('Pending'),
('Confirmed'),
('Despatched'),
('Paid'),
('Cancelled'),
('Refunded'),
('Recieved');

#Insert Sample Data into the Third Party Supplier table
INSERT INTO lcs.Third_Party_Supplier (name, house_No, street, city, post_Code) VALUES
('Scan', 25, 'Enterprise Park', 'Bolton', 'BL6 6PE'),
('Ebuyer', 0, 'Ferry Road', 'Howden', 'DN14 7UW'),
('Cisco', 9, 'Bedfont Lakes', 'Feltham', 'TW14 8HA');

#Insert Sample Data into the Customer Order table
INSERT INTO lcs.Customer_Order (order_Date, staff_Email, customer_Email, status_Name, locations_Name, house_No, street, city, post_Code) VALUES
('20190102T092342', 'ben@lcs.uk', 'killer@1337hax.gg', 'Cancelled', 'Asda_Hykeham', 2, '2nd Street', '1st City', 'LN2 2ND'),
('20190104T114121', 'yan@lcs.uk', 'Steve@example.com', 'Despatched', 'Customer_House', 1, '1st Street', '1st City', 'LN1 1ST'),
('20190106T151259', 'soma@lcs.uk', 'killer@1337hax.gg', 'Pending', 'Customer_House', 2, '2nd Street', '1st City', 'LN2 2ND');

#Insert Sample Data into the Invoice table
INSERT INTO lcs.Invoice (issue_Date, cust_Order_Date, staff_Email, order_Staff_Email, customer_Email, status_Name, completion_Date) VALUES
('20190103T090224', '20190102T092342', 'atir@lcs.uk', 'ben@lcs.uk', 'killer@1337hax.gg', 'Refunded', '20190106T151859'),
('20190104T114921', '20190104T114121', 'atir@lcs.uk', 'yan@lcs.uk', 'Steve@example.com', 'Paid', '20190104T132205'),
('20190106T151602', '20190106T151259', 'ben@lcs.uk', 'soma@lcs.uk', 'killer@1337hax.gg', 'Pending', NULL);

#Insert Sample Data into the Purchase Order table
INSERT INTO lcs.Purchase_Order (order_Date, supplier_Name, status_Name, description) VALUES
('20190101T090000', 'Scan', 'Recieved', 'Initial Generic Stock'),
('20190102T110000', 'Cisco', 'Recieved', 'Networking Stock Order');

#Insert Sample Data into the Ordered Services table
INSERT INTO lcs.Ordered_Services (service_Name, cust_Order_Date, staff_Email, customer_Email, discount, quantity) VALUES
('Upgrade_GPU', '20190102T092342', 'ben@lcs.uk', 'killer@1337hax.gg', 0, 1),
('Networking_Switches', '20190104T114121', 'yan@lcs.uk', 'Steve@example.com', 10, 1),
('Networking_Cables', '20190104T114121', 'yan@lcs.uk', 'Steve@example.com', 25, 4),
('Upgrade_GPU', '20190106T151259', 'soma@lcs.uk', 'killer@1337hax.gg', 50, 1),
('Upgrade_RAM', '20190106T151259', 'soma@lcs.uk', 'killer@1337hax.gg', 0, 4);

#Insert Sample Data into the Ordered Items table
INSERT INTO lcs.Ordered_Items (item_Name, purchase_Order_Date, supplier_Name, quantity, cost_Per_Item) VALUES
('GPU', '20190101T090000', 'Scan', 6, 180),
('MOBO', '20190101T090000', 'Scan', 5, 150),
('CPU', '20190101T090000', 'Scan', 5, 130),
('RAM', '20190101T090000', 'Scan', 24, 30),
('Modem', '20190102T110000', 'Cisco', 5, 20),
('Network_Cable', '20190102T110000', 'Cisco', 24, 3),
('Network_Switch', '20190102T110000', 'Cisco', 11, 250);

#Insert Sample Data into the Customer Numbers table
INSERT INTO lcs.Customer_Numbers (tel_Number, customer_Email) VALUES
('07834 123456', 'Steve@example.com'),
('07123 456789', 'pleb@plebians.com'),
('07143 013370', 'killer@1337hax.gg'),
('01552 013370', 'killer@1337hax.gg');

#Delete statement to remove a customer from the Database
DELETE FROM lcs.Customer WHERE lcs.Customer.email = 'pleb@plebians.com';

#Update statment to correct staff member Ben's name from 'Benjamin' to 'Ben'
UPDATE lcs.Staff SET lcs.Staff.name = 'Ben' WHERE lcs.Staff.email = 'ben@lcs.uk';

#Standard Select statement to draw up a list of staff
SELECT Staff.email, Staff.Name FROM lcs.Staff;

#Select all orders, and the customers associated with those orders to demonstrate LEFT JOIN
SELECT customer_Order.order_Date, customer_Order.staff_Email, customer_Order.status_Name, customer_Order.Locations_Name, 
        customer.email, customer.name,customer.date_Of_Birth
FROM lcs.customer_Order LEFT JOIN lcs.customer ON lcs.customer_Order.customer_Email = lcs.Customer.email;

#Select all services and items where the item is on a service and the service uses an item to demonstrate INNER JOIN
SELECT services.Name AS Service_Name, services.Price AS Service_Cost, items.Name AS Item_Name, items.stock AS Item_Stock
FROM lcs.services INNER JOIN lcs.items ON lcs.services.items_Name = lcs.items.Name;

#Select services, and All items, only showing services which are using an item to demonstrate RIGHT JOIN
SELECT services.Name AS Service_Name, services.Price AS Service_Cost, items.Name AS Item_Name, items.stock AS Item_Stock
FROM lcs.services RIGHT JOIN lcs.items ON lcs.services.items_Name = lcs.items.Name;

#Select all customers and staff using a Union. This could be a useful union, as it will allow us to contact all people involved with the client company
SELECT staff.name, staff.email FROM lcs.Staff
UNION
SELECT customer.name, customer.email FROM lcs.Customer;

#The following duplicates all tables in our database, prefixing 'copy_of_' in front of table names. The method used here will duplicate everything about those tables, including indexes
CREATE TABLE IF NOT EXISTS lcs.copy_of_Customer LIKE lcs.Customer; 
INSERT lcs.copy_of_Customer SELECT * FROM lcs.Customer;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Staff LIKE lcs.Staff; 
INSERT lcs.copy_of_Staff SELECT * FROM lcs.Staff;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Locations LIKE lcs.Locations; 
INSERT lcs.copy_of_Locations SELECT * FROM lcs.Locations;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Services LIKE lcs.Services; 
INSERT lcs.copy_of_Services SELECT * FROM lcs.Services;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Items LIKE lcs.Items; 
INSERT lcs.copy_of_Items SELECT * FROM lcs.Items;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Statuses LIKE lcs.Statuses; 
INSERT lcs.copy_of_Statuses SELECT * FROM lcs.Statuses;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Third_Party_Supplier LIKE lcs.Third_Party_Supplier; 
INSERT lcs.copy_of_Third_Party_Supplier SELECT * FROM lcs.Third_Party_Supplier;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Customer_Order LIKE lcs.Customer_Order; 
INSERT lcs.copy_of_Customer_Order SELECT * FROM lcs.Customer_Order;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Invoice LIKE lcs.Invoice; 
INSERT lcs.copy_of_Invoice SELECT * FROM lcs.Invoice;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Purchase_Order LIKE lcs.Purchase_Order; 
INSERT lcs.copy_of_Purchase_Order SELECT * FROM lcs.Purchase_Order;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Ordered_Services LIKE lcs.Ordered_Services; 
INSERT lcs.copy_of_Ordered_Services SELECT * FROM lcs.Ordered_Services;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Ordered_Items LIKE lcs.Ordered_Items; 
INSERT lcs.copy_of_Ordered_Items SELECT * FROM lcs.Ordered_Items;

CREATE TABLE IF NOT EXISTS lcs.copy_of_Customer_Numbers LIKE lcs.Customer_Numbers; 
INSERT lcs.copy_of_Customer_Numbers SELECT * FROM lcs.Customer_Numbers;

#Adding a user to this database if they don't already exist, set them a password, and ensure they can't drop the database or any tables
CREATE USER IF NOT EXISTS 'lcsUser' IDENTIFIED BY 'password';
SET PASSWORD FOR 'lcsUser' = 'AP455w0rD';
REVOKE DROP ON *.* FROM 'lcsUser';

#Creating a stored procedure that returns all orders and the cost of each part of that order where part of that order includes the service specified by the user as part of the parameter.
DELIMITER //
CREATE PROCEDURE lcs.OrdersWithService(
IN ServiceName VARCHAR(255)
)
BEGIN
    SELECT Customer_Order.order_Date, Customer_Order.staff_Email, Customer_Order.customer_Email, Customer_Order.status_Name, Customer_Order.locations_Name,
            Services.name, Services.price, 
            Ordered_Services.quantity, Ordered_Services.discount, ((Services.price * Ordered_Services.quantity)/100)*(100-Ordered_Services.discount) as Total_Service_Cost
    FROM lcs.Customer_Order 
    INNER JOIN lcs.Ordered_Services ON (lcs.Customer_Order.order_Date = lcs.Ordered_Services.cust_Order_Date)
    INNER JOIN lcs.Services ON (lcs.Ordered_Services.service_Name = lcs.Services.name)
    WHERE Customer_Order.order_Date IN (SELECT ordered_Services.cust_Order_Date FROM lcs.Ordered_Services WHERE ordered_Services.service_Name = ServiceName GROUP BY ordered_Services.cust_Order_Date);
END//
DELIMITER ;

#The following command will call the above procedure with a parameter. A bug with PHPMYADMIN prevents it being called at the same time as all the above so we have commented it out.
#CALL lcs.OrdersWithService('Upgrade_GPU');