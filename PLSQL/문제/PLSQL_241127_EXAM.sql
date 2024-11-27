-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- EXCEPTION 문제
/*
1.
drop table emp_test;

create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;

emp_test 테이블에서 사원번호를 사용(&치환변수 사용)하여 사원을 삭제하는 PL/SQL을 작성하시오.
(단, 사용자 정의 예외사항 사용)
(단, 사원이 없으면 "해당사원이 없습니다.'라는 오류메시지 발생)
*/
DECLARE
   e_emp_not_found EXCEPTION;
BEGIN
   DELETE FROM emp_test
   WHERE  employee_id = '&사원번호';
   
   IF SQL%ROWCOUNT = 0 THEN
      RAISE e_emp_not_found;
   END IF;
EXCEPTION
   WHEN e_emp_not_found THEN 
      DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/
-- ====================================================================================================
SELECT SUBSTR('9501011667777', 1, 6) || '-' || RPAD(SUBSTR('9501011667777', 7, 1), 7, '*')
FROM dual;
-- PROCEDURE 문제
/* 1. 주민등록번호를 입력하면 다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.
EXECUTE yedam_ju('9501011667777')
950101-1******
EXECUTE yedam_ju('1511013689977')
*/
drop procedure yedam_ju;
CREATE PROCEDURE yedam_ju 
   (ju_min IN VARCHAR2)
IS
   ju_min_format VARCHAR2(100);
BEGIN
   DBMS_OUTPUT.PUT_LINE('ju_min Before : ' || ju_min);
   ju_min_format := SUBSTR(ju_min, 1, 6) || '-' || RPAD(SUBSTR(ju_min, 7, 1), 7, '*');
   DBMS_OUTPUT.PUT_LINE('ju_min After : ' || ju_min_format);
END;
/
EXECUTE yedam_ju('9501011667777');
EXECUTE yedam_ju('1511013689977');
/*
2. 사원번호를 입력할 경우 삭제하는 TEST_PRO 프로시저를 생성하시오. 단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/
DROP PROCEDURE test_pro;
CREATE PROCEDURE test_pro 
   (emp_id IN NUMBER)
IS
   
BEGIN
   DBMS_OUTPUT.PUT_LINE('emp_id : ' || emp_id);
   
   DELETE FROM test01
   WHERE  empid = emp_id;
   
   IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
   END IF;
END;
/
EXECUTE TEST_PRO(176);
/*
3. 다음과 같이 PL/SQL 블록을 실행할 경우 사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는 '*'가 출력되도록 yedam_emp 프로시저를 생성하시오.
실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/
DROP PROCEDURE yedam_emp;
CREATE PROCEDURE yedam_emp
   (e_id IN VARCHAR2)
IS
   v_result VARCHAR2(100);
   e_emp_del_info EXCEPTION;
BEGIN
   SELECT RPAD(SUBSTR(last_name, 1), LENGTH(last_name), '*')
   INTO   v_result
   FROM   employees
   WHERE  employee_id = e_id;
   
   DBMS_OUTPUT.PUT_LINE('사원의 이름은? ' || v_result);
EXCEPTION
   WHEN e_emp_del_info THEN
      DBMS_OUTPUT.PUT_LINE('해당 사원은 존재하지 않습니다.');
END;
/
EXECUTE yedam_emp(176);
/*
4.
부서번호를 입력할 경우 
해당부서에 근무하는 사원의 사원번호, 사원이름(last_name), 연차를 출력하는 get_emp 프로시저를 생성하시오. 
(cursor 사용해야 함)
단, 사원이 없을 경우 "해당 부서에는 사원이 없습니다."라고 출력(exception 사용)
실행) EXECUTE get_emp(30)
*/

/*
5.
직원들의 사번, 급여 증가치만 입력하면 Employees테이블에 쉽게 사원의 급여를 갱신할 수 있는 y_update 프로시저를 작성하세요. 
만약 입력한 사원이 없는 경우에는 ‘No search employee!!’라는 메시지를 출력하세요.(예외처리)
실행) EXECUTE y_update(200, 10)
*/



