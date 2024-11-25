-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- IF 문제
/*
3.
사원번호를 입력(치환변수사용&)할 경우 -> where
입사일이 2025년 이후(2025년 포함)이면 'New employee' 출력 -> if
      2025년 이전이면 'Career employee' 출력 --> else
단, DBMS_OUTPUT.PUT_LINE ~ 은 한번만 사용
*/
DECLARE
  v_hire_date employees.hire_date%TYPE;
  v_msg VARCHAR(200);
BEGIN
  SELECT hire_date
  INTO   v_hire_date
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  -- IF TO_DATE(v_hire_date, 'yyyy-MM-dd') >= TO_DATE('2020-01-01', 'yyyy-MM-dd') THEN
  IF TO_CHAR(v_hire_date, 'yyyy') >= '2020' THEN
    v_msg := 'New employee';
  ELSE
    v_msg := 'Career employee';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/
SELECT hire_date, employee_id
FROM   employees
WHERE  TO_CHAR(hire_date, 'yyyy') >= '2020';

/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

사원번호를 입력(치환변수사용&)할 경우
사원들 중 2025년 이후(2025년 포함)에 입사한 사원의 사원번호, 
사원이름, 입사일을 test01 테이블에 입력하고, 2025년 이전에 
입사한 사원의 사원번호,사원이름,입사일을 test02 테이블에 입력하시오.
*/
-- 변수 => 사원번호, 사원이름, 입사일
-- 2025이후 -> test01, 2025 이전 -> test02
DECLARE
  v_eid employees.employee_id%TYPE;
  v_name employees.last_name%TYPE;
  v_hdate employees.hire_date%TYPE;
BEGIN
  SELECT employee_id, last_name, hire_date
  INTO   v_eid, v_name, v_hdate
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  IF TO_CHAR(v_hdate, 'yyyy') >= '2020' THEN
     INSERT INTO test01 (empid, ename, hiredate)
     VALUES (v_eid, v_name, TO_DATE(v_hdate));
  ELSE
    INSERT INTO test02 (empid, ename, hiredate)
    VALUES (v_eid, v_name, TO_DATE(v_hdate));
  END IF;
END;
/
select * from test02;
/*
5.
급여가  5000이하이면 20% 인상된 급여
급여가 10000이하이면 15% 인상된 급여
급여가 15000이하이면 10% 인상된 급여
급여가 15001이상이면 급여 인상없음

사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 PL/SQL 블록을 생성하시오.
*/
-- 1) if ~ elsif else
-- 2) 변수 -> 사원이름, 급여, 인상된 급여
-- 5000 < salary 
DECLARE
  v_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
  v_new_sal v_salary%TYPE;
  v_raise NUMBER(5, 2);
BEGIN
  SELECT last_name, salary
  INTO   v_name, v_salary
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  IF    v_salary <= 5000 THEN 
--        v_highsalary := v_salary * 1.20;
        v_raise := 20;
  ELSIF v_salary <= 10000 THEN
--        v_highsalary := v_salary * 1.15;
        v_raise := 15;
  ELSIF v_salary <= 15000 THEN
--        v_highsalary := v_salary * 1.10;
        v_raise := 10;
  ELSE
        v_raise := 0;
  END IF;
  v_new_sal := v_salary + v_salary * (v_raise/100);
  DBMS_OUTPUT.PUT_LINE(v_name || ',' || v_salary || ',' || v_new_sal);
END;
/
-- ========================================================================================================================
-- LOOP 문제
/*
6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    
*/
DECLARE
  star CHAR(1) := '*';
  result VARCHAR(10) := '';
  v_count NUMBER(10, 0) := 0;
BEGIN
  LOOP
    result := CONCAT(result, star);
    v_count := v_count + 1;
    EXIT WHEN v_count > 5;
    DBMS_OUTPUT.PUT_LINE(result);
  END LOOP;
END;
/
DECLARE
  star VARCHAR2(10) := '';
BEGIN
  LOOP
    star := star || '*';
    DBMS_OUTPUT.PUT_LINE(star);
    
    EXIT WHEN LENGTH(star) >= 5;
    
  END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
  v_dan CONSTANT NUMBER(10, 0) := &단; -- 몇 단
  v_num NUMBER(10, 0) := 0; -- 곱하는 수 : 정수1 ~ 9
BEGIN
  LOOP
    v_num := v_num + 1;
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num ||' = ' || v_dan * v_num);
    EXIT WHEN v_num > 10;
    
  END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
