/*4. last name이 Matos와 Taylor인 사원의 last_name, 업무 ID, 그리고 입사일을 표시하시오. 
     결과는 입사일을 기준으로 오름차순 정렬하시오. */
SELECT   last_name,
         job_id,
         hire_date
FROM     employees
WHERE    last_name IN ('Matos' , 'Taylor') -- last_name = 'Matos' OR last_name = 'Taylor'
ORDER BY hire_date;
 
/* 5. 부서 20 및 50에 속하는 모든 사원의 이름과 부서 번호를 
      이름을 기준으로 영문자순으로 표시하시오. */
SELECT   last_name,
         department_id
  FROM   employees
 WHERE   department_id BETWEEN 20 AND 50
ORDER BY last_name;

SELECT   last_name,
         department_id
  FROM   employees
 WHERE   department_id BETWEEN 20 AND 50
ORDER BY last_name;

-- 9. 커미션을 받는 모든 사원의 이름, 급여 및 커미션을 급여 및 커미션을 기준으로 내림차순으로 정렬하시오.
SELECT   last_name,
         salary,
         commission_pct 
FROM     employees
WHERE    commission_pct IS NOT NULL
ORDER BY salary DESC, commission_pct DESC;

-- ----------------------------------------------------------------------------------------------------
/* 4. 이름이 J, A 또는 M으로 시작하는 모든 사원의 이름(대문자 표시) 및 
      이름 길이를 표시하는 질의를 작성하고 각 열에 적합한 레이블을 지정하시오. 
      결과를 사원의 이름에 따라 정렬하시오. */
SELECT   UPPER(last_name) AS "LNAME",
         LENGTH(last_name)AS "LENGTH"
FROM     employees
WHERE    UPPER(SUBSTR(last_name, 1, 1)) IN ('J', 'A', 'M')
ORDER BY last_name;

/* 6. 모든 사원의 성 및 급여를 표시하기 위한 query를 작성.
      급여가 15자 길이로 표시되고 왼쪽에 $ 기호가 채워지도록 형식을 지정하시오.
      열 레이블을 SALARY로 지정합니다. */
SELECT first_name,
       LPAD(salary, 15, '$') AS "SALARY"
  FROM employees;
-- ----------------------------------------------------------------------------------------------------
/* 2. 각 사원에 대해 사원 번호, 이름, 급여 및 15% 인상된 급여를 정수로 표시하시오
      인상된 급여 열의 레이블을 New Salary로 지정하시오 */
SELECT employee_id,
       last_name,
       salary,
       ROUND(salary * 1.15) AS "New Salary"
  FROM employees;
  
/* 3. 2번 질의를 수정하여 새 급여에서 이전 급여를 빼는
      새 열을 추가하고 레이블을 Increase로 지정하고 수정한 질의를 실행하시오. */
SELECT employee_id,
       last_name,
       salary * 1.15 AS "New Salary",
       (salary * 1.15) - salary AS Increase,
       (salary * 0.15) AS "Increase"
  FROM employees;

-- ----------------------------------------------------------------------------------------------------
/* 각 사원의 이름을 표시하고 근무 달 수(입사일로부터 현재까지의 달 수)를 계산하여
   열 레이블을 MONTHS_WORKED로 지정하시오.
   결과는 정수로 반올림하여 표시하시오. */
SELECT last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS "MONTHS_WORKED"
  FROM employees;
  
/* 부서번호 90의 모든 사원에 대해 이름(last_name) 및 재직 기간(주 단위)을 표시하도록 query를 작성
   주를 나타내는 숫자 열의 레이블로 TENURE를 지정하고 주를 나타내는 숫자 값을 정수로 나타내시오. */
SELECT last_name,
       ROUND((SYSDATE - hire_date) / 7) AS "TENURE"
  FROM employees
 WHERE department_id = 90;
 
SELECT * 
  FROM employees
 WHERE department_id = '90';
-- ----------------------------------------------------------------------------------------------------
alter session set nls_date_language = korean;
/* 1. 각 사원에 대해 다음 항목을 생성하는 질의를 작성하고
      열 레이블의 Dream Salaries로 지정하시오. (변환 함수, 연결 연산자) */
-- <이름> earns <급여> monthly but wants <급여의 3배>.
-- <예시> Matos earns $2,600.00 monthly but wants $7,800.00
SELECT last_name || 
       ' earns ' || 
       TO_CHAR(ROUND(salary * 3), '$999,999.99') || 
       ' monthly but wants ' ||
       TO_CHAR(salary * 3, '$999,999.99') || 
       '.' AS "Dream Salaries"
FROM   employees;

/* 2. 사원의 이름, 입사일 및 급여 검토일을 표시하시오.
      급여 검토일은 여섯 달이 경과한 후 첫번째 월요일입니다.
      열 레이블을 REVIEW로 지정하고 날짜는 "2010.03.31 월요일"과 같은 형식으로 표시되도록 지정하시오. (날짜 함수) */
SELECT   last_name,
         hire_date,
         TO_CHAR(NEXT_DAY(ADD_MONTHS(hire_date, 6),'월요일'), 'YYYY.MM.DD DAY') AS "REVIEW"
FROM     employees
ORDER BY 1, 3 DESC;