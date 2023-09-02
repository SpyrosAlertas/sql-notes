
-- DCL Commands In Depth (Data Control Language)

-- ----------------------------------------------------------------------------------------------------
-- Section 1 - User Management (Create/View/Rename/Delete)
-- ----------------------------------------------------------------------------------------------------

-- Create new user
-- Syntax: create user '<username>'@'<hostname>' identified by '<password>';
-- Example:
create user 'testuser'@'localhost' identified by 'testpass';
-- Note: By default new users have no privileges. They have to be granted their privileges seperately.

-- View current users
-- MySQL Syntax:
select * from mysql.user;

-- Rename user
-- Syntax: rename user '<oldusername>'@'<hostname>' to '<newusername>'@'<hostname>';
-- Example:
rename user 'testuser'@'localhost' to 'realuser'@'localhost';

-- Delete user
-- Syntax: drop user '<username>'@'<hostname>';
-- Example:
drop user 'realuser'@'localhost';

-- ----------------------------------------------------------------------------------------------------
-- Section 2 - User Management (Grant/Revoke Privileges)
-- ----------------------------------------------------------------------------------------------------

-- View admin level privileges of users (like create/drop databases, users etc)
-- NySQL Syntax:
select * from mysql.user;

-- Create testuser to experiment with
create user 'testuser'@'localhost' identified by 'testpass';
-- create testdb to expirement with
create database testdb;

-- See user privileges on databasese and tables
-- Syntax: show grants for '<username>'@'<hostname>';
-- Example:
show grants for 'admin'@'%';
show grants for 'testuser'@'localhost';

-- View list of all available privileges
show privileges;

-- Alter user privileges
-- Give all permissions for specific database
-- Syntax: grant all privileges on <db_name>.* TO '<username>'@'<hostname>';
-- Example
grant all privileges on testdb.* TO 'testuser'@'localhost';
-- * can be replaced with table name, in that case privileges will be granted on table level and not on db

-- Remove all permissions for specific database
-- Syntax: revoke all privileges on <db_name>.* from '<username>'@'<hostname>';
-- Example:
revoke all privileges on testdb.* from 'testuser'@'localhost';

-- Give specific permission(s) only 
-- Syntax: grant <privilegeA>, <privilegeB>, <....> on <db_name>.* to '<username>'@'<hostname>';
-- Example - Give only insert, select permissions on all tables for DB:
grant insert, select on testdb.* to 'testuser'@'localhost';

-- Remove specific permission(s) only
-- Syntax: revoke <privilegeA>, <privilegeB>, <....> on <db_name>.* from '<username>'@'<hostname>';
-- Example - Revoke only INSERT permission from user:
revoke insert on testdb.* from 'testuser'@'localhost';

-- Flush privileges is required to make the changes effective, only when we
-- directly modify the privileges in the grant tables using insert, update, delete.
-- Syntax:
flush privileges;

-- Note: Privilege changes may not be reflected on existing DB sessions.

-- ----------------------------------------------------------------------------------------------------
-- Section 3 - Role Management (Create/View/Rename/Use/Delete)
-- ----------------------------------------------------------------------------------------------------

-- Create new role
-- Syntax: create role <rolename>;
-- Example:
create role 'testrole';

-- View existing roles in DB
-- MySQL Syntax:
select * from mysql.user where authentication_string = ''; -- only roles should have empty authentication string

-- Rename Role:
-- Syntax: rename user <oldrolename> to <newrolename>;
-- Example:
rename user 'testrole' to 'mytestrole';

-- Add privileges to role
-- Syntax: grant all privileges on <db_name>.* to 'role';
-- Example:
grant all privileges on testdb.* to 'mytestrole';

-- Remove privileges from role
-- Syntax: revoke all privileges on <db_name>.* from 'role';
-- Example:
revoke all privileges on testdb.* from 'mytestrole';

show grants for 'mytestrole';

-- Add role to user
-- Syntax: grant <role> to '<user>'@'<host>';
-- Example:
grant 'mytestrole' to 'testuser'@'localhost';

-- Remove role from user
-- Syntax: revoke <role> from '<user>'@'<host>';
-- Example:
revoke 'mytestrole' from 'testuser'@'localhost';

show grants for 'testuser'@'localhost';

-- Set default role for user
-- Syntax: set default role '<role>' to '<user>'@'<host>';
-- Example:
set default role 'mytestrole' to 'testuser'@'localhost';

-- Remove default role from user
-- Syntax: set default role none to '<user>'@'<host>';
-- Example:
set default role none to 'testuser'@'localhost';

-- View current users role
-- Syntax:
select current_role();

-- Delete role
-- Syntax: drop role <rolename>;
-- Example:
drop role 'mytestrole';

drop user 'testuser'@'localhost';
drop database testdb;

-- ----------------------------------------------------------------------------------------------------
-- Section 4 - Practice Role and User Management
-- ----------------------------------------------------------------------------------------------------

select * from mysql.user;

create user 'bookso'@'localhost' identified by 'bookso';
show grants for 'bookso'@'localhost';

-- Open another session (let's name it session B) as bookso user now and run
show databases; -- database booksdb won't be visible

grant all privileges on booksdb.* to 'bookso'@'localhost';

-- On Session B as bookso user run again
show databases; -- database booksdb will be visible and with grant all we are able to do any operation on the db

revoke all privileges on booksdb.* from 'bookso'@'localhost';

create role 'books_read_role';
create role 'books_insert_role';
create role 'books_delete_role';

select * from mysql.user where authentication_string = '';

show grants for 'books_read_role';
grant select on booksdb.* to 'books_read_role';

show grants for 'books_insert_role';
grant insert on booksdb.* to 'books_insert_role';

show grants for 'books_delete_role';
grant delete on booksdb.* to 'books_delete_role';

grant 'books_read_role' to 'bookso'@'localhost';
grant 'books_insert_role' to 'bookso'@'localhost';
grant 'books_delete_role' to 'bookso'@'localhost';
show grants for 'bookso'@'localhost';

-- Note: By default roles are not active on users, this means users won't have these privileges
-- even if they are granted these privileges.

-- Open a new session as a bookso user and run below commands
show databases; -- booksdb database won't be visible
-- Solution 1 (Per Session Only):
select current_role(); -- will be none
set role 'books_read_role'; -- after this command above command will show new role
-- You can also asign a list of roles:
set role 'books_read_role', 'books_insert_role';

-- This way the user has the privileges of the set roles only.
-- With set role, each time you open a new session you will have to set again each role.

-- Solution 2 (Permanent):
set default role 'books_insert_role', 'books_read_role', 'books_delete_role' to 'bookso'@'localhost';

-- Now open a new session as bookso and run below command, all above roles will be listed
select current_role(); -- will show all 3 above roles

-- Note: If you set the role for the user of current user the part to 'user'@'host' is optional
-- but if you set it for another user it's mandatory

-- Note: Such changes won't be reflected to existing sessions, only on new ones (set default role)

-- Clean up
drop role 'books_insert_role', 'books_read_role', 'books_delete_role';
grant all privileges on booksdb.* to 'bookso'@'localhost';
