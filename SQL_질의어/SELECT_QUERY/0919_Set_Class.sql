-- 집합 연산자
SELECT * 
FROM   employees;

SELECT *
FROM   job_history;

-- 합집합
-- UNION : 2개의 테이블 중복 값 제외
SELECT employee_id,
       job_id
FROM   employees
UNION
SELECT employee_id,
       job_id
FROM   job_history;

-- UNION ALL : 2개의 테이블 중복 값 포함
SELECT employee_id,
       job_id
FROM   employees
UNION ALL
SELECT employee_id,
       job_id
FROM   job_history;

-- 차집합
SELECT employee_id, 
       job_id
FROM   employees
MINUS
SELECT employee_id, 
       job_id
FROM   job_history;

-- 주의!!! 차집합은 아래 위 테이블 위치를 바꾸면 결과가 달라짐 !!
SELECT employee_id, 
       job_id
FROM   job_history
MINUS
SELECT employee_id, 
       job_id
FROM   employees;

-- 교집합
SELECT employee_id, 
       job_id
FROM   employees
INTERSECT
SELECT employee_id, 
       job_id
FROM   job_history;

