
-- DML Commands In Depth (Data Manipulation Language)

-- Note: One difference between MySQL and Oracle SQL is that by default
-- MySQL is case insensitive:
-- select * from <table_name> where columnA = <'text'>; is the same as
-- select * from <table_name> where columnA = <'TEXT'>;
-- but in Oracle SQL the above two queries will return different results

-- From CRUD (Create-Read-Update-Delete) Operations, DML covers Create/Update/Delete.

-- Note: Insert/Update/Delete are DDL commands; start transaction/commit/rollback are TCL commands

-- ----------------------------------------------------------------------------------------------------
-- Section 0 - PREPARATION
-- ----------------------------------------------------------------------------------------------------

-- Note: In MySQL by default only safe update/delete is allowed, which means only by using a primary key
-- in where clause. To change this please run below two commands:
set global sql_safe_updates = 0; -- disable safe updates for all sessions
set sql_safe_updates = 0; -- disable safe updates for current session only

show global variables like 'sql_safe_updates';
show variables like 'sql_safe_updates';

-- This global variable is ignored in MySQL Workbench unless you change below setting:
-- MySQL Workbench -> Edit -> Preferences -> SQL Editor -> Uncheck Safe Updates box at the end

-- Note: In MySQL even DML commands are autocommited. There are two methods to work around this:
-- Method 1: Disable auto-commit variable to 0
set global autocommit = 0; -- disable autocommit for all sessions
set autocommit = 0; -- disable autocommit for current session only

show global variables like 'autocommit';
show variables like 'autocommit';

-- This global variable is also ignored unless you change below setting:
-- MySQL Workbench -> Edit -> Preferences -> SQL Execution -> Uncheck New connections use auto commit mode

-- Method 2: Start a transaction before executing DML commands
start transaction;
-- run DML commands - changes won't saved untill you commit or rollback
commit;
-- or
rollback;
-- to complete the transaction by saving or reverting the changes.

-- Note: If you commit or rollback, then you have to start another transaction, else DML commands will auto-commit again
-- Note: Each time start transaction; is executed, pending changes in current session will be committed

-- ----------------------------------------------------------------------------------------------------
-- Section 1 - INSERT
-- ----------------------------------------------------------------------------------------------------

use booksdb;

desc book;

-- Syntax: insert into <table_name>
-- Example:
start transaction;
insert into book
	(title, release_year, book_language)
values
	('New Experimental Cook Book', 2004, 'English')
;
commit;
rollback; -- if you rollback before commit, change will be lost, if you rollback after commit, change is permanent already
select * from book where title = 'New Experimental Cook Book';

-- If you give all values in same order as they appear in table, syntax can change as below (skipping column names):
-- Syntax:
-- insert into book (value1, value2, ....);

-- Insert using select (can also be from different table)
-- Syntax: insert into <table_name> <columnA, columnB, .... > select <columnA, columnB> from <table_name> where <conditions>;
-- Example:
start transaction;
insert into book
	(title, release_year, book_language)
	select 'Animal Farm v2', release_year + 5, book_language
    from book
    where title = 'Animal Farm'
;
commit;
select * from book where title = 'Animal Farm';
select * from book where title = 'Animal Farm v2';

-- For more on Insert please see here: https://dev.mysql.com/doc/refman/8.0/en/insert.html

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - UPDATE
-- ----------------------------------------------------------------------------------------------------

-- Hint: Before update it's always a good idea to run a select query, to check what the where clause will return
-- If the were clause is not correct, undesired rows may be updated, if you do select first you can confirm
-- it works as should. Same advice goes for delete.

select * from book where title = 'New Experimental Cook Book'; -- 1 row

-- Syntax: update <table_name> set <columnA = 'valueA', columnB = 'valueB', ....> where <conditions>;
-- Example:
start transaction;
update book
set release_year = 2006
where title = 'New Experimental Cook Book'; -- 1 row updated
commit; -- if more than expected rows are updated rollback and check

-- For more on Update please see here: https://dev.mysql.com/doc/refman/8.0/en/update.html

-- ----------------------------------------------------------------------------------------------------
-- Section 3 - DELETE
-- ----------------------------------------------------------------------------------------------------

select * from book where title = 'Animal Farm v2'; -- 1 row
select * from book where title = 'New Experimental Cook Book'; -- 1 row

-- Syntax: delete from <table_name> where <conditions>;
-- Example:
start transaction;
delete from book
where title = 'New Experimental Cook Book'; -- 1 row deleted
delete from book
where title = 'Animal Farm v2'; -- 1 row deleted
commit;

-- For more on Delete please see here: https://dev.mysql.com/doc/refman/8.0/en/delete.html







