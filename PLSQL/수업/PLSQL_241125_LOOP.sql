-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- LOOP문
BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Hello!!!');
  END LOOP;
END;
/

-- 기본 LOOP문 : 조건없이 무한 LOOP문을 의미 => 반드시 EXIT문을 포함 권장
-- 1) 문법
BEGIN
  LOOP
    --반복하고자 하는 코드
    EXIT WHEN -- 종료조건을 의미
  END LOOP;
END;
/

BEGIN
  LOOP
    DBMS_OUTPUT.PUT_LINE('Hello!!!');
    EXIT;
  END LOOP;
END;
/ 
-- 무한루프 탈출 조건 설정
DECLARE
  v_count NUMBER(1,0) := 0;
BEGIN
  LOOP
    -- 반복하고자 하는 코드
    DBMS_OUTPUT.PUT_LINE('Hello!!!');
    
    -- LOOP문을 제어하는 코드 
    v_count := v_count + 1;
    EXIT WHEN v_count >= 5;
  END LOOP;
END;
/ 

-- 1부터 10까지 정수의 총 합 구하기
DECLARE
  v_count NUMBER(5, 0) := 1;  -- 정수 : 1 ~ 10
  v_sum   NUMBER(10, 0) := 0; -- 총 합
BEGIN
  LOOP
    v_sum := v_count + v_sum;
    v_count := v_count + 1;
    EXIT WHEN v_count > 10;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('v_count : ' || v_count);
  DBMS_OUTPUT.PUT_LINE('v_sum : ' || v_sum);
  DBMS_OUTPUT.PUT_LINE('1 ~ 10까지 합은 => ' || v_sum);
END;
/
-- ========================================================================================================================

-- WHILE LOOP문 : 특정 조건을 만족하는 동안 반복하는 LOOP문을 의미 -> 경우에 따라 실행이 안되는 경우도 있음.
-- 1) 문법
BEGIN
  WHILE LOOP
   DBMS_OUTPUT.PUT_LINE('Hello!!!');
  END LOOP;
END;
/

-- 2) 적용
-- 응용 특정한 조건이 붙을때만 이 while문을 작동한다는걸 알려주기 위해서 
DECLARE 
   v_count NUMBER(1, 0) := 0;
BEGIN
   WHILE v_count < 5 LOOP -- 명확한 반복조건 표기
      -- 반복하고자 하는 코드
      DBMS_OUTPUT.PUT_LINE('Hello!!!');
      
      -- LOOP문을 제어하는 코드
      v_count = v_count + 1;
   END LOOP;
END;
/

-- 1부터 10까지 정수의 총 합 구하기
-- 1) 1부터 10까지 정수
-- 2) 정수들의 총 합
DECLARE 
   v_count NUMBER(2, 0) := 1;
   v_num   NUMBER(5, 0) := 0;
BEGIN
   WHILE v_count <= 10 LOOP
      -- 반복하고자 하는 코드
      v_num := v_num + v_count;
      
      -- LOOP문을 제어하는 코드
      v_count := v_count + 1;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('1 ~ 10의 합은 : ' || v_num);
END;
/

-- ========================================================================================================================
-- FOR LOOP문 : 지정된 범위 안 모든 정수의 갯수만큼 반복
-- 1) 문법
BEGIN
   FOR 임시 변수 IN 최소값 .. 최대값 LOOP -- REVERSE : 범위 내에 존재하는 정수 값을 내림차순으로 가지고 옴
      -- 반복하고자 하는 코드
   END LOOP;
   -- 임시변수 : 정수타입, DECLARE절에 따로 선언하지 않음, 반드시 최소값과 최대값 사이의 정수값만 가짐 => Read Only
   -- 최소값, 최대값 : 정수, 반드시 최소값은 최대값보다 작아야한다.
END;
/

-- 1 ~ 10 까지 합계 구하기
DECLARE
   v_result NUMBER(2,0) := 0;
BEGIN
   FOR num IN 1 .. 10 LOOP -- num : 1 ~ 10까지 정수
      v_result := num + v_result; -- 정수의 합
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('1 ~ 10 총 합 : ' || v_result); -- 결과 출력
END;
/

-- 2) 적용
BEGIN
   FOR idx IN 1 .. 5 LOOP -- REVERSE : 범위 내에
      DBMS_OUTPUT.PUT_LINE(idx || ' , Hello!!! ');
   END LOOP;
END;
/

BEGIN
   FOR idx IN -10 .. -6 LOOP
      DBMS_OUTPUT.PUT_LINE(idx || ' , Hello!!! ');
   END LOOP;
END;
/

DECLARE
   v_max NUMBER(2,0) := &최대값;
BEGIN
   FOR idx IN 5 .. v_max LOOP -- v_max := 0일 경우 FOR LOOP문은 실행되지 않음
      DBMS_OUTPUT.PUT_LINE(idx || ' , Hello!!! ');
   END LOOP;
END;
/