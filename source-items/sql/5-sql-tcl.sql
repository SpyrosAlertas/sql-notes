
-- TCL Commands In Depth (Transaction Control Language)

-- Note: As we saw in DML section, normally DML commands (Insert/Update/Delete) are not autocommitted
-- and their changes can be reverted. However in some DBMS like MySQL they are autocommitted.

-- ----------------------------------------------------------------------------------------------------
-- Section 0 - PREPARATION
-- ----------------------------------------------------------------------------------------------------

use booksdb;

-- ----------------------------------------------------------------------------------------------------
-- Section 1 - COMMIT/ROLLBACK
-- ----------------------------------------------------------------------------------------------------

commit; -- data changes made via DML commands in current session will be made permanent
rollback; -- non committed data changes made via DML commands in current session will be reverted

-- commit/rollback have no impact on what is done in other sessions

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - IMPLICIT COMMIT
-- ----------------------------------------------------------------------------------------------------

-- Example of Implicit Commit

select * from book where title = 'Experimental Cooking Recipes'; -- no such book

start transaction;
insert into book (title, release_year, book_language) values ('Experimental Cooking Recipes', 2004, 'English');
-- if you check before rollback book will be there, run rollback and check again, book won't be there anymore
rollback;

-- now we will try again the same as above, but before rollback we will run DQL command create table

start transaction;
insert into book (title, release_year, book_language) values ('Experimental Cooking Recipes', 2004, 'English');
create table tmp (tmp_id int primary key, value varchar(10)); -- now before rollback we will run this DQL command
rollback;

-- now book remains even after rollback - this is because DQL commands like create/drop table autocommit

drop table tmp; -- we no longed need this table

-- ----------------------------------------------------------------------------------------------------
-- Section 3 - START TRANSACTION/BEGIN WORK/BEGIN
-- ----------------------------------------------------------------------------------------------------

-- start transaction = begin work = begin. They do the same thing, start a new transaction
-- running these commands will disable auto-commit setting for DML commands if it's enabled,
-- until transaction is completed (by commit/rollback or implicit commit)

start transaction;
-- execute DQL/DML commands
commit; -- or rollback;

-- or
begin work;
-- execute DQL/DML commands
commit; -- or rollback;

-- or
begin;
-- execute DQL/DML commands
commit; -- or rollback;

-- ----------------------------------------------------------------------------------------------------
-- Section 4 - ROLLBACK TO SAVEPOINT
-- ----------------------------------------------------------------------------------------------------

-- Syntax:
start transaction;
-- execute DQL/DML commands
savepoint pointA; -- pointA can be any valid name you wish
-- execute DQL/DML commands
savepoint pointB;
-- execute DQL/DML commands
-- ..
rollback to savepointA; -- or to any other savepoint you wish to revert to
-- this will result in changes done up to save pointA to be committed
-- but any changes after pointA are reverted
commit;

-- Example:
start transaction;

select * from book where title = 'Experimental Cooking Recipes'; -- we have this book from before
-- change publisher
update book set release_year = 2014 where title = 'Experimental Cooking Recipes';
select * from book where title = 'Experimental Cooking Recipes'; -- see updated release year
savepoint pointUpdate;

delete from book where title = 'Experimental Cooking Recipes'; -- book is deleted
select * from book where title = 'Experimental Cooking Recipes'; -- no such book
savepoint pointDelete;

rollback to pointUpdate; -- keep changes up to that save point and revert anything done below that point
commit;

select * from book where title = 'Experimental Cooking Recipes'; -- book will be there with updated release year

-- ----------------------------------------------------------------------------------------------------
-- Section 5 - ACCESS MODES: READ WRITE vs READ ONLY
-- ----------------------------------------------------------------------------------------------------

-- Syntax:
start transaction read only;

start transaction read write;
start transaction; -- by default this will also get read write access mode

-- Example
start transaction read only;
select * from book where title = 'Experimental Cooking Recipes'; -- book will be there with updated release year
update book set release_year = 2013 where title = 'Experimental Cooking Recipes'; -- this or any other DML command (insert/update/delete) will fail
commit;

start transaction read write; -- or start transaction; has the same access mode
select * from book where title = 'Experimental Cooking Recipes'; -- book will be there with updated release year
update book set release_year = 2013 where title = 'Experimental Cooking Recipes'; -- now both commands will work
commit;

-- ----------------------------------------------------------------------------------------------------
-- Section 6 - TRANSACTION ISOLATION LEVELS: READ UNCOMMITTED
-- ----------------------------------------------------------------------------------------------------

-- Note: Transaction Isolation Level can only be set before transaction starts, not during.

-- Read uncommitted else dirty reads: this isolation level allows you to see changes that are not yet committed
-- Lowest Isolation Level
-- Effects: (1) Dirty Reads, (2) Non Repeatable Reads (3) Phantom Reads
-- Solves: -

-- Session A: Start
start transaction;
select * from book where title = 'Experimental Cooking Recipes';
-- change release year from 2013 to 2015
update book set release_year = 2015 where title = 'Experimental Cooking Recipes';
-- before commit - go to part Session B
commit; -- once steps on Session B are done, do commit
-- Session A: End

-- Copy the content of Session B in another session
-- Session B: Start
set transaction isolation level read uncommitted;
start transaction; -- now isolation level is set to read uncommitted
-- release year will be 2015, even though change is not committed yet
select * from book where title = 'Experimental Cooking Recipes';
commit;
-- Session B: End

-- ----------------------------------------------------------------------------------------------------
-- Section 7 - TRANSACTION ISOLATION LEVELS: READ COMMITTED
-- ----------------------------------------------------------------------------------------------------

