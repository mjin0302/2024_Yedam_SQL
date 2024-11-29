SET SERVEROUTPUT ON;

BEGIN
  DBMS_OUTPUT.PUT_LINE('Hello, PL/SQL!!');
END;
/
-- 초기화되지 않은값은 null값이 들어감
DECLARE
  --선언부 : 변수 등 선언
  v_str VARCHAR2(100);  -- 기본
  v_num CONSTANT NUMBER(2,0) := 10; -- 상수
  v_count NUMBER(2,0) NOT NULL DEFAULT 5; -- NOT NULL 조건의 변수
  v_sum NUMBER(3,0) := v_num + v_count;   -- 표현식(계산식)을 기반으로 초기화
BEGIN
  -- 실행부 :  셀제 프로세스 수행
  DBMS_OUTPUT.PUT_LINE('v_str : ' || v_str); 
  DBMS_OUTPUT.PUT_LINE('v_num : ' || v_num);
  v_num := 100;
  DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
  DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
END;
/

-- %TYPE 속성
DECLARE
  v_eid employees.employee_id%TYPE; -- employee_id%TYPE employee_id의 데이터 타입을 참조하겠다~~ 
  v_ename employees.last_name%TYPE;
  v_new v_ename%TYPE;
BEGIN
  SELECT employee_id, last_name
  INTO   v_eid, v_ename
  FROM   employees
  WHERE  employee_id = 100;
  
  v_new := v_eid || ' ' || v_ename;
  DBMS_OUTPUT.PUT_LINE(v_new);
END;
/

-- PL/SQL에서 단독 사용가능한 SQL함수 => 단일행 함수들(DECODE, 그룹함수 제외)
DECLARE
  v_date DATE;
BEGIN
  v_date := sysdate + 7;
  DBMS_OUTPUT.PUT_LINE(v_date);
END;
/

-- PL/SQL의 SELECT문
-- 1) INTO절 : 조회한 컬럼의 값을 담는 변수 선언 => 반드시 데이터는 하나의 행만 반환
DECLARE
  v_name employees.last_name%TYPE;
BEGIN
  SELECT last_name
  -- INTO   v_name
  FROM   employees
  WHERE  employee_id = 100;
  
  DBMS_OUTPUT.put_LINE(v_name);
END;
/

-- 2) 결과 값은 무조건 하나의 행
DECLARE
  v_name employees.last_name%TYPE;
BEGIN
  SELECT last_name
  INTO   v_name
  FROM   employees
  WHERE  department_id = &department_id;
  -- 부서번호 0  : NO DATA FOUND
  -- 부서번호 50 : ORA-01422: exact fetch returns more than requested number of rows
  -- 부서번호 10 : Whalen
  DBMS_OUTPUT.put_LINE(v_name);
END;
/

-- 3) SELECT절의 컬럼 갯수 = INTO절의 변수 갯수
DECLARE
  v_eid employees.employee_id%TYPE;
  v_ename employees.last_name%TYPE;
BEGIN
  SELECT employee_id
         last_name
  INTO   v_eid,
         v_ename
  -- SELECT > INTO : not enough values
  -- SELECT < INTO : too many values
  FROM   employees
  WHERE  employee_id = 100;
  DBMS_OUTPUT.put_LINE(v_eid);
  DBMS_OUTPUT.put_LINE(v_ename);
END;
/

-- PL/SQL 안에서 DML
DECLARE
  v_deptno departments.department_id%TYPE;
  v_comm employees.commission_pct%TYPE := .1;
BEGIN
  SELECT department_id
  INTO   v_deptno
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  INSERT INTO employees (employee_id,
                         last_name,
                         email,
                         hire_date,
                         job_id,
                         department_id)
  VALUES                (1000,
                         'Hong',
                         'hkd@google.com',
                         sysdate,
                         'IT_PROG',
                         v_deptno);
  UPDATE employees
  SET    salary = (NVL(salary, 0) + 10000) * v_comm
  WHERE  employee_id = 1000;
  
  COMMIT; -- 블록 =/= 트랜잭션, 반드시 필요하다면 명시적으로 COMMIT/ROLLBACK 작성
END;
/

ROLLBACK;

SELECT * 
FROM   employees
WHERE  employee_id IN (200, 1000);

BEGIN
  DELETE FROM employees
  WHERE  employee_id = 1000;
END;
/

