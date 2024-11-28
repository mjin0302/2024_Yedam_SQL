-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- FUNCTION : 주로 계산하는 용도로 많이 사용하는 객체
-- DML없이 VARCHAR2, NUMBER, DATE 등 SQL에서 사용하는 데이터 타입으로 반환할 경우 SQL문과 함께 사용 가능
-- 1) 문법
CREATE FUNCTION 함수명
   (매개변수명 데이터 타입, ...) -- IN 모드로만 사용가능하므로 모드는 생략
   RETURN 리턴타입
   
IS
   -- 선언부 : 변수, 커서, 예외사항 등을 선언
BEGIN
   -- 실행하고자 하는 코드
   RETURN 리턴값;
EXCEPTION
   WHEN 예외이름 THEN
      -- 예외처리 코드
      RETURN 리턴값;
END;
/

-- 2) 적용
CREATE FUNCTION test_func
   (p_msg VARCHAR2)
   RETURN VARCHAR2
IS
   v_msg VARCHAR2(1000) := 'Hello! ';
BEGIN
   -- 실행하고자 하는 코드
   RETURN (v_msg || p_msg);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      -- 예외처리 코드
      RETURN '데이터가 존재하지 않습니다. ';
END;
/

-- 3) 실행
-- 3-1) PL/SQL블록
DECLARE
   v_result VARCHAR2(1000);
BEGIN
   -- 함수 호출 시 반드시 변수가 필요
   test_func('PL/SQL');
END;
/
-- 3-2) SQL문
SELECT test_func('PL/SQL')
FROM   dual;

-- 더하기
drop function y_sum;
CREATE FUNCTION y_sum
   (p_x NUMBER,
    p_y NUMBER)
RETURN NUMBER
IS

BEGIN
   RETURN (p_x + p_y);
END;
/
    
DECLARE
    v_sum NUMBER(10,0);
BEGIN
    v_sum := y_sum(10,5);
    DBMS_OUTPUT.PUT_LINE(v_sum);
END;
/

SELECT y_sum(10,5)
FROM dual;
SELECT e.employee_id, 
       e.last_name,
       m.manager_id,
       m.last_name
FROM   employees e JOIN employees m
                   ON   e.manager_id = m.manager_id
WHERE  e.employee_id = 107;

-- 사원 번호를 입력받아 해당 사원의 직속상사 이름을 출력
DROP FUNCTION get_mgr;
CREATE FUNCTION get_mgr
   (p_eid employees.employee_id%TYPE)-- 사원번호
RETURN VARCHAR2
IS
   v_mgr_name employees.last_name%TYPE;
BEGIN
   SELECT --e.employee_id, -- 사원번호
          m.last_name    -- 상사번호
   INTO   v_mgr_name
   FROM   employees e JOIN employees m
                      ON   e.manager_id = m.employee_id
   WHERE  e.employee_id = p_eid;
   
   RETURN v_mgr_name;
END;
/
SELECT employee_id, get_mgr(employee_id)
FROM   employees;

SELECT name, line, text
FROM   user_source
WHERE  TYPE IN ('PROCEDURE', 'FUNCTION');
    
    
    
    
    
    
    
    
    
    