-- Note: Transaction Isolation Level can only be set before transaction starts, not during.

-- Read committed: this isolation level allows you to only see committed changes
-- Second Lowest Isolation Level
-- Effects: (1) Non Repeatable Reads (2) Phantom Reads
-- Solves: (1) Dirty Reads (Uncommitted Changes)

-- Non Repeatable Reads: Same query in one transaction will read different values due to changes made by a different transaction

-- Session A.1: Start
-- go to Session B.1
-- Session A.1: End

-- Session A.2: Start
start transaction;
update book set release_year = 2005 where title = 'Experimental Cooking Recipes';
commit;
-- go to Session B.2
-- Session A.2: End

-- Session A.3: Start
start transaction;
update book set release_year = 2035 where title = 'Experimental Cooking Recipes';
commit;
-- go to Session B.3
-- Session A.3: End

-- Copy the content of Session B in another session
-- Session B: Start

-- Session B.1: Start
set transaction isolation level read committed; -- set transaction isolation level to read committed
start transaction;
select * from book where title = 'Experimental Cooking Recipes'; -- release year is 2015
-- go to section A.2
-- Session B.1: End

-- Session B.2: Start
select * from book where title = 'Experimental Cooking Recipes'; -- release year is 2005
-- go to section A.3
-- Session B.2: End

-- Session B.3: Start
select * from book where title = 'Experimental Cooking Recipes'; -- release year is 2035
commit;
-- Session B.3: End

-- Notice that at each select in same transaction we read different value for release year.

-- Session B: End

-- ----------------------------------------------------------------------------------------------------
-- Section 8 - TRANSACTION ISOLATION LEVELS: REPEATABLE READ
-- ----------------------------------------------------------------------------------------------------

-- Note: Transaction Isolation Level can only be set before transaction starts, not during.

-- Repeatable read: Guarantees that in one transaction, same query will return same
-- values, even if they are updated by another transaction 
-- Effects: (1) Phantom Reads
-- Solves: (1) Dirty Reads (Uncommitted Changes) (2) Non Repeatable Reads

-- Session A.1: Start
-- go to Session B.1
-- Session A.1: End

-- Session A.2: Start
start transaction;
update book set release_year = 2008 where title = 'Experimental Cooking Recipes';
commit;
-- go to Session B.2
-- Session A.2: End

-- Copy the content of Session B in another session
-- Session B: Start

-- Session B.1: Start
set transaction isolation level repeatable read; -- set transaction isolation level to repeatable read
start transaction;
select * from book where title = 'Experimental Cooking Recipes'; -- release year is 2035
-- go to section A.2
-- Session B.1: End

-- Session B.2: Start
select * from book where title = 'Experimental Cooking Recipes'; -- release year is still 2035
commit;
start transaction;
select * from book where title = 'Experimental Cooking Recipes'; -- now new transaction sees updated value (release year 2008)
commit;
-- Session B.2: End

-- Even though value is updated and committed at another transaction,
-- this isolation level guarantees that results will be the same

-- Session B: End

-- ----------------------------------------------------------------------------------------------------
-- Section 9 - TRANSACTION ISOLATION LEVELS: SERIALIZABLE
-- ----------------------------------------------------------------------------------------------------

-- Note: Transaction Isolation Level can only be set before transaction starts, not during.

-- Serialable: Prevents other transactions from updating data this transaction has acquired lock on
-- Highest Isolation Level
-- Effects: -
-- Solves: (1) Dirty Reads (Uncommitted Changes) (2) Non Repeatable Reads (3) Phantom Reads

-- Phantom Reads: One transaction works on a set of data, that transaction keeps seeing exactly same data
-- during its execution, however other transactions are allowed to change them (insert/delete/update). 
-- Serializable prevents this.

-- Note: If a transaction on Isolation Level: REPEATABLE READ makes change on some data (for example delete)
-- then another transaction on Isolation Level: Serializable reads these data and then the previous transaction
-- commits the change, the latest transaction still sees inconsistent data.

-- Session A.1: Start
-- go to Session B.1
-- Session A.1: End

-- Session A.2: Start
start transaction;
select * from book where release_year > 1980 and release_year < 1990; -- works
update book set release_year = 18 where release_year = 1980; -- fails because table is locked
delete from book where release_year = 1980; -- fails because table is locked
insert into book (title, release_year, book_language) values ('New SQL Book', 2004, 'English'); -- fails again
-- below works because only table book was used and thus locked by the other transaction
select * from author where first_name in ('Virginia', 'John');
insert into author (first_name, last_name, birthday) values ('John', 'Wick', '1891-04-14');
update author set birthday = '1883-01-25' where first_name = 'Virginia' and last_name = 'Wolf';
update author set birthday = '1882-01-25' where first_name = 'Virginia' and last_name = 'Wolf';
delete from author where first_name in ('Virginia', 'John');
commit;
-- go to B.2
-- Session A.2: End

-- Copy the content of Session B in another session
-- Session B: Start

-- Session B.1: Start
set transaction isolation level serializable; -- set transaction isolation level to serializable
start transaction;
select * from book where release_year > 1980 and release_year < 1990; -- works
-- go to section A.2
-- Session B.1: End

-- Session B.2: Start
commit;
-- go again to A.2, now they will work again
-- Session B.2: End

-- Session B: End

-- Note: The precise way of locking varies based on DBMS and its configuration.

-- ----------------------------------------------------------------------------------------------------
-- Section 10 - TRANSACTION MANAGEMENT
-- ----------------------------------------------------------------------------------------------------

-- View transactions
-- MySQL Syntax:
select	*
from	performance_schema.events_transactions_current
where	state not in ('COMMITTED', 'ROLLED BACK');





