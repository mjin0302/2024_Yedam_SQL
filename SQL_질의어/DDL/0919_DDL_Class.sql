SELECT table_name
FROM   user_tables;

-- object_type이 뭐가 있는지 보여줌
SELECT DISTINCT object_type
FROM   user_objects;

-- 사용자가 소유한 테이블, 뷰, 동의어 및 시퀀스 확인
SELECT * 
FROM   user_catalog;

CREATE TABLE sample
            (sam1  NUMBER(4),
             sam2  VARCHAR2(10),
             sam3  VARCHAR2(20));

-- hire_dates테이블 구조 조회
DESCRIBE hire_dates;

CREATE TABLE hire_dates
            (id        NUMBER(8),
             hire_date DATE       DEFAULT SYSDATE);
             
-- 데이터 삽입 
INSERT INTO hire_dates (id,
                        hire_date)
VAlUES     (45, NULL);

INSERT INTO hire_dates (id)
VAlUES     (35);

select * from hire_dates;

CREATE TABLE dept (deptno NUMBER(2),
                   dname  VARCHAR2(14),
                   loc    VARCHAR2(13),
                   create_date DATE DEFAULT SYSDATE);
                   
DESCRIBE dept;

SELECT table_name 
FROM   user_tables;

CREATE TABLE dept80
  AS
    SELECT employee_id,
           last_name,
           salary * 12 AS ANNSAL,
           hire_date
    FROM   employees
    WHERE  department_id = 80;
    
SELECT * FROM dept82;

select * from employees where department_id = 80;

-- 별칭을 create문에 미리 지정해놓는 방법
CREATE TABLE dept82 (empno, 
                     name, 
                     sal, 
                     cdate)
  AS
    SELECT employee_id,
           last_name,
           salary * 12,
           hire_date
    FROM   employees
    WHERE  department_id = 80;

-- 테이블 구조만 복사하는 편법(WHERE  department_id = 0; 조건절에 없는 데이터 조건을 줘서 테이블 구조만 복사하는 방법)
CREATE TABLE dept82 (empno, 
                     name, 
                     sal, 
                     cdate)
  AS
    SELECT employee_id,
           last_name,
           salary * 12,
           hire_date
    FROM   employees
    WHERE  department_id = 0;

DESCRIBE dept80;

-- job_id 컬럼 추가
ALTER TABLE dept80
ADD         (job_id VARCHAR2 (9));

-- last_name 컬럼 수정
ALTER TABLE dept80
MODIFY     (last_name VARCHAR2(30));

-- sal컬럼 default 값 수정
ALTER TABLE dept80
MODIFY (sal NUMBER(5) DEFAULT 9999);

ALTER TABLE dept80
DROP(sal);

-- last_name컬럼을 UNUSED시킴(숨김상태이지만 다시 보이게 하는건 불가능)
ALTER TABLE  dept80
SET   UNUSED (last_name);


ALTER TABLE dept80
DROP  UNUSED COLUMNS;

-- 테이블 삭제(휴지통으로 들어감 : 이 휴지통은 oracle에만 존재함
DROP TABLE dept80;

-- 윈도우로 따지면 shift+del이랑 똑같음(휴지통을 거치지않고 바로 삭제)
DROP TABLE dept81 PURGE;

-- 삭제한 테이블 조회 (즉, 휴지통 보는거랑 비슷함)
SELECT object_name, original_name, type
FROM user_recyclebin;

-- 다시 복구하는 방법
FLASHBACK TABLE dept80 TO BEFORE DROP;

PURGE RECYCLEBIN;

SELECT USER_TAB_COMMENTS
FROM employees;

-- 테이블 이름 변경
RENAME sample TO sam;

select * from sam;