CREATE TABLE branch (id int PRIMARY KEY, name varchar(30) NOT NULL UNIQUE);
INSERT INTO branch VALUES (1,'Rwanda');
INSERT INTO branch VALUES (2,'Uganda');
INSERT INTO branch VALUES (3,'Mali');
INSERT INTO branch VALUES (4,'Togo');
INSERT INTO branch VALUES (5,'Chad');

CREATE TABLE item_type (id int PRIMARY KEY, name varchar(30) NOT NULL UNIQUE);
INSERT INTO item_type VALUES (1,'Computers');
INSERT INTO item_type VALUES(2,'Fridges');
INSERT INTO item_type VALUES(3,'Phones');

CREATE TABLE item (id int PRIMARY KEY, name varchar(30),item_type_id int, price float, FOREIGN KEY (item_type_id) REFERENCES item_type(id));
INSERT INTO item VALUES (1,'HP 900',1,1500.25);
INSERT INTO item VALUES (2,'Skyworth',2,2400.75);
INSERT INTO item VALUES (3,'Infinix',3,150.25);
INSERT INTO item VALUES (4,'Lenovo',1,400.3);
INSERT INTO item VALUES (5,'Samsung Fridge',2,1750.74);
INSERT INTO item VALUES (6,'Techno C9',3,120.4);
INSERT INTO item VALUES (7,'Windows',1,890.1);
INSERT INTO item VALUES (8,'Sony Fridge',2,2800.7);
INSERT INTO item VALUES (9,'Alienware',1,3000.34);
INSERT INTO item VALUES (10,'Dell',1,350.45);
INSERT INTO item VALUES (11,'iPhone XR',3,575.36);
INSERT INTO item VALUES (12,'Techno C9',3,80.43);

CREATE TABLE customers (id int PRIMARY KEY,f_name varchar(30),l_name varchar(30),branch_id int,FOREIGN KEY (branch_id) REFERENCES branch(id));
INSERT INTO customers VALUES (1,'Sheldon','Cooper',1);
INSERT INTO customers VALUES (2,'Leonard','Nimoy',1);
INSERT INTO customers VALUES (3,'Darth','Vader',2);
INSERT INTO customers VALUES (4,'Bruce','Wayne',2);
INSERT INTO customers VALUES (5,'Jim','Gordon',3);
INSERT INTO customers VALUES (6,'Amy','Farrah',4);
INSERT INTO customers VALUES (7,'Richard','Pipper',5);
INSERT INTO customers VALUES (8,'Andre','Johnson',5);
INSERT INTO customers VALUES (9,'Tom','Hanks',3);
INSERT INTO customers VALUES (10,'Jim','Carrey',3);

CREATE TABLE branch_manager (id int,f_name varchar(30),l_name varchar(30),branch_id int,FOREIGN KEY (branch_id) REFERENCES branch(id));
INSERT INTO branch_manager VALUES (1,'Lisa','Joy',1);
INSERT INTO branch_manager VALUES (2,'James','Kevin',2);
INSERT INTO branch_manager VALUES (3,'Iris','Joanna',3);
INSERT INTO branch_manager VALUES (4,'John','Gary',4);
INSERT INTO branch_manager VALUES (5,'Andrew','Bells',5);

CREATE TABLE item_sold (id int PRIMARY KEY,item_id int, quantity int,customer_id int,month_sold varchar(10),FOREIGN KEY (item_id) REFERENCES item(id),FOREIGN KEY(customer_id) REFERENCES customers(id));
INSERT INTO item_sold VALUES (1,2,6,2,'February');
INSERT INTO item_sold VALUES (2,1,1,4,'February');
INSERT INTO item_sold VALUES (3,4,4,6,'March');
INSERT INTO item_sold VALUES (4,3,1,8,'February');
INSERT INTO item_sold VALUES (5,6,8,10,'March');
INSERT INTO item_sold VALUES (6,5,2,3,'May');
INSERT INTO item_sold VALUES (7,8,3,5,'January');
INSERT INTO item_sold VALUES (8,7,2,7,'May');
INSERT INTO item_sold VALUES (9,10,2,9,'March');
INSERT INTO item_sold VALUES (10,9,1,1,'April');