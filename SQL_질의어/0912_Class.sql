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

SELECT SYSDATE
FROM   dual;

SELECT TO_CHAR(SYSDATE, 'YYYY,MM,DD HH24:MI:SS')
FROM   dual;

SELECT last_name, (SYSDATE-hire_date) / 7 AS WEEKS
  FROM employees
 WHERE department_id = '90';
 
SELECT employee_id,
       hire_date,
       MONTHS_BETWEEN(SYSDATE, hire_date) THNURE, -- 현재날짜 - 입사일 = 얼마나 근무 했는지
       ADD_MONTHS(hire_date, 6) REVIEW, -- 6개월 후 날짜
       NEXT_DAY(hire_date, '금'), -- 입사일에 첫 번째 금요일은?
       LAST_DAY(hire_date) -- 입사한 월에 마지막 날짜
  FROM employees;

SELECT NEXT_DAY(SYSDATE, '월'), -- 오늘 기준으로 돌아오는 월요일의 날짜를 출력
       LAST_DAY(SYSDATE) -- 현재 월의 마지막 요일 출력
  FROM dual;

SELECT ROUND(SYSDATE, 'YEAR'),
       ROUND(SYSDATE, 'MONTH'),
       ROUND(SYSDATE, 'DAY'), 
       ROUND(SYSDATE, 'DD')
FROM   dual;

SELECT TRUNC(SYSDATE, 'YEAR'), --
       TRUNC(SYSDATE, 'MONTH'), -- 15일 자정 기준
       TRUNC(SYSDATE, 'DAY'), 
       TRUNC(SYSDATE, 'DD')
FROM   dual;

SELECT last_name, 
       TO_CHAR(salary, '$99999') salary
FROM   employees
WHERE  job_id = 'SALESMAN';

SELECT TO_NUMBER('$3,400', '$99,999')
  FROM dual;
  
SELECT TO_DATE('2010년, 02월', 'yyyy"년", MM"월"')
  FROM dual;
  
-- 2006년 이전에 입사한 모든 사원들의 이름, 입사일을  출력
SELECT last_name,
       hire_date
FROM   employees
WHERE  TO_CHAR(hire_date, 'YYYY') < '2006';

SELECT last_name,
       salary,
       NVL(commission_pct, 0),
       (salary * 12) + (salary * 12 * NVL(commission_pct, 0)) AS AN_SAL,
       (salary * 12) + (salary * 12*commission_pct) AS AN_SAL2
FROM   employees;

-- NVL은 앞에 표현식 데이터 타입과 뒤에 표현식 데이터 타입이 같아야한다.
SELECT commission_pct,
       NVL(TO_CHAR(commission_pct), '커미션 없음')
FROM   employees;

-- NVL2(expr1, expr2, expr3) 
-- expr2의 데이터 타입과, expr3의 데이터 타입이 같아야한다.
SELECT last_name,
       salary,
       commission_pct,
       NVL2(commission_pct, 'SAL+COMM', 'SAL') income,
       department_id
FROM   employees
WHERE  department_id IN (50, 80);

SELECT LENGTH(first_name) AS "expr1",
       LENGTH(last_name) AS "expr2",
       NULLIF(LENGTH(first_name), LENGTH(last_name)) AS result
FROM   employees;

-- CASE WHEN THEN
SELECT last_name,
       job_id,
       salary,
       (CASE job_id WHEN 'IT_PROG'  THEN 1.10 * salary
                    WHEN 'ST_CLERK' THEN 1.10 * salary
                    WHEN 'SA_REP'   THEN 1.10 * salary
                                    ELSE salary
        END) "REVISED_SALARY"
  FROM employees;

SELECT last_name,
       job_id,
       salary,
       (CASE WHEN job_id = 'IT_PROG'  THEN 1.10 * salary
             WHEN job_id = 'ST_CLERK' THEN 1.10 * salary
             WHEN job_id = 'SA_REP'   THEN 1.10 * salary
                                      ELSE salary
        END) "REVISED_SALARY"
  FROM employees;
  
SELECT   last_name,
         salary,
        (CASE WHEN salary < 5000  THEN 'Low'
              WHEN salary < 10000 THEN 'Medium'
              WHEN salary < 20000 THEN 'Low'
                                  ELSE 'Excellent'
         END) "REVISED_SALARY"
  FROM   employees
ORDER BY last_name;
-- DECODE
SELECT last_name,
       job_id,
       salary,
       DECODE(job_id, 'IT_PROG' ,  1.10 * salary,
                      'ST_CLERK', 1.10 * salary,
                      'SA_REP'  , 1.10 * salary,
                                  salary)"REVISED_SALARY"
  FROM employees;