/* 
3. 이름, 입사일 및 업무 시작 요일을 표시하고
   열 레이블을 DAY로 지정하시오. (날짜 함수)
   월요일을 시작으로 해서 요일을 기준으로 결과를 정렬하시오. (산수) 
*/
SELECT   last_name,
         hire_date,
         TO_CHAR(hire_date, 'DAY') AS DAY,
         (CASE TO_CHAR(hire_date, 'DAY') WHEN '월요일' THEN '1'
                                         WHEN '화요일' THEN '2'
                                         WHEN '수요일' THEN '3'
                                         WHEN '목요일' THEN '4'
                                         WHEN '금요일' THEN '5'
                                         WHEN '토요일' THEN '6'
                                                      ELSE '7'
          END) as float_day
FROM     employees
ORDER BY float_day;

/* 
4. 사원의 이름과 커미션을 표시하는 질의를 작성하시오.
   커미션을 받지 않는 사원일 경우 “No Commission”을 표시하시오. (NVL 함수)
   열 레이블은 COMM으로 지정하시오.
*/
SELECT last_name,
       commission_pct,
       NVL(TO_CHAR(commission_pct), 'No Commission') AS "COMM"
  FROM employees;

/* 
5. CASE 구문을 사용하여 다음 데이터에 따라 JOB_ID 열의 값을 기준으로 
   모든 사원의 등급을 표시하는 질의를 작성하시오. 
      업무         등급
    AD_PRES        A
    ST_MAN         B
    IT_PROG        C
    SA_REP         D
    ST_CLERK       E
      그외          0 
*/ 
SELECT job_id,
       (CASE UPPER(job_id) WHEN 'AD_PRES'  THEN 'A'
                           WHEN 'ST_MAN'   THEN 'B'
                           WHEN 'IT_PROG'  THEN 'C'
                           WHEN 'SA_REP'   THEN 'D'
                           WHEN 'ST_CLERK' THEN 'E'
                                           ELSE '0'
        END)
FROM   employees;

/* 
  사원이름, 급여, 커미션 수령 유무를 출력하시오.
  단, 커미션 수령 유무는 커미션을 받으면 Yes, 받지 않으면 NO 출력
  커미션 수령 유무 열별칭은 "commission"으로 출력 
*/
SELECT last_name,
       salary,
       NVL2(commission_pct, 'Yes', 'NO') AS "commission"
FROM   employees;

-- 만약 사용 DB가 오라클이 아니라면?
SELECT last_name,
       salary,
       (CASE WHEN commission_pct IS NULL THEN 'Yes'
                                         ELSE 'NO'
        END) AS "commission"
FROM   employees;

/* 
  급여가 20000 이하이면 20% 인상된 급여,
  급여가 30000 이하이면 15% 인상된 급여,
  급여가 50000 이하이면 10% 인상된 급여,
  급여가 50000 이상이면 급여 그대로 출력
  단, 사원이름(last_name), 원래급여(salary), 인상된 급여 순서로 출력 
*/
SELECT   last_name,
         salary,
         (CASE WHEN salary <= 20000 THEN salary * 1.20
               WHEN salary <= 30000 THEN salary * 1.15
               WHEN salary <= 50000 THEN salary * 1.10
                                    ELSE salary
          END) AS "salary"
FROM     employees
ORDER BY 1, 3 DESC; 

/* 

*/