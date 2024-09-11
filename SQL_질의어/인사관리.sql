SELECT last_name,
       salary,
       12 * (salary + 100)
  FROM employees;

SELECT last_name,
       job_id,
       salary,
       commission_pct
  FROM employees;

SELECT last_name,
       commission_pct,
       12 * salary * NVL(commission_pct, 0)
  FROM employees;
  
SELECT last_name AS name,
       commission_pct comm
  FROM employees;
  
SELECT last_name "Name",
       salary * 12 "Annual Salary"
  FROM employees;
-- || 연결 연산자
SELECT first_name || last_name || job_id AS "Employees"
  FROM employees;
  
SELECT last_name, job_id
from  employees;

-- ""는 별칭과 ...어디에 쓴다고..?
SELECT last_name || ' is a ' || job_id || 3 AS "Employee Details"
  FROM employees;
  
SELECT department_id
  FROM employees;
  
SELECT DISTINCT(department_id)
  FROM employees;

SELECT DISTINCT department_id, job_id
  FROM employees;

-- 테이블 구조 확인
DESC employees;

SELECT employee_id,
       last_name,
       job_id,
       department_id
  FROM employees
 WHERE department_id = 110;

SELECT last_name,
       job_id,
       department_id
  FROM employees
 WHERE last_name = 'whalen';
 
SELECT last_name
  FROM employees
 WHERE hire_date = '06/01/03';

SELECT last_name,
       salary
  FROM employees
 WHERE salary < 3000;

-- BETWEEN low AND high 순서 지킬 것!!
SELECT last_name,
       salary
  FROM employees
 WHERE salary BETWEEN 3500 AND 2500;
 
SELECT last_name
  FROM employees
 WHERE last_name BETWEEN 'King' AND 'Smith';

-- manager_id가 100, 101, 201이 포함된 데이터
SELECT employee_id,
       last_name,
       salary,
       manager_id
  FROM employees
 WHERE manager_id IN (100, 101, 201);
 
SELECT employee_id,
       manager_id,
       department_id
  FROM employees
 WHERE last_name IN ('Hartstein', 'Vargas');
 
SELECT first_name
  FROM employees
 WHERE first_name LIKE 's%';
 
SELECT last_name,
       hire_date
  FROM employees
 WHERE hire_date LIKE '06%';
 
SELECT last_name
  FROM employees
 WHERE last_name LIKE '_o%';
 
-- ESCAPE _를 문자로 인식하기 위해 
SELECT employee_id,
       last_name,
       job_id
  FROM employees
 WHERE job_id LIKE '%3_%'  ESCAPE '3';
 
SELECT last_name,
       manager_id
  FROM employees
 WHERE manager_id IS NULL;

SELECT employee_id,
       last_name,
       job_id,
       salary
  FROM employees
 WHERE salary >= 10000 AND job_id LIKE '%MAN%';
 
 SELECT employee_id,
       last_name,
       job_id,
       salary
  FROM employees
 WHERE salary >= 10000 OR job_id LIKE '%MAN%';

SELECT last_name,
       job_id,
       salary
  FROM employees
 WHERE job_id = 'SA_REP' OR job_id = 'AD_PRES' AND salary > 15000;
 
SELECT last_name,
       job_id,
       salary
  FROM employees
 WHERE (job_id = 'SA_REP' OR job_id = 'AD_PRES') AND salary > 15000;