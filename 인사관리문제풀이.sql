-- 6. 테이블 구조와 같은 테이블(department, employee)을 생성하는 SQL문을 작성하시오.(단 반드시 필요한 제약조건을 포함하시오) 
CREATE TABLE department (
  deptid    NUMBER(10)    NOT NULL,
  deptname  VARCHAR2(10),
  location  VARCHAR2(10),
  tel       VARCHAR2(15)
);

ALTER TABLE department
ADD CONSTRAINT pk_deptid PRIMARY KEY (deptid);


CREATE TABLE employee2 (
  empid     NUMBER(10)    NOT NULL,
  empname   VARCHAR2(10),
  hiredate  DATE,
  addr      VARCHAR2(12),
  tel       VARCHAR2(15),
  deptid    NUMBER(10) REFERENCES department(deptid)
-- CONSTRANINT emp_deptid_fk FOREIGN KEY(deptid) REFERENCES department(deptid)
);

ALTER TABLE employee2
ADD CONSTRAINT pk_empid PRIMARY KEY (empid);

-- 7. 직원(employee) 테이블에 생년월일(birthday) 컬럼을 추가하는 SQL문을 작성하시오.
ALTER TABLE employee2 ADD birthday VARCHAR(50);

-- 8. 조회된 결과와 같은 데이터를 입력하는 SQL문을 작성하시오.
INSERT INTO department (deptid,
                        deptname,
                        location,
                        tel)
VALUES                 (1003,
                        '영업팀',
                        '본 103호',
                        '053-222-3333');
                        
INSERT INTO employee2 (empid,
                       empname,
                       hiredate,
                       addr,
                       tel,
                       deptid)
VALUES                (20121646,
                       '이융희',
                       TO_DATE('20120901', 'YY/MM/DD'),
                       '부산',
                       '010-1234-2222',
                       '1003');
                       
-- 9. 직원 테이블의 직원명(empname) 컬럼에 NOT NULL 제약 조건을 추가하세요
ALTER TABLE employee2
MODIFY empname CONSTRAINT empname_NN NOT NULL; 

-- 10. 총무팀에 근무하는 직원의 이름, 입사일, 부서명을 출력하시오.
SELECT empname, 
       hiredate, 
       d.deptname
FROM   employee2 ely, department d
WHERE  ely.deptid = d.deptid
AND    deptname = '총무팀';

-- 11. 직원 테이블에서 "대구"에 살고 있는 직원을 모두 삭제하시오.
DELETE FROM employee2
WHERE addr = '대구';

-- 12. 직원 테이블에서 "영업팀"에 근무하는 직원을 모두 "회계팀"으로 수정하는 SQL문을 작성하시오
UPDATE employee2
SET    deptid = (SELECT d.deptid FROM department d WHERE d.deptname = '회계팀')
WHERE  deptid = (SELECT d.deptid FROM department d WHERE d.deptname = '영업팀');

-- 13. 직원 테이블에서 직원번호가 '20121729"인 직원의 입사일보다 늦게 입사한 직원의 직원번호, 이름, 생년월일, 부서이름을 출력하는 SQL문을 작성하시오.
SELECT empid,
       empname,
       birthday,
       deptname
FROM   employee2 ely, department d
WHERE  ely.deptid = d.deptid
AND    hiredate > (SELECT hiredate
                   FROM   employee2
                   WHERE  empid = '20121729');


-- 14. 총무팀에 근무하는 직원의 이름, 주소, 부서명을 볼 수 있는 뷰(view)를 생성하시오
CREATE VIEW v_emp 
AS
    SELECT empname,
           addr,
           deptname
    FROM   employee2 e
           JOIN department d
           ON   (e.deptid = d.deptid)
    WHERE  d.deptname = '총무팀';
    
SELECT *
FROM   v_emp;

SELECT * FROM employee2;
SELECT * FROM department;