select * from employees;
-- 1. 급여가 12,000를 넘는 사원의 이름과 급여를 표시하는 질의를 실행하시오.
SELECT last_name,
       salary
  FROM employees
 WHERE salary >= 12000;
 
-- 2. 사원 번호가 176인 사원의 이름과 부서 번호를 표시하는 질의를 실행하시오.
SELECT last_name,
       department_id
  FROM employees
 WHERE employee_id = 176;
 
/* 3. 급여가 5,000에서 12,000 사이에 포함되지 않는 
      모든 사원의 이름과 급여를 표시하도록 질의를 실행하시오. */
SELECT last_name,
       salary
  FROM employees
 WHERE salary NOT BETWEEN 5000 AND 12000;
 
-- 4. last name이 Matos와 Taylor인 사원의 last_name, 업무 ID, 그리고 입사일을 표시하시오.
SELECT last_name,
       job_id,
       hire_date
  FROM employees
 WHERE last_name like 'Matos' OR last_name like 'Taylor';
 
/* 6. 급여가 5,000와 12,000 사이이고 부서 번호가 20 또는 50인 사원의 이름과 급여를 나열하도록 질의를 작성하시오. 
   열 레이블은 Employee와 Monthly Salary로 각각 지정하시오. */
SELECT last_name AS Employee,
       salary AS "Monthly Salary"
  FROM employees
 WHERE (salary BETWEEN 5000 AND 12000) AND (department_id = 20 OR department_id = 50);
 
-- 7. 2004년에 입사한 모든 사원의 이름과 입사일을 표시하시오.
-- 다시 확인해보기!!
SELECT last_name,
       hire_date
  FROM employees
 WHERE hire_date LIKE '04%';
 
-- 8. 관리자가 없는 모든 사원의 이름과 업무를 표시하시오.
SELECT last_name,
       job_id
  FROM employees
 WHERE manager_id IS NULL;
 
-- 10. 이름의 세번째 문자가 a인 모든 사원의 이름을 표시하시오.
SELECT last_name
  FROM employees
 WHERE last_name LIKE '__a%';
 
-- 11. 이름에 a와 e가 있는 모든 사원의 이름을 표시하시오.
-- 다시 확인해보기!!
SELECT last_name
  FROM employees
 WHERE last_name LIKE '%a%'
   And last_name LIKE '%e%';
 
-- 12. 업무가 영업 사원(SA_REP) 또는 사무원(ST_CLERK)이면서 
--     급여가 2,500, 3,500, 7,000이 아닌 모든 사원의 이름, 업무 및 급여를 표시하시오.
SELECT last_name,
       job_id,
       salary
  FROM employees
 WHERE (job_id = 'SA_REP' OR job_id = 'ST_CLERK')
   AND salary NOT IN (2500, 3500, 7000);
   
-- 13. 커미션 비율(commission_pct)이 20%인 모든 사원의 이름, 급여 및 커미션을 표시하도록 
--     명령문을 작성하여 실행하시오.
SELECT last_name,
       salary,
       commission_pct
  FROM employees
 WHERE commission_pct = 0.2;
