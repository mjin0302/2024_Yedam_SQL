-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- 암시적 커서
-- insert, update, delete를 한꺼번에 실행하면 마지막에 실행된 결과가 담긴다
-- 암시적 커서 : SQL문의 실행 결과를 담은 메모리 영역
-- => 주 목적 : DML의 실행결과 확인, SQL%ROWCOUNT
BEGIN
  DELETE FROM employees
  WHERE  employee_id = 0;
  
  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '건이 삭제되었습니다.');
END;
/

-- 조건문
-- 1) 기본 IF문 : 특정 조건이 TRUE인 경우만 사용
BEGIN
  DELETE FROM employees
  WHERE  employee_id = &사원번호;
  
  -- 조건이 몇개든 상관없지만 최종 결과는 boolean타입이여야 한다.
  IF SQL%ROWCOUNT > 0 THEN -- THEN이 공간을 나눔 
    DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
  END IF;
END;
/
SELECT employee_id
FROM   employees
WHERE  employee_id NOT IN (SELECT manager_id
                           FROM   employees
                           WHERE  manager_id IS NOT NULL
                           UNION
                           SELECT manager_id
                           FROM   departments
                           WHERE  manager_id IS NOT NULL);
                           
SELECT COUNT(*)
FROM (SELECT DISTINCT manager_id
      FROM employees);
      
-- 2) IF ~ ELSE 문 : 특정 조건을 기준으로 TRUE/FALSE 모두 확인
BEGIN
  DELETE FROM employees
  WHERE  employee_id = &사원번호;
  
  IF SQL%ROWCOUNT >= 1 THEN
    -- 조건식이 TRUE인 경우
    DBMS_OUTPUT.PUT_LINE('정상적으로 삭제되었습니다.');
  ELSE
    -- 위에 선언한 모든 조건식이 FALSE일 경우
    DBMS_OUTPUT.PUT_LINE('삭제 X');
    DBMS_OUTPUT.PUT_LINE('사원 번호를 확인해주세요.');
  END IF;
END;
/
rollback;

-- 3) IF ~ ELSIF ~ ELSE문 : 여러 조건을 기반으로 각 경우의 수를 처리
DECLARE
  v_score NUMBER(2,0) := &점수;
  v_grade CHAR(1);
BEGIN
  -- -- v_score이 가지는 최대값과 최소값 : 최소값 < v_score < 최대값
  IF    v_score >= 90 THEN -- 90 <= v_score <= 99 
        v_grade := 'A';
  ELSIF v_score >= 80 THEN -- v_score이 가지는 최대값과 최소값 : 80 <= v_score <= 89
        v_grade := 'B';
  ELSIF v_score >= 70 THEN -- v_score이 가지는 최대값과 최소값 : 70 <= v_score <= 79
        v_grade := 'C';
  ELSIF v_score >= 60 THEN -- v_score이 가지는 최대값과 최소값 : 60 <= v_score <= 69
        v_grade := 'D';
  ELSE
        v_grade := 'F';    -- v_score이 가지는 최대값과 최소값 : -99 < v_score <= 59
  END IF;
  DBMS_OUTPUT.PUT_LINE(v_grade);
END;
/
  
-- 사원 번호를 입력받아 해당 사원의 업무가(JOB_ID) 영업인 경우('SA'가 포함된 경우)를 확인해주세요. 
-- 출력문구 : 해당 사원의 담당업무는 영업분야 입니다.

/*
1. 사원번호를 입력받아
2. 해당 사원의 업무가 영업인 경우 확인 -> 조건문
2-1) 입력 : 사원번호 -> 필요 : 업무, SELECT문
     SELECT 업무
     FROM   employees
     WHERE  사원번호 = 입력받은 사원번호;
2-2)
   IF 업무가 영업인 경우 => UPPER(v_empjob) LIKE '%SA%' THEN
   출력 : DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 영업분야 입니다.');
*/
DECLARE
  v_empjob employees.job_id%TYPE;
BEGIN
  SELECT job_id
  INTO   v_empjob
  FROM   employees
  WHERE  employee_id = &사원번호;
  
  IF UPPER(v_empjob) LIKE '%SA%' THEN  -- THEN이 공간을 나눔 
    DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 영업분야 입니다.');
  ELSE
    DBMS_OUTPUT.PUT_LINE('해당 사원의 담당업무는 ' || v_empjob || ' 입니다.');
  END IF;
END;
/
SELECT job_id, employee_id
FROM   employees
WHERE  UPPER(job_id) LIKE 'SA%';














