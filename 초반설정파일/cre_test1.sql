CREATE TABLE test1(
pk NUMBER PRIMARY KEY,
fk NUMBER,
col1 NUMBER,
col2 NUMBER,
CONSTRAINT fk_constraint FOREIGN KEY (fk) REFERENCES test1,
CONSTRAINT ck1 CHECK (pk > 0 and col1 > 0),
CONSTRAINT ck2 CHECK (col2 > 0))
/
desc test1
select table_name, constraint_name, constraint_type, status
from user_constraints
where table_name = 'TEST1'
/
