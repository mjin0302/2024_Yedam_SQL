SELECT * 
  FROM employees;

SELECT   last_name,
         job_id,
         department_id,
         hire_date
FROM     employees
ORDER BY hire_date DESC;

SELECT   employee_id,
         last_name,
         salary * 12 annsal
FROM     employees
ORDER BY annsal;
 
SELECT   last_name,
         job_id,
         department_id,
         hire_date
FROM     employees
ORDER BY 3;
 
SELECT   last_name,
         department_id,
         salary
FROM     employees
ORDER BY department_id, salary DESC;

-- 치환변수
-- &(싱글엔퍼센트) 한번 사용하고 메모리에서 사라짐
SELECT employee_id,
       last_name,
       salary,
       department_id
FROM   employees
WHERE  employee_id = &employee_num;

-- 문자를 입력할때는 '&job_title' 이렇게 작성하거나 
-- WHERE절에서 ''를 사용하지 않았을 경우 입력창이 뜰 때 ''를 같이 입력해줘야한다
SELECT last_name,
       department_id,
       salary * 12
FROM   employees
WHERE  job_id = '&job_title';
-- &&(더블 엔퍼센트) 메모리에서 직접 삭제하기 전까지는 메모리가 해당 값을 계속 가지고 있다. 
SELECT   employee_id,
         last_name,
         job_id,
         &&c_id
FROM     employees
ORDER BY &c_id;

SELECT &c_id
FROM   employees;

-- 메모리에 저장되어있는 c_id 삭제
UNDEFINE c_id;

-- dual 테이블 유형? 조회
DESC dual;

SELECT * 
FROM   dual;

SELECT SYSDATE
FROM   dual;

SELECT 'The job id for ' || 
       UPPER(last_name) ||
       ' is ' ||
       LOWER(job_id) AS "EMPLOYEE DETAILS"
  FROM employees;

SELECT employee_id,
       last_name,
       department_id
  FROM employees
 WHERE last_name = 'higgins';
 
SELECT employee_id,
       last_name,
       department_id
  FROM employees
 WHERE LOWER(last_name) = 'higgins';
 
-- TRIM ('d', FROM 'ddyedamd') -> yedam (앞, 뒤로 해당글자를 잘라낼 수 있음 단 한글자만 가능)

SELECT  employee_id,
        CONCAT(first_name, last_name) NAME,
        job_id,
        LENGTH (last_name),
        INSTR(last_name, 'a') "Contains 'a'?"
  FROM  employees
 WHERE  SUBSTR(job_id, 4) = 'REP';

select last_name,
       first_name
  from employees
 WHERE UPPER(first_name) = UPPER('Peter');
 
SELECT last_name,
       SUBSTR(last_name, 2),
       SUBSTR(last_name, 2, 3),
       SUBSTR(last_name, -2),
       SUBSTR(last_name, -4, 2)
  FROM employees;
  
SELECT 20 || SUBSTR(hire_date, 1, 2)
FROM    employees;

SELECT TRUNC(45.923),
       TRUNC(45.923, 2), 
       TRUNC(45.923, 0),
       TRUNC(45.923, -1)
  FROM DUAL;

SELECT last_name,
       salary,
       MOD(salary, 5000)
FROM   employees;