-- 1) 2 ~ 9 단, 단이 증가해야 함 => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1 ~ 9까지 정해진 값을 사용 => 두번째 LOOP문
DECLARE
  v_dan NUMBER(10, 0) := 1;
  v_num NUMBER(5, 0) := 2;
BEGIN
  LOOP
    v_dan := v_dan + 1;
    v_num := 1;
      LOOP
        v_num := v_num + 1;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num ||' = ' || (v_dan * v_num));
        EXIT WHEN v_num >= 10;
      END LOOP;
      
    EXIT WHEN v_dan >= 10;
  END LOOP;
END;
/
-- ========================================================================================================================
-- WHILE LOOP 문제
/*
6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****     
*****    
*/
DECLARE
  star VARCHAR2(10) := ''; 
  v_count NUMBER(2, 0) := 1;
BEGIN
  WHILE v_count <= 5 LOOP
    star := star || '*';
    DBMS_OUTPUT.PUT_LINE(star);
    v_count := v_count + 1;
  END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력하면 
해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
  v_dan CONSTANT NUMBER(10, 0) := &단; -- 몇 단
  v_num NUMBER(10, 0) := 0; -- 곱하는 수 : 정수1 ~ 9
BEGIN
  WHILE v_num < 10 LOOP
    v_num := v_num + 1;
    DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num ||' = ' || v_dan * v_num);
  END LOOP;
END;
/

/*
8. 구구단 2~9단까지 출력되도록 하시오.
*/
-- 1) 2 ~ 9 단, 단이 증가해야 함 => 첫번째 LOOP문
-- 2) 해당 단의 곱하는 수가 1 ~ 9까지 정해진 값을 사용 => 두번째 LOOP문
DECLARE
  v_dan NUMBER(10, 0) := 1; -- 
  v_num NUMBER(5, 0) := 2;
BEGIN
   WHILE v_dan < 10 LOOP   -- 단을 반복
      v_dan := v_dan + 1;
      v_num := 1;
         WHILE v_num < 10 LOOP   -- 곱하는 수를 반복
            v_num := v_num + 1;
            DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || v_num ||' = ' || (v_dan * v_num));
         END LOOP;
      v_num := 1;
   END LOOP;
END;
/

-- ========================================================================================================================
-- FOR LOOP 문제
/*
6. 다음과 같이 출력되도록 하시오.
*         
**        
***       
****      
*****     
*/
DECLARE
  star VARCHAR2(10) := ''; 
  v_count NUMBER(2, 0) := 1;
BEGIN
   FOR idx IN 1 .. 5 LOOP
      star := star || '*';
      DBMS_OUTPUT.PUT_LINE(star);
      v_count := v_count + 1;
  END LOOP;
END;
/

/*
6. 다음과 같이 출력되도록 하시오.
*         : 1줄, * 1개 출력
**        : 2줄, * 2개 출력
***       : 3줄, * 3개 출력
****      : 4줄, * 4개 출력
*****     : 5줄, * 5개 출력
*/
BEGIN
   FOR idx IN 1 .. 5 LOOP
      FOR jdx IN 1 .. idx LOOP
         DBMS_OUTPUT.PUT('*');
      END LOOP;
      DBMS_OUTPUT.PUT_LINE('');
  END LOOP;
END;
/

/*
7. 치환변수(&)를 사용하면 숫자를 입력받아 해당 구구단이 출력되도록 하시오.
예) 2 입력시 아래와 같이 출력
2 * 1 = 2
2 * 2 = 4
...
*/
DECLARE
  v_dan CONSTANT NUMBER(10, 0) := &단; -- 몇 단
  v_num NUMBER(10, 0) := 0; -- 곱하는 수 : 정수1 ~ 9
BEGIN
   FOR num IN 1 .. 9 LOOP
      DBMS_OUTPUT.PUT_LINE(v_dan || ' * ' || num ||' = ' || v_dan * num);
  END LOOP;
END;
/

-- 8. 구구단 2~9단까지 출력되도록 하시오.
-- 8-1) 2 ~ 9 단, 단이 증가해야 함 => 첫번째 LOOP문
-- 8-2) 해당 단의 곱하는 수가 1 ~ 9까지 정해진 값을 사용 => 두번째 LOOP문
BEGIN
   FOR dan IN 2 .. 9 LOOP -- 단 반복   
         FOR num IN 1 .. 9 LOOP -- 곱하는 수 반복
            DBMS_OUTPUT.PUT_LINE(dan || ' * ' || num ||' = ' || (dan * num));
         END LOOP;
   END LOOP;
END;
/
