/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
*/
DECLARE
   CURSOR emp_cursor IS
      SELECT employee_id eid, last_name ename, hire_date hdate -- 
      FROM   employees;
BEGIN
   FOR emp_rec IN emp_cursor LOOP -- 커서 기반으로 순차적으로 데이터를 끌고 들어옴
      IF TO_CHAR(emp_rec.hdate, 'yyyy') <= '2020' THEN
         INSERT INTO test01 (empid, ename, hiredate)
         VALUES      (emp_rec.eid, emp_rec.ename, emp_rec.hdate);
      ELSE
         INSERT INTO test02
         VALUES      emp_rec; -- 커서의 구성과 레코드 타입의 구성과 같다면 레코드 타입을 통채로 insert하는것도 가능
      END IF;
   END LOOP;
END;
/

-- 2. 부서번호를 입력할 경우(&치환변수 사용) 해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
-- 실제로 넘어온 데이터를 확인해야 할 경우에 많이 사용~~
DECLARE
   CURSOR emp_in_dept_cursor IS
      SELECT last_name ename, 
             hire_date hdate,
             department_name dname
      FROM   employees e JOIN departments d
                         ON (e.department_id = d.department_id)
      WHERE  e.department_id = e.department_id; 
BEGIN
   FOR emp_dept_rec IN emp_in_dept_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(emp_dept_rec.ename ||  ', ' ||  emp_dept_rec.hdate ||  ', ' || emp_dept_rec.dname);
   END LOOP;
END;
/

-- cursor FOR LOOP문은 서브쿼리를 이용해서 동작 가능(단, 속성은 사용불가)
BEGIN
   FOR emp_rec IN (SELECT last_name ename, 
                          hire_date hdate,
                          department_name dname
                   FROM   employees e JOIN departments d
                                        ON (e.department_id = d.department_id)
                   WHERE  e.department_id = e.department_id) LOOP
      DBMS_OUTPUT.PUT_LINE(emp_rec.ename ||  ', ' ||  emp_rec.hdate ||  ', ' || emp_rec.dname);
   END LOOP;
END;
/

-- 3. 부서번호를 입력(&사용)할 경우 사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))을 출력하는  PL/SQL을 작성하시오.
DECLARE
   CURSOR emp_of_dept_cursor IS
      SELECT last_name ename,
             salary sal,
             (salary * 12 + (salary * NVL(commission_pct, 0) * 12 )) yearsal
      FROM   employees
      WHERE  department_id = &부서번호;
BEGIN
   FOR emp_rec IN emp_of_dept_cursor LOOP
      DBMS_OUTPUT.PUT_LINE(emp_rec.ename ||  ', ' ||  emp_rec.sal ||  ', ' || emp_rec.yearsal);
   END LOOP;
END;
/

DECLARE
   CURSOR emp_of_dept_cursor IS
      SELECT last_name ename,
             salary sal,
             commission_pct cmm
      FROM   employees
      WHERE  department_id = &부서번호;
      
   v_year NUMBER(10, 2); -- 연봉
BEGIN
   FOR emp_rec IN emp_of_dept_cursor LOOP
      DBMS_OUTPUT.PUT(emp_rec.ename);
      DBMS_OUTPUT.PUT(', ' ||  emp_rec.sal);
      DBMS_OUTPUT.PUT_LINE(', ' || v_year);
   END LOOP;
END;
/     