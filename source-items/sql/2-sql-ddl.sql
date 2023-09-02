
-- DML Commands In Depth (Data Manipulation Language)

-- Note/Warning: These SQL commands are auto-commited. Once executed changes are permanent. No rollback option.

-- Note: One difference between MySQL and Oracle SQL is that by default
-- MySQL is case insensitive:
-- select * from <table_name> where columnA = <'text'>; is the same as select * from <table_name> where columnA = <'TEXT'>;
-- but in Oracle SQL the above two queries will return different results.

-- ----------------------------------------------------------------------------------------------------
-- Section 1 - Schema Management (Create/View/Delete/Use)
-- ----------------------------------------------------------------------------------------------------

-- Create a database schema
-- Syntax: create database <schema_name>;
-- Example:
create database customer;

-- View list of all existing schemas (current user has access to)
show databases;

-- View currently active/in use schema
select database();

-- select active schema for use
-- Syntax: use <schema_name>;
-- Example:
use customer;

-- Delete database schema
-- Syntax: drop database <schema_name>;
-- Example:
drop database customer;

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - Table Management (Create/Rename/Alter/Truncate/Drop)
-- ----------------------------------------------------------------------------------------------------

use booksdb;
select database();
show tables;

-- Create new table
-- Syntax: create table <table_name> (column1 datatype, column2 datatype, column3 datatype ....);
-- Example:
create table customer (
	customer_id bigint primary key auto_increment,
    first_name varchar(50) not null,
    last_name varchar(50),
    birthdate date,
    age int,
    constraint is_adult_failed check (age > 18)
);
create table products (
	product_id bigint auto_increment,
    pname varchar(10) not null,
    pstatus char(1) default 'E',
    customer_id bigint,
    primary key (product_id),
    foreign key (customer_id) references customer (customer_id)
);
-- Some notes:
-- 1. Table product references table customer, so customer has to be created first.
-- 2. In the two tables we see the two different ways of defining the primary key; the primary key may consist of more than one column.
-- 3. Primary keys cannot be null.
-- 4. not null vs default: not null means during insert/update you have to give any non null valid value for that column.
-- Default means, if no value is passed during insert for that column, default value will be used. However during insert or update,
-- null is a valid value to set for the column.
-- 5. char vs varchar: char means fixed size in storage, if we set char(10) for example, even if we give as value the string 'Hi',
-- the space used in storage will be for 10 chars. With varchar(10) however the size is not fixed, depending on the size of the string,
-- the required space will be used. In both cases, string longer than the given value will cause failure or data to be truncated.
-- 6. We can add check constraints named or unnamed to prevent invalid data from being inserted in the database.
-- 7. Foreign key can be null, if we don't explicitly say not null, however if value is given,
-- that value must exist in the reference table.
-- 8. auto_increment means if no value is passed, it will take the max value of that table column + 1.

-- For more on create table please see here: https://dev.mysql.com/doc/refman/8.0/en/create-table.html
-- For more on data types please see here: https://dev.mysql.com/doc/refman/8.0/en/data-types.html

-- ----------------------------------------------------------------------------------------------------
-- Sub-Section - These are non DDL commands but we will experiment a bit to better understand the above
-- These are DML and DQL commands that we will see and explain in more detail in their own sections.

-- Tables are initially empty
select * from customer;
select * from products;

-- customer table
insert into customer 
	(customer_id, first_name, last_name, birthdate, age)
values
	(1, 'Spyros', null, null, null)
; -- will work
insert into customer 
	(customer_id, first_name, last_name, birthdate, age)
values
	(2, 'John', 'Wick', null, 15)
; -- will fail due to age constraint validation
insert into customer 
	(customer_id, first_name, last_name, birthdate, age)
values
	(2, 'John', 'Wick', null, 45)
; -- will work
insert into customer 
	(first_name, last_name, birthdate, age)
values
	('Bruce', 'Willis', null, 45)
; -- will work (we removed customer id but will be auto populated due to auto_increment attribute)
insert into customer 
	(customer_id, first_name, last_name, birthdate, age)
values
	(3, 'Nick', null, null, 45)
; -- will fail due to duplicate primary key
select * from customer;

-- products table
insert into products
	(product_id, pname, pstatus, customer_id)
values
	(3, 'R7', null, 4)
; -- will fail because we gave inexistent foreign key
insert into products
	(product_id, pname, pstatus, customer_id)
values
	(2, 'Ryzen 7 1700', null, 1)
; -- will fail because data is too long for column pname
insert into products
	(product_id, pname, pstatus, customer_id)
values
	(3, 'R7 ', null, 1)
; -- will work
insert into products
	(product_id, pname, pstatus, customer_id)
values
	(5, 'R8 ', 'D', 3)
; -- will work
insert into products
	(pname, customer_id)
values
	('R9 ', 2)
; -- will work

