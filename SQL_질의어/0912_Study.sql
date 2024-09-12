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