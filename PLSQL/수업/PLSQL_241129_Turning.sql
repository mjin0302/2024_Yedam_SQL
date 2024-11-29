-- 1) 사전준비
-- 1-1) 데이터를 저장할 테이블 생성
DROP TABLE t_emps;
CREATE TABLE t_emps
AS 
    SELECT *
    FROM employees;

ALTER TABLE t_emps
ADD CONSTRAINT t_emps_pk PRIMARY KEY (employee_id);

ALTER TABLE t_emps
MODIFY employee_id NUMBER(38,0);

ALTER TABLE t_emps
MODIFY last_name VARCHAR2(1000);

-- 1-2) PRIMARY KEY로 사용할 예정인 컬럼에 들어갈 시퀀스 객체 생성
DROP SEQUENCE t_emps_empid_seq;
CREATE SEQUENCE t_emps_empid_seq
    START WITH 1000;
 
-- 1-3) 임의 데이터 생성
BEGIN
    FOR count IN 1 .. 10 LOOP
        INSERT INTO t_emps(employee_id, last_name, email, hire_date, job_id)
        SELECT t_emps_empid_seq.NEXTVAL, last_name || count, email, hire_date, job_id
        FROM t_emps;
    END LOOP;
END;
/
rollback;
SELECT COUNT(*)
FROM t_emps;
commit;
-- 1) 인덱스를 활용한 검색 유무

-- 예시 1 : 인덱스가 적용되지 않은 컬럼
SELECT *
FROM   t_emps
WHERE  last_name = 'King15';


-- 예시 2 : 인덱스가 적용된 컬럼
SELECT *
FROM   t_emps
WHERE  employee_id = 100000;



-- 2) ORDER BY vs INDEX
-- 예시 1 : 인덱스가 없는 컬럼을 기준으로 정렬한 경우
SELECT   *
FROM     t_emps
ORDER BY last_name;

-- 예시 2 :  인덱스가 있는 컬럼을 기준으로 정렬한 경우
SELECT   *
FROM     t_emps
ORDER BY employee_id;

-- 3) HINT 사용
-- 3-1) FULL : 전체 스캔
-- /*+ FULL (t_emps) */ * -> 힌트는 셀렉트 절에서 컬럼보다 앞에 있어야한다 !!
SELECT /*+ FULL (t_emps) */ * 
FROM   t_emps;

-- 3-2) INDEX_ASC : 인덱스명칭을 지정해줘야한다. 
-- 힌트를 등록 할 때 고유번호를 등록해주는거 추천
SELECT /*+ INDEX_ASC(t_emps t_emps_pk) */ *
FROM   t_emps;

-- 3-3) INDEX_DESC
-- /*+ INDEX_DESC(t_emps t_emps_pk) */ * ->
SELECT /*+ INDEX_DESC(t_emps t_emps_pk) */ *
FROM   t_emps;


SELECT * 
FROM   employees e JOIN departments d
                   ON   e.department_id = d.department_id;