delete from customer where customer_id = '1'; -- will fail because there are data in table products that reference that customer id

select * from customer;
select * from products;

-- End of Sub-Section -
-- ----------------------------------------------------------------------------------------------------

-- Create table with select from another table - using where clause we can only keep data that satisfy certain conditions
-- Syntax: create table <backup_table_name> select * from <original_table_name>;
-- Example:
create table customer_backup_26082023 select * from customer;

select * from customer_backup_26082023;

-- Create table with same structure of another table but without data
-- Syntax: create table <clone_table_name> select * from <original_table_name> where 1 = 2;
-- Example:
create table products_clone select * from products where 1 = 2; -- 1 = 2 will never be true and is used to insert no data

select * from products_clone; -- no data

desc products;
desc products_clone; -- notice that PK/FK/auto_increment/check constraints etc are not copied on the new table, only the structure.

-- Rename table
-- Syntax: rename table <original_table_name> to <new_table_name>;
-- Example:
rename table products to product;

select * from products; -- no table with name products now
select * from product;

-- Alternatively alter can be used
-- Syntax: alter table <original_table_name> to <new_table_name>;
-- Example:
alter table products_clone rename products_clone2;

select * from products_clone; -- no table with this name now
select * from products_clone2;

-- Alter table
-- Alter table can be used to modify the attributes of existing tables, viewe or any database object
-- Depending on the DBMS and its settings, what is allowed and what is not allowed to alter might slightly differ

-- Remove column from table
-- Syntax: alter table <table_name> drop <column_name>;
alter table customer drop age;
-- confirm column is removed
desc customer;
-- Add column to table
-- Syntax: alter table <table_name> add <column_name>;
alter table customer add age int constraint is_adult_failed check (age > 18);
-- confirm column is added back
desc customer;

-- For more on alter table please see here: https://dev.mysql.com/doc/refman/8.0/en/alter-table.html

-- Truncate table
-- Truncate drops and creates again the table but without data
select * from customer_backup_26082023; -- table has data before truncate

-- Syntax: truncate <table_name>;
-- Example:
truncate customer_backup_26082023;

select * from customer_backup_26082023; -- no data after truncate but table still exists

-- Alternatively - However this is wrong way to delete all data from a table
-- Syntax: delete from <table_name>;
delete from customer_backup_26082023; -- without where clause it will delete all data from the table

-- View table details
-- Syntax A: describe <table_name>;
-- Syntax B: desc <table_name>;
-- Example:
desc customer;

-- Drop table
-- Syntax: drop table <table_name>;
-- Example:
drop table customer_backup_26082023;
drop table products_clone2;

-- Truncate vs Delete vs Drop
-- Truncate: Truncate is used to delete all the data from a table but keep the table itself.
-- Truncate will drop and create again the table.
-- Delete: without where clause will also empty the table. However because delete will have to go through the whole
-- table and delete each row individually, which is a lot slower and resource intensive than truncate.
-- Drop: Completely deletes the table and all its data.

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - Views (Virtual Tables) (Create/Drop)
-- ----------------------------------------------------------------------------------------------------

-- Views are Virtual Tables based on the result set of an SQL Statement

-- Example:
select	c.customer_id, c.first_name, c.last_name, p.product_id, p.pname, p.pstatus
from	customer as c, product as p
where	c.customer_id = p.customer_id;
-- With above query we get all customers and their products with only specified columns
-- Products without customer (if any exist) won't be in the result set

-- Create view
-- Syntax: create view <viewname> as select <columnnameA>, <columnnameB>, .... from <tablenamea>, <tablenameb>, .... WHERE <conditions>;
-- Example:
create view customer_products as
	select	c.customer_id, c.first_name, c.last_name, p.product_id, p.pname, p.pstatus
	from	customer as c, product as p
	where	c.customer_id = p.customer_id
;

-- Now instead of previous big query we can just do:
select * from customer_products; -- and get same results

-- Update view
-- Syntax: create or replace view <viewname> as select <columnnameA>, <columnnameB>, .... from <tablenamea>, <tablenameb>, .... WHERE <conditions>;
-- Example:
create or replace view customer_products as
	select	c.customer_id, c.first_name, c.last_name, c.age, p.product_id, p.pname, p.pstatus
	from	customer as c, product as p
	where	c.customer_id = p.customer_id
;
-- create or replace, if view exists it will change it (if there is anything different) or create it if it doesn't exist

desc customer_products;

-- Drop view
-- Syntax: drop view <viewname>;
-- Example:
drop view customer_products;

-- Note: Not all views allow insert/update/delete operations, it depends upon the DBMS and the way view was created.
-- SQL commands like insert/update/delete affect the actual data in their tables and not only the view.
-- For more on views please see here: https://dev.mysql.com/doc/refman/8.0/en/views.html

-- ----------------------------------------------------------------------------------------------------

-- Clean-up DB
drop table product;
drop table customer;

show tables;


