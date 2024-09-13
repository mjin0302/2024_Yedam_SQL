-- 중첩함수
SELECT AVG(salary), -- NULL값 무시
       MAX(salary), -- NULL값 무시
       MIN(salary), -- NULL값 무시
       SUM(salary)  -- NULL값 무시
FROM   employees
WHERE  job_id LIKE '%REP%';

SELECT MIN(hire_date), 
       MAX(hire_date)
FROM   employees;

SELECT MIN(last_name),
       MAX(last_name)
FROM   employees;

-- 사원이 몇명이냐?
SELECT COUNT(*)
FROM   employees;

-- 부서에 소속된 사원이 몇명이냐
SELECT COUNT(DISTINCT dapartment_id)
FROM   employees;

-- 그룹함수 : AVG
SELECT AVG(commission_pct)
FROM   employees;

-- 그룹함수 : AVG을 사용할때는 NVL 함수를 사용하자
SELECT AVG(NVL(commission_pct, 0))
FROM   employees;

SELECT   department_id,
         AVG(NVL(salary, 0))
FROM     employees
GROUP BY department_id;

SELECT   AVG(NVL(salary, 0))
FROM     employees
GROUP BY department_id;

SELECT   department_id,
         AVG(NVL(salary, 0))
FROM     employees
GROUP BY department_id
ORDER BY AVG(salary);

SELECT   department_id,
         job_id,
         SUM(salary)
FROM     employees
WHERE    department_id > 40
GROUP BY department_id, job_id
ORDER BY job_id;

-- WHERE 구문에서 원본 테이블에서 데이터를 가져올 때 그룹해져 있지 않은 데이터를 달라고 하니 오류가 터짐
SELECT department_id, AVG(salary)
FROM   employees
WHERE  AVG(salary) > 8000
GROUP BY department_id;

-- HAVING절
/* 1. FROM and JOIN절 
   2. WHERE절 
   3. GROUP BY 
   4. HAVING 
   5. SELECT 
   6. ORDER BY 
   7. LIMIT */
SELECT   department_id,
         AVG(salary)
FROM     employees
GROUP BY department_id
HAVING   AVG(salary) > 8000;

SELECT   last_name,
         department_id,
         MAX(salary)
FROM     employees
GROUP BY last_name, department_id
HAVING   AVG(salary) > 10000;

SELECT   last_name,
         department_id,
         AVG(salary)
FROM     employees
GROUP BY last_name, department_id
HAVING   MAX(salary) > 10000;

SELECT   job_id,
         SUM(salary) PAYROLL
FROM     employees
WHERE    UPPER(job_id) NOT LIKE '%REP%'
GROUP BY job_id
HAVING   SUM(salary) > 13000
ORDER BY SUM(salary);

SELECT   MAX(AVG(salary))
FROM     employees
GROUP BY department_id;

-- 오류 원인
-- SELECT절에 그룹함수를 중첩할 때는 SELECT절에 어떠한 컬럼도 올 수 없다.
SELECT   department_id,
         MAX(AVG(salary))
FROM     employees
GROUP BY department_id;