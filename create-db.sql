reate user ew;
alter user ew superuser;
create user informa with password 'password';
alter user informa superuser; 
drop database informa;
create database informa;
grant all privileges on database informa to informa;
grant all privileges on database informa to ew;
