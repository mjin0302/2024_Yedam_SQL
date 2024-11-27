-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- 예외처리 : 예외가 발생했을 때 정상적으로 작업이 종료될 수 있도록 처리
-- 1) 문법
DECLARE

BEGIN

EXCEPTION
   WHEN 예외이름 THEN -- 필요한 만큼 추가 가능
      -- 예외발생시 처리하는 코드
   WHEN OTHERS THEN -- 위에 정의된 예외말고 발생하는 경우 일괄처리
      -- 예외발생시 처리하는 코드
END;
/

-- 2) 적용
-- 2-1) 이미 오라클에 정의되어 있고(에러코드가 존재) 이름도 존재하는 예외사항
DECLARE
   v_ename employees.last_name%TYPE;
BEGIN
   SELECT last_name
   INTO   v_ename
   FROM   employees
   WHERE  department_id = &부서번호;
   -- 부서번호 0 : ORA-01403 : no data found
   -- 부서번호 10 : 정상실행
   -- 부서번호 50 : ORA-01422, TOO_MANY_ROWS
   DBMS_OUTPUT.PUT_LINE('name : '  || v_ename); -- 에러가 발생하면 실행 안됨
   
EXCEPTION
   WHEN NO_DATA_FOUND THEN 
      -- 똑같이 예외는 발생하지만 사용자한테 어떤 에러인지 알려줄 수있다 성공적으로 실행된것처럼 착각을 일으킴
      DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다.');
   WHEN OTHERS THEN -- 일괄처리
      DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생했습니다.');  
      
      -- WHEN절이 끝나는 부분이 명확하지 않아서 아래에 코드를 추가해도 OTHERS절에 포함한다.
      
      DBMS_OUTPUT.PUT_LINE('ORA' || SQLCODE);
      DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM, 12));
      
      DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생했습니다.');
DBMS_OUTPUT.PUT_LINE('블록이 종료되었습니다.');
END;
/

-- 2-2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름은 존재하지 않는 예외사항
DECLARE
   e_emps_remaining EXCEPTION; -- 에러 이름
   PRAGMA EXCEPTION_INIT(e_emps_remaining, -02292);
   -- PRAGMA : 별도의 전처리 과정을 사용하는 명령어
BEGIN
   DELETE FROM departments
   WHERE  department_id = &부서번호;
   -- 부서번호 10 : ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found
EXCEPTION
   WHEN e_emps_remaining THEN
      DBMS_OUTPUT.PUT_LINE('해당 부서는 다른 테이블에서 사용 중입니다.');
END;
/

-- 2-3) 사용자 정의 예외 -> 오라클 입장에선 정상코드로 인지
DECLARE
   e_dept_del_fail EXCEPTION;
BEGIN
   DELETE FROM departments
   WHERE  department_id = &부서번호;
   -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
   IF SQL%ROWCOUNT = 0 THEN
      RAISE e_dept_del_fail;
   END IF;
EXCEPTION
   WHEN e_dept_del_fail THEN
      DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
      DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
END;
/

-- 2-3) 사용자 정의 예외 -> 오라클 입장에선 정상코드로 인지
-- 흐름을 나눠서 처리하는 것 -> IF
-- 흐름을 끊고 차단해야할 때는 예외처리가 나음
-- 단순히 예외사항을 알리고 종료될 때는 조건절이 더 ㄱㅊ
-- 100줄 코드 중 20줄이 실행되고 예외가 생길 때는 Exception으로 건너 뛰는게 좋음
BEGIN
   DELETE FROM departments
   WHERE  department_id = 0;
   -- 부서번호 0 : 정상적으로 수행되지만 기능상 실패로 인지해야 하는 경우
   IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('해당 부서는 존재하지 않습니다.');
      DBMS_OUTPUT.PUT_LINE('부서번호를 확인해주세요.');
   END IF;
END;
/