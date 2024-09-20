DELETE departments
WHERE  department_id = 60;

-- 제약조건 확인
desc employees;

CREATE TABLE emp_test (
  empid     NUMBER(5),
  empname   VARCHAR2(10) NOT NULL,
  duty      VARCHAR2(9),
  sal       NUMBER(7,2),
  bonus     NUMBER(7,2),
  mgr       NUMBER(5),
  hire_date DATE,
  deptid    NUMBER(2)
 );
 
DESC emp_test;

INSERT INTO emp_test (empid, empname)
VALUES  (111, 'KMJ');

INSERT INTO emp_test (empid, empname)
VALUES  (333, NULL);

CREATE TABLE AAA (
  aa  NUMBER(3),
  bb  NUMBER(3),
  UNIQUE(aa, bb));

INSERT INTO aaa
VALUES (1, 1);

INSERT INTO aaa
VALUES (1, 2);

INSERT INTO aaa
VALUES (1, NULL);

INSERT INTO aaa
VALUES (1, NULL);

INSERT INTO aaa
VALUES (NULL, NULL);

INSERT INTO aaa
VALUES (NULL, NULL);

CREATE TABLE dept_test (
  deptid    NUMBER(2) PRIMARY KEY,
  dname     VARCHAR2(14) UNIQUE,
  loc       VARCHAR2(13)
);

INSERT INTO dept_test (deptid, dname)
VALUES      (1, '옹심');

INSERT INTO dept_test (deptid, dname)
VALUES      (NULL, '옹심2');

-- unique제약조건 때문에 오류 뜸
INSERT INTO dept_test (deptid, dname)
VALUES      (2, '옹심');

-- 기본키 값이 중복임
INSERT INTO dept_test (deptid, dname)
VALUES      (1, NULL);

SELECT * FROM dept_test;

DROP TABLE empl;
CREATE TABLE empl (
  empid   NUMBER(2),
  deptid  NUMBER(2) REFERENCES dept_test(deptid) ON DELETE SET NULL -- dept_test테이블의 deptid를 참조
 );

INSERT INTO empl 
VALUES      (11, 1);
INSERT INTO empl 
VALUES      (22, NULL);
INSERT INTO empl 
VALUES      (33, 3);

DELETE dept_test
WHERE  deptid = 1;

SELECT *
FROM empl;
SELECT * FROM emp_test;

ALTER TABLE emp_test
ADD   PRIMARY KEY(empid);

-- 참조키를 지정할 때는 참조하는 키와 데이터 타입이 똑같아야함
ALTER TABLE emp_test
ADD   FOREIGN KEY(mgr) REFERENCES emp_test(empname);

DELETE emp_test
WHERE  empid = 222;

-- 이미 테이블에 NULL값이 들어가 있으면 NOT NULL로 못바꿈
ALTER TABLE emp_test
MODIFY (duty NOT NULL);

-- 해당 테이블의 제약조건 확인
SELECT * 
FROM   user_constraints
WHERE  table_name = 'EMP_TEST';

-- 뷰를 통해 제약조건의 이름 및 연관된 열 확인
SELECT constraint_name, 
       column_name
FROM   user_cons_columns;

-- 제약조건 삭제할 때 사용함
ALTER TABLE dept_test
DROP  PRIMARY KEY CASCADE;

SELECT * FROM emp_test;

SELECT * FROM dept_test;
DESC dept_test;