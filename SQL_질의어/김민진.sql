/* 1. 사원 테이블에서 급여가 7000이상 12000이하이며, 
이름이 'H'로 시작하는 사원의 
사원번호, 이름, 급여, 부서번호를 출력 */
SELECT employee_id,
       last_name,
       salary,
       department_id
FROM   employees
WHERE  UPPER(last_name) LIKE 'H%'
AND    salary BETWEEN 7000 AND 12000;

/* 2. 50번과 60번 부서 직원 가운데 급여가 5000보다 많은 사원의 사원번호, 이름, 업무, 급여, 부서번호 출력 */
SELECT employee_id,
       last_name,
       job_id, 
       salary,
       department_id
FROM   employees
WHERE  department_id IN (50, 60)
AND    salary > 5000;

/* 3. 사원번호를 입력(치환변수)하면 사원이름, 급여, 인상된 급여가 출력되도록 표시하시어.
      단, 인상된 급여는 다음 기준으로 표시하시오. */
SELECT last_name,
       salary,
       (CASE WHEN salary <= 5000  THEN salary * 1.2
             WHEN salary <= 10000 THEN salary * 1.15
             WHEN salary <= 15000 THEN salary * 1.10
                                  ELSE salary
       END)
FROM   employees
WHERE  employee_id = &employee_id;

/* 4. departments 테이블과 locations 테이블에 대하여 join을 수행하여
      부서번호, 부서이름, 도시명을 출력 */
SELECT d.department_id,
       d.department_name,
       l.city
FROM   departments d, locations l
WHERE  d.location_id = l.location_id;

/* 5. 서브쿼리를 사용하여 'IT'부서에서 근무하는(부서이름이 IT인) 사원들의 
      사원번호, 이름(last_name), 업무(job_id)를 표시 */
SELECT employee_id, 
       last_name,
       job_id
FROM   employees
WHERE  department_id = (SELECT department_id
                        FROM   departments
                        WHERE  UPPER(department_name) = 'IT');

/* 6. 2005년 이전에 입사한 사원들 중 job_id가 st_clerk인 사원의 모든 데이터를 표시
      아래 예제와 같은 양식으로 출력
      EMPLOYEE_ID   FIRST_NAME    LAST_NAME   EMAIL   PHONE_NUMBER    HIRE_DATE   JOB_ID */
ALTER SESSION SET
NLS_DATE_LANGUAGE = AMERICAN;

SELECT employee_id,
       first_name,
       last_name,
       email,
       phone_number,
       TO_DATE(hire_date, 'dd-mon-yy') AS "HIRE_DATE",
       job_id
FROM   employees
WHERE  TO_CHAR(hire_date, 'YYYY')	 < '2005'
AND    UPPER(job_id) = UPPER('st_clerk');

/* 7. 커미션을 받는 사원의 이름, 업무, 급여, 커미션을 표시하면서
      데이터를 급여에 대한 내림차순으로 정렬하시오.
      아래 예제와 같은 양식으로 출력되도록 하시오. */
SELECT last_name,
       job_id,
       salary,
       TO_CHAR(commission_pct, 'FM9999.99') AS "COMMISSION_PCT"
FROM   employees
ORDER BY salary DESC;

/* 8. 다음의 요구사항대로 PROF 테이블을 생성하고 테이블 생성 명령어를 적으시오 */
CREATE TABLE PROF
            (PROFNO   NUMBER(4),
             NAME     VARCHAR2(15) NOT NULL,
             ID       VARCHAR2(15) NOT NULL,
             HIREDATE DATE,
             PAY      NUMBER(4)
            );

/*9. 다음과 같이 prof 테이블에 DML을 발생하고 해당 명령문을 기록하시오 */
-- (1) 다음과 같은 결과가 출력되도록prof 테이블에 데이터를 입력하시오.
--     입력 후 반드시 commit하시오
INSERT INTO prof (profno,
                  name,
                  id,
                  hiredate,
                  pay)
VALUES           (1001,
                  'Mark',
                  'm1001',
                  '07/03/01',
                  800);
INSERT INTO prof (profno,
                  name,
                  id,
                  hiredate)
VALUES           (1003,
                  'Adam',
                  'a1003',
                  '11/03/02');
commit;
/* 9-2 1001번 교수의 급여를 1200으로 수정하시오 */
UPDATE prof
SET    pay = 1200
WHERE  profno = 1001;

/* 9-3 1003번 교수정보를 삭제하시오 */
DELETE prof
WHERE  profno = 1003;

/* 10 prof 테이블에 대하여 다음의 지시사항을 실행하시오 */
-- 10-1 prof테이블의 profno 열에 primary key를 추가하시오
ALTER TABLE prof
ADD   PRIMARY KEY(profno);

/* 10-2 prof table에 성별을 저장하는 새 열을 추가하시오.
        열 이름은gender, 데이터 유형은 char(3)으로 지정한다 */
ALTER TABLE prof
ADD        (GENDER CHAR(3));

/* 10-3 prof 테이블 name열의 길이를 20으로 변경하시오. */
ALTER TABLE prof
MODIFY     (name VARCHAR(20));

desc prof;