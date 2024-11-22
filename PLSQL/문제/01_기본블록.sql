/*
1.
사원번호를 입력(치환변수사용&)할 경우
사원번호, 사원이름, 부서이름  
을 출력하는 PL/SQL을 작성하시오.
*/
DECLARE
  v_eid employees.employee_id%TYPE; --
  v_name employees.last_name%TYPE;
  v_deptname departments.department_name%TYPE;
BEGIN
  SELECT e.employee_id,
         e.last_name,
         d.department_name
  INTO   v_eid,
         v_name,
         v_deptname
  FROM   employees e
         JOIN departments d
         ON   (e.department_id = d.department_id)
  WHERE  e.employee_id = &사원번호;
  DBMS_OUTPUT.put_LINE(v_eid);
  DBMS_OUTPUT.put_LINE(v_name);
  DBMS_OUTPUT.put_LINE(v_deptname);
END;
/

DECLARE
  v_eid employees.employee_id%TYPE; --
  v_name employees.last_name%TYPE;
  v_deptid   departments.department_id%TYPE;
  v_deptname departments.department_name%TYPE;
BEGIN
  SELECT employee_id,
         last_name,
         department_id
  INTO   v_eid,
         v_name,
         v_deptid
  FROM   employees 
  WHERE  employee_id = &사원번호;
  
  SELECT department_name
  INTO   v_deptname
  FROM   departments
  WHERE  department_id = v_deptid;
  DBMS_OUTPUT.put_LINE(v_eid);
  DBMS_OUTPUT.put_LINE(v_name);
  DBMS_OUTPUT.put_LINE(v_deptid);
  DBMS_OUTPUT.put_LINE(v_deptname);
END;
/

DECLARE
  v_eid employees.employee_id%TYPE;
  v_name employees.last_name%TYPE;
  v_deptname departments.department_name%TYPE;
BEGIN
  SELECT e.employee_id,
         e.last_name,
         (SELECT department_name FROM departments d WHERE e.department_id = d.department_id)
  INTO   v_eid,
         v_name,
         v_deptname
  FROM   employees e
  WHERE  e.employee_id = &사원번호;
  DBMS_OUTPUT.put_LINE(v_eid);
  DBMS_OUTPUT.put_LINE(v_name);
  DBMS_OUTPUT.put_LINE(v_deptname);
END;
/

/*
2.
사원번호를 입력(치환변수사용&)할 경우 
사원이름, 급여, 연봉->(급여*12+(nvl(급여,0)*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
DECLARE
  v_name   employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
  v_year   VARCHAR2(100);
BEGIN
  SELECT last_name,
         salary,
         TO_CHAR((salary * 12 + (NVL(salary, 0) * NVL(commission_pct, 0) * 12)), '9,999,999') AS "연봉"
  INTO   v_name,
         v_salary,
         v_year
  FROM   employees 
  WHERE  employee_id = &사원번호;
  DBMS_OUTPUT.put_LINE(v_name);
  DBMS_OUTPUT.put_LINE(v_salary);
  DBMS_OUTPUT.put_LINE(v_year);
END;
/

DECLARE
  v_name   employees.last_name%TYPE;
  v_salary employees.salary%TYPE;
  v_comm   employees.commission_pct%TYPE;
  v_year   VARCHAR2(100);
BEGIN
  SELECT last_name,
         salary,
         commission_pct
  INTO   v_name,
         v_salary,
         v_comm
  FROM   employees 
  WHERE  employee_id = &사원번호;
  
  v_year := (v_salary * 12 + (NVL(v_salary, 0) * NVL(v_comm, 0) * 12));
  
  DBMS_OUTPUT.put_LINE(v_name);
  DBMS_OUTPUT.put_LINE(v_salary);
  DBMS_OUTPUT.put_LINE(v_year);
END;
/