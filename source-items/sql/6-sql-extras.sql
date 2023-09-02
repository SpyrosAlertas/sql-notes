
-- Extras

-- Content:
-- 1. DB Links
-- 2. Explain
-- 3. System Variables

-- ----------------------------------------------------------------------------------------------------
-- Section 1 - DB Links (Oracle SQL only not supported by MySQL currently)
-- ----------------------------------------------------------------------------------------------------

-- DB Links allow a DB user to access another database

select * from dba_db_links; -- all DB links defined in the database
select * from all_db_links; -- all DB links that current user has access to
select * from user_db_links; -- all DB links owned by current user

-- Private vs Public DB Links
-- Private DB Links can be used only by their owner
-- Public DB Links can be used by any DB user assuming the user has privileges to access the other database

-- Create Public DB Link
create public database link dblink
connect to product_db_username identified by product_db_password
using '<oracle_sid>'; -- sid: service id

-- Create Private DB Link
create database link dblink
connect to product_db_username identified by product_db_password
using '<oracle_sid>'; -- sid: service id

-- Using DB Links
select * from tablename@dblink; -- tablename any table from remote db and @ means what follows is a db link

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - Explain
-- ----------------------------------------------------------------------------------------------------

-- Use explain to see the complexity of below query
select		a.first_name, a.last_name, count(b.book_id) number_of_books -- print only first, last name and number of books
from		author a
left join	book b
on			a.author_id = b.author_id -- Up to here we just joined the all authors with their books
group by	a.author_id -- now we group by the results by author_id
order by	number_of_books desc
limit		1; -- MySQL only

-- Explain
explain
select		a.first_name, a.last_name, count(b.book_id) number_of_books -- print only first, last name and number of books
from		author a
left join	book b
on			a.author_id = b.author_id -- Up to here we just joined the all authors with their books
group by	a.author_id -- now we group by the results by author_id
order by	number_of_books desc
limit		1; -- MySQL only

-- ----------------------------------------------------------------------------------------------------
-- Section 3 - System Variables
-- ----------------------------------------------------------------------------------------------------

-- Global Variables
select @@global.autocommit; -- check default initial value

set global autocommit = 0; -- change to 0 or 1 based on what you had before and see it changed to the new value
set @@global.autocommit = 0;
-- Try to restart the session or even the server and see the global variable is the same
set @@global.autocommit = 1; -- revert to orinal value again - for me it was 151

-- Persisting Global Variables to mysqld-auto.cnf - these values will be loaded to global variables upon server restart
set persist autocommit = 0;
set @@persist.autocommit = 0;

reset persist; -- remove peristed system variables

-- Setting Session Variables
select @@autocommit; -- check default initial value
select @@global.autocommit; -- see global variable remains unchanged

set autocommit = 0; -- or
set @@autocommit = 0; -- or
set @@session.autocommit = 0;

-- Find variables global and session
show global variables like '%auto%';
show variables like '%auto%';

-- Three important System Variables are:
-- 1. autocommit: If it's ON/1 it means that executing a DML Command, it will be autocommitted - no option to rollback
-- 2. sql_safe_updates: If it's ON/1 it means that DML commands like Update & Delete are allowed to be executed
--    only when a primary key is included in the where clause
-- 3. sql_mode: This defines the behavior of the session. The default values are there for a reason and you should not
--    mess with these unless you really know what you are doing
select @@global.sql_mode; -- global (default) sql_mode settings
select @@sql_mode; -- session sql_mode settings



