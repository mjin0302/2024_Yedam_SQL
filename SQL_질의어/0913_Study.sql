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
다음 세 문장의 유효성을 판별하여 True 또는 False로 답하시오.
1. 그룹 함수는 여러 행에 적용되어 그룹 당 하나의 결과를 출력한다.
2. 그룹 함수는 계산에 널을 포함한다.
3. WHERE 절은 그룹 계산에 행(row)을 포함시키기 전에 행을 제한한다.

4. 모든 사원의 급여 최고액, 최저액, 총액 및 평균액을 표시하시오. 열 레이블을 각각 Maximum, Minimum, Sum 및 Average로 지정하고 결과를 정수로 반올림하도록 작성하시오.

5. 위의 질의를 수정하여 각 업무 유형(job_id)별로 급여 최고액, 최저액, 총액 및 평균액을 표시하시오. 

6. 업무별 사원 수를 표시하는 질의를 작성하시오.

7. 관리자 수를 확인하시오. 열 레이블은 Number of Managers로 지정하시오. (힌트: MANAGER_ID 열을 사용)

8. 최고 급여와 최저 급여의 차액을 표시하는 질의를 작성하고 열 레이블을 DIFFERENCE로 지정하시오.

9. 관리자 번호 및 해당 관리자에 속한 사원의 최저 급여를 표시하시오. 관리자를 알 수 없는 사원 및 최저 급여가 6,000 미만인 그룹은 제외시키고 결과를 급여에 대한 내림차순으로 정렬하시오.
*/