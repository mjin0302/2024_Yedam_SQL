/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
*/
select * from test01;
select * from test02;
DECLARE
   CURSOR emp_cursor IS
      SELECT employee_id, last_name, hire_date
      FROM   employees;
   
   v_ememp_recode_type
   v_eid  employees.employee_id%TYPE;
   v_name employees.last_name%TYPE;
   v_date  employees.hire_date%TYPE;
   
BEGIN
   OPEN emp_cursor;
   
    LOOP
      -- 3. 데이터 인출
      FETCH emp_cursor INTO v_eid, v_name, v_date;
         
      EXIT WHEN emp_cursor%NOTFOUND;
       
       -- 커서에서 반환되는 데이터가 있는 경우
      IF TO_CHAR(v_date, 'yyyy') <= '2020' THEN
          INSERT INTO test02 (empid, ename, hiredate)
          VALUES      (v_eid, v_name, v_date);
      ELSE
         INSERT INTO test01 (empid, ename, hiredate)
         VALUES      (v_eid, v_name, v_date);
      END IF;
    END LOOP ;
END;
/

-- 2안 레코드 사용
DECLARE
    CURSOR emp_cursor IS
        select employee_id, last_name, hire_date
        from employees;
    TYPE emp_record_type IS RECORD
        (eid employees.employee_id%TYPE,
         ename employees.last_name%TYPE,
         hdate employees.hire_date%TYPE);
    v_emp_info emp_record_type;
BEGIN
    OPEN emp_cursor;
    LOOP
        FETCH emp_cursor INTO v_emp_info;
        EXIT WHEN emp_cursor%NOTFOUND;
        IF v_emp_info.hdate <= TO_DATE('2015-12-31', 'YYYY-MM-DD') THEN
            INSERT INTO test01 (empid, ename, hiredate)
                VALUES (v_emp_info.eid, v_emp_info.ename, v_emp_info.hdate);
        ELSE
            --레코드 째로 삽입할땐 컬럼을 명시하면 안됨!!!
            -- 행단위로 움직이는건 가능하다!!!!
            INSERT INTO test02
            VALUES      v_emp_info;
        END IF;
    END LOOP;
    CLOSE emp_cursor;
END;
/

-- 2. 부서번호를 입력할 경우(&치환변수 사용) 해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
-- SUPQUERY 이용
DECLARE
   CURSOR emp_of_dept_cursor IS
      SELECT last_name, 
             hire_date,
             (SELECT department_name FROM departments d WHERE e.department_id = d.department_id) as department_name
      FROM   employees e
      WHERE  e.department_id = &사원번호; 
   
   v_name      employees.last_name%TYPE;
   v_hdate      employees.hire_date%TYPE;
   v_dept_name departments.department_name%TYPE;
BEGIN
   OPEN emp_of_dept_cursor;
   
   LOOP
      -- 3. 데이터 인출
      FETCH emp_of_dept_cursor INTO v_name, v_hdate, v_dept_name;
      DBMS_OUTPUT.PUT_LINE(v_name ||  ', ' ||  v_hdate ||  ', ' || v_dept_name);
      EXIT WHEN emp_of_dept_cursor%NOTFOUND;
   END LOOP ;
END;
/
-- JOIN 이용


DECLARE
   CURSOR emp_in_dept_cursor IS
      SELECT last_name, hire_date, department_name
      FROM   employees e JOIN departments d
                         ON   (e.department_id = d.department_id)
      WHERE  e.department_id = &부서번호;
      
   v_ename     employees.last_name%TYPE;
   v_hdate     employees.hire_date%TYPE;
   v_dept_name departments.department_name%TYPE;
   
BEGIN
   OPEN INTO emp_in_dept_cursor;
   
   LOOP
      FETCH emp_in_dept_cursor INTO v_ename, v_hdate, v_dept_name;
      EXIT WHEN emp_in_dept_cursor%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE(v_ename ||  ', ' ||  v_hdate ||  ', ' || v_dept_name);
   END LOOP;
END;
/

-- 3. 부서번호를 입력(&사용)할 경우 사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))을 출력하는  PL/SQL을 작성하시오.
DECLARE
   CURSOR emp_of_dept_sal_cursor IS
      SELECT last_name,
             salary,
             commission_pct
      FROM   employees
      WHERE  department_id = &부서번호;
   
   v_name      employees.last_name%TYPE;
   v_sal       employees.salary%TYPE;
   v_commipct  NUMBER(5, 2);
BEGIN
   OPEN emp_of_dept_sal_cursor;
   
   LOOP
      -- 3. 데이터 인출
      FETCH emp_of_dept_sal_cursor INTO v_name, v_sal, v_commipct;
      
      DBMS_OUTPUT.PUT_LINE(v_name ||  ', ' ||  v_sal ||  ', ' || (v_sal * 12 + (v_sal * NVL(v_commipct, 0) * 12 )));
      EXIT WHEN emp_of_dept_sal_cursor%NOTFOUND;
   END LOOP ;
END;
/     

      
      
      
      