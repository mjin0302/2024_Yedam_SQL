/* 1. 다음과 같이 실습에 사용할 MY_EMPLOYEE 테이블을 생성하시오.
CREATE TABLE my_employee
  (id         NUMBER(4) NOT NULL,
   last_name  VARCHAR2(25),
   first_name VARCHAR2(25),
   userid     VARCHAR2(8),
   salary     NUMBER(9,2));

2. MY_EMPLOYEE 테이블의 구조를 표시하여 열 이름을 식별하시오.

3. 다음 예제 데이터를 MY_EMPLOYEE 테이블에 추가하시오.(INSERT)
ID	LAST_NAME 	FIRST_NAME 	USERID 	SALARY
------- --------------- --------------- ------- ------
      1	Patel 		Ralph 		Rpatel 	   895
      2	Dancs 		Betty 		Bdancs 	   860
      3	Biri 		Ben 		Bbiri 	  1100

 */

CREATE TABLE my_employee
  (id         NUMBER(4) NOT NULL,
   last_name  VARCHAR2(25),
   first_name VARCHAR2(25),
   userid     VARCHAR2(8),
   salary     NUMBER(9,2));
   
/* 3. 다음 예제 데이터를 MY_EMPLOYEE 테이블에 추가하시오.(INSERT)
      ID	LAST_NAME 	FIRST_NAME 	USERID 	SALARY
      ------- --------------- --------------- ------- ------
            1	Patel 		Ralph 		Rpatel 	   895
            2	Dancs 		Betty 		Bdancs 	   860
            3	Biri 		  Ben 		  Bbiri 	   1100 */
INSERT INTO my_employee 
            (id,
             LAST_NAME,
             FIRST_NAME,
             USERID,
             SALARY)
VALUES (1, 
        'Patel',
        'Ralph',
        'Rpatel',
        895);
INSERT INTO my_employee 
            (id,
             LAST_NAME,
             FIRST_NAME,
             USERID,
             SALARY)
VALUES (2, 
        'Dancs',
        'Betty',
        'Bdancs',
        860);
INSERT INTO my_employee 
            (id,
             LAST_NAME,
             FIRST_NAME,
             USERID,
             SALARY)
VALUES (3, 
        'Biri',
        'Ben',
        'Bbiri',
        1100);
        
-- 4. 테이블에 추가한 항목을 확인하시오.(SELECT)
SELECT *
FROM   my_employee;
            
-- 6. 사원 3의 성을 Drexler로 변경하시오.(UPDATE)
UPDATE my_employee
SET    last_name = 'Drexler'
WHERE  id = 3;

-- 7. 급여가 900 미만인 모든 사원의 급여를 1000으로 변경하고 테이블의 변경 내용을 확인하시오.(UPDATE)
UPDATE my_employee
SET    salary = 1000
WHERE  salary < 900;

-- 8. MY_EMPLOYEE 테이블에서 사원 3을 삭제하고 테이블의 변경 내용을 확인하시오.(DELETE)
DELETE FROM my_employee
WHERE       id = 3;

SELECT * 
FROM   my_employee;

-- 11. 테이블의 내용을 모두 삭제하고 테이블 내용이 비어 있는지 확인하시오.(DELETE)
DELETE FROM my_employee;

ROLLBACK;