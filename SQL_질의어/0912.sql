//----------order by 오름/내림차순 ------------------//
select last_name,
       job_id,
       department_id,
       hire_date
from   employees
order by hire_date DESC;

select employee_id,
        last_name,
        salary*12 annsal
from   employees
order by annsal;

select last_name,
       job_id,
       department_id,
       hire_date
from   employees
order by 3;

select last_name,
       department_id,
       salary
from   employees
order by department_id , salary DESC;

//------------일시적 변수-------------------------//
select employee_id,
       last_name,
       salary,
       department_id
from   employees
where  employee_id = &employee_num;

select employee_id,
       last_name,
       salary,
       department_id
from   employees
where  employee_id = &employee_num;

select last_name,
       department_id,
       salary*12
from   employees
where  job_id = '&job_title';

//-----------영구변수------------------------//
select employee_id,
       last_name,
       job_id,
       &&c_id
from   employees
order by &c_id;

select &c_id
from   employees;

undefine c_id;

//---------------------------dual 함수-----------------------------//
DESC dual; // DESC( describe ) 해당 내용 표시 

select *
from  dual;

select sysdate
from   employees;

select sysdate
from   dual;

//---------------- 숫자 함수 (대소문자 함수) ----------------------//
select  'The job id for '|| 
        UPPER(last_name)||
        ' is ' ||
        LOWER (job_id)
             AS "EMPLOYEE DETAILS"
from   employees;

select employee_id,
       last_name,
       department_id
from   employees
where  last_name = 'higgins';

select employee_id,
       last_name,
       department_id
from   employees
where  LOWER(last_name) = 'higgins';

select employee_id,
       last_name,
       department_id
from   employees
where  UPPER(last_name) = 'HIGGINS';

select employee_id,
       UPPER(last_name),
       department_id
from   employees
where  UPPER(last_name) = 'HIGGINS';

//---------------------문자조작함수-----------------------------//
select employee_id,
       CONCAT (first_name , last_name) NAME,
       job_id,
       LENGTH (last_name),
       INSTR (last_name,'a') "Contains 'a'?"
from   employees
where  SUBSTR(job_id , 4) = 'REP'; // job_id의 4번째 부터 뒤까지의 구간이 rep 인 경우 //

select last_name,
       SUBSTR(last_name,2),
       SUBSTR(last_name,2,3),
       SUBSTR(last_name,-2),
       SUBSTR(last_name, -4, 2)
from  employees;

select 20 || SUBSTR(hire_date, 1,2)
from   employees;

//-------------------------숫자함수----------------------//

select  ROUND(45.923),
        ROUND(45.923 ,2), 
        ROUND(45.923 ,0),
        ROUND(45.923 ,-1) 
from    DUAL;


select  TRUNC(45.923),
        TRUNC(45.923 ,2), 
        TRUNC(45.923 ,0),
        TRUNC(45.923 ,-1) 
from    DUAL;

SELECT last_name,
       salary,
       MOD (salary, 5000)
FROM   employees;

//---------------날짜함수-----------------------//

SELECT SYSDATE
FROM    DUAL;

SELECT TO_CHAR(SYSDATE , 'YYYY,MM,DD HH24:MI:SS')
FROM    DUAL;

//------------날짜 연산-----------------//
SELECT last_name,
       (SYSDATE - hire_date)/7 AS weeks  // 주로 나타내기//
FROM   employees
WHERE  department_id = 90;
// 소숫점 이하는 시.분.초를 나타내는 것이다.//

SELECT  employee_id,
        hire_date,
        MONTHS_BETWEEN (SYSDATE, hire_date) TENURE, // 최근 - 과거 순 이며 근무 날짜 계산 //
        ADD_MONTHS (hire_date,6) REVIEW, //6개월 후 날짜//
        NEXT_DAY (hire_date,'금'), //입사한날에서 부터 바로 다음 금요일// 
        LAST_DAY (hire_date)  // 입사한날의 그 월의 마지막 날 //
FROM    employees;

select next_day (sysdate,'월'),
       last_day (sysdate)
from   dual;

SELECT ROUND(SYSDATE, 'YEAR'),
       ROUND(SYSDATE, 'MONTH'),
       ROUND(SYSDATE, 'DAY'),
       ROUND(SYSDATE, 'DD')
FROM  DUAL;

SELECT TRUNC(SYSDATE, 'YEAR'),
       TRUNC(SYSDATE, 'MONTH'),
       TRUNC(SYSDATE, 'DAY'),
       TRUNC(SYSDATE, 'DD')
FROM  DUAL;

//---------변환함수----------------------// 
SELECT *
FROM  employees
WHERE department_id = '90';

SELECT employee_id,
       TO_CHAR(hire_date, 'MM/YY') Month_Hired
FROM   employees;

ALTER SESSION SET
NLS_DATE_LANGUAGE = AMERICAN;

SELECT last_name,
       TO_CHAR(hire_date , 'DD Month YYYY')
       AS HIREDATE
FROM   employees;

SELECT last_name,
       TO_CHAR(hire_date , 'DD month YYYY')
       AS HIREDATE
FROM   employees;

SELECT last_name,
       TO_CHAR(hire_date , 'fmDD month YYYY')
       AS HIREDATE
FROM   employees;

SELECT last_name,
       TO_CHAR (hire_date,'Ddspth "of" Month YYYY HH:MI:SS:AM')AS HIREDATE
FROM   employees;

SELECT TO_CHAR(salary , '$99,999,00' ) SALARY
FROM   employees
WHERE  last_name = 'Ernst';

SELECT TO_CHAR(salary , 'L99,999,00' ) SALARY
FROM   employees
WHERE  last_name = 'Ernst';

SELECT TO_NUMBER ('$3,400','$99,999')
FROM   DUAL;

SELECT TO_DATE('2010년, 02월','YYYY"년", MM"월"')
FROM   DUAL;

// 2006년 이전에 입사한 모든 사원들의 이름, 입사일을 출력하시요//
SELECT  last_name,
        hire_date
FROM    employees
WHERE   TO_CHAR(hire_date, 'YYYY') < '2006';

ALTER SESSION SET
NLS_DATE_LANGUAGE = KOREAN;

//----일반함수, 중첩함수--------//
//--NVL --// 
SELECT last_name,
       salary,
       NVL(commission_pct, 0),
       (salary*12)+(salary*12*NVL(commission_pct,0))
       AS AN_SAL,
       (salary*12)+(salary*12*commission_pct)
       AS AN_SAL2
FROM   employees;

SELECT  commission_pct,
        NVL(commission_pct,0)
FROM    employees;

SELECT  commission_pct,
        NVL(TO_CHAR(commission_pct),'커미션 없음') // NVL의 경우 앞과 뒤의 데이터 형태가 동일해야 한다. 
FROM    employees;

//--NVL2--//
SELECT last_name,
       salary,
       commission_pct,
       NVL2(commission_pct, 'SAL+COMM', 'SAL') income
FROM  employees
WHERE department_id IN (50, 80);

//--NULLIF--//
SELECT  LENGTH(first_name) "expr1",
        LENGTH(last_name) "expr2",
        NULLIF(LENGTH(first_name),LENGTH(last_name)) AS result
FROM    employees;

