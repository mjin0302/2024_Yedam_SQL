-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- 2. 사원번호를 입력받아 부서이름, job_id, 급여, 연간 총수입을 출력하는 PL/SQL Block를 작성하세요
--    급여나 커미션이 Null일 경우더라도 값이 출력되도록 하세요.
DECLARE
   v_dame   departments.department_name%TYPE;
   v_job    employees.job_id%TYPE;
   v_sal    employees.salary%TYPE;
   v_year   NUMBER;
BEGIN
   SELECT department_name,
          job_id,
          salary,
         (NVL(salary, 0)+(NVL(salary, 0) * NVL(commission_pct,0))) * 12 as year
   INTO   v_dame, v_job, v_sal, v_year
   FROM   employees e JOIN departments d
                      ON   e.department_id = d.department_id
   WHERE  employee_id = &사원번호;
   DBMS_OUTPUT.PUT('부서이름 : ' || v_dame);
   DBMS_OUTPUT.PUT(', job_id : ' || v_job);
   DBMS_OUTPUT.PUT(', 급여 : ' || v_sal);
   DBMS_OUTPUT.PUT_LINE(', 연간 총수입 : ' || v_year);
END;
/

-- 3. 사원번호를 입력받아 Employees 테이블을 참조해서 사원의 입사년도가 2015년 이후(2015년 제외)에 입사면 'New employee', 아니면 'Career employee'이라고 출력하시오
DECLARE
  v_hdate employees.hire_date%TYPE;
  v_msg VARCHAR(200);
BEGIN
  SELECT hire_date
  INTO   v_hdate
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  IF TO_CHAR(v_hdate, 'yyyy') > '2015' THEN
    v_msg := 'New employee';
  ELSE
    v_msg := 'Career employee';
  END IF;
  
  DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

-- 4. 구구단 1단 ~ 9단을 출력하는 PL/SQL 블록을 작성하시오(홀수단만 출력하세요)
BEGIN
   FOR dan IN 1 .. 9 LOOP -- 단 반복   
         FOR num IN 1 .. 9 LOOP -- 곱하는 수 반복
            CONTINUE WHEN MOD(num, 2) = 0;  
            DBMS_OUTPUT.PUT(num || ' * ' || dan ||' = ' || (dan * num) || '   ');
            
         END LOOP;
         DBMS_OUTPUT.PUT_LINE('');
   END LOOP;
END;
/

-- 5. 부서번호를 입력하면 해당 부서에 근무하는 모든 사원의 사번, 이름, 급여를 출력하는 PL/SQL블록을 작성하세요. 단, CURSOR사용
DECLARE
   CURSOR emp_in_dept_cursor IS
      SELECT employee_id ename, 
             last_name hdate,
             salary sal
      FROM   employees 
      WHERE  department_id = &부서번호;
BEGIN
   FOR emp_dept_rec IN emp_in_dept_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(emp_dept_rec.ename ||  ', ' ||  emp_dept_rec.hdate ||  ', ' || emp_dept_rec.sal);
   END LOOP;
END;
/

-- 6. 직원들의 사번, 급여 증가치(비율)만 입력하면 Employees 테이블에 쉽게 사원의 급여를 갱신할 수 있도록 procedure를 작성하세요.
--    만약 입력한 사원이 없는 경우에는 'No search employee!'라는 메세지를 출력하세요. 단, Exception절 사용
DROP PROCEDURE emp_update; 
CREATE PROCEDURE emp_update
   (p_eid IN employees.employee_id%TYPE,
    p_raise IN employees.salary%TYPE )
IS
   e_no_emp EXCEPTION;
BEGIN
   UPDATE employees
   SET    salary = salary + (salary * (p_raise / 100))
   WHERE  employee_id = p_eid;
   
   IF SQL%ROWCOUNT = 0 THEN
      RAISE e_no_emp;
   END IF;
EXCEPTION
   WHEN e_no_emp THEN
      DBMS_OUTPUT.PUT_LINE('No search employee!!');
END;
/
SELECT SUBSTR('0211023234567', 7, 1)
FROM dual;

-- 7. 주민등록번호(0211023234567)를 입력받으면 만 나이와 성별을 모두 출력하는 프로그램을 하나만 작성하세요.
DROP PROCEDURE get_jumin;
CREATE PROCEDURE get_jumin
   (ju_min IN VARCHAR2)
IS
   v_format VARCHAR2(100);
   v_age VARCHAR2(30);
   v_gender VARCHAR2(10);
BEGIN
   v_format := SUBSTR(ju_min, 1, 6);
   v_age := TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), TO_DATE(v_format,'YYMMDD')) / 12);
   IF SUBSTR(ju_min, 7, 1) = '1' THEN
      v_gender := '남';
   ELSIF SUBSTR(ju_min, 7, 1) = '3' THEN
      v_gender := '남';
   ELSE 
      v_gender := '여';
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('만나이 : ' || v_age);
   DBMS_OUTPUT.PUT_LINE('성별 : ' || v_gender);
END;
/
EXECUTE get_jumin('0211023234567');

-- 8. 사원번호를 입력받으면 해당 사원의 근무한 기간의 근무년수만 출력하는 Function을 작성하세요.
--    단, 근무한 기간이 근무년수와 근무개월 수로 구성되는 경우 근무개월수는 제외한다. 예를 들어, 5년 10개월일 경우 5년만 표기한다.
DROP FUNCTION get_year;
CREATE FUNCTION get_year
   (p_eid employees.employee_id%TYPE)
RETURN VARCHAR2
IS
    v_year VARCHAR2(100);
BEGIN
    SELECT ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)/12) || '년' as 근무년수
    INTO   v_year
    FROM   employees
    WHERE  employee_id = p_eid;

    RETURN v_year;
END;
/
SELECT get_year(200)
FROM   dual;

-- 9. 부서이름을 입력하면 부서의 책임자(Manager) 이름을 출력하는 Function을 작성하세요. 단, 서브쿼리를 이용
DROP FUNCTION get_mgr_name;
CREATE FUNCTION get_mgr_name
   (p_dept_name departments.department_name%TYPE) -- 사원번호
RETURN VARCHAR2
IS
    v_ename employees.last_name%TYPE;
BEGIN
   SELECT last_name
   INTO   v_ename
   FROM   employees
   WHERE  employee_id = (SELECT manager_id FROM departments WHERE UPPER(department_name) = UPPER(p_dept_name));

   RETURN v_ename;
END;
/
SELECT get_mgr_name('it')
FROM dual;

-- 10. HR사용자에게 존재하는 PROCEDURE, FUNCTION, PACKAGE, PACKAGE BODY의 이름과 소스코드를 한꺼번에 확인하는 SQL구문을 작성하세요
SELECT name, text
FROM   user_source
WHERE  type IN ('PROCEDURE', 'FUNCTION', 'PACKAGE', 'PACKAGE BODY');

-- 11. 다음과 같은 모양을 출력하는 PL/SQL블록을 작성하세요.
/*
--------* 8, 1
-------** 7, 2
------*** 6, 4
----***** 4, 3
-----**** 5, 5
---****** 3, 6
--******* 2, 7
-******** 1, 8
*/
DECLARE
   v_star VARCHAR2(100);
BEGIN
   FOR idx IN 1 .. 8 LOOP
      v_star := LPAD('*', idx, '*');
      v_star := LPAD(v_star, 9, '-');
      DBMS_OUTPUT.PUT_LINE(v_star);
   END LOOP;
END;
/
