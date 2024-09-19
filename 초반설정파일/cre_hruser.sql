create user hr identified by hr
default tablespace users
temporary tablespace temp;
grant connect, resource to hr;
