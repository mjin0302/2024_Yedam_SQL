-- 명시적 커서 : 다중 행 SELECT문을 실행하기 위한 PL/SQL 문법
SELECT * 
FROM   employees;

-- 1) 문법
DECLARE
   -- 1. 커서 정의 -> 그저 정의
   CURSOR 커서명 IS
      SELECT문(SQL의 SELECT문, INTO절 사용불가);
      
BEGIN
   -- 2. 커서 실행 -> 실행되는 순간
   -- 2-1) 커서를 실제 실행해서 활성집합(결과)를 식별
   -- 2-2) 포인터를 가장 위로 배치
   OPEN 커서명;
   
   -- 3. 데이터 인출
   -- 3-1) 포인터를 아래로 이동
   -- 3-2) 현재 가리키는 데이터를 인출
   FETCH 커서명 INTO 변수;
   
   -- 4. 커서 종료 : 활성집합(결과)를 삭제
   CLOSE 커서명;
   
END;
/

-- 2) 적용
DECLARE
   -- 1. 커서 정의
   CURSOR emp_cursor IS
      SELECT employee_id, last_name, hire_date
      FROM   employees;
   
   -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
   v_eid   employees.employee_id%TYPE;
   v_ename employees.last_name%TYPE;
   v_hdate employees.hire_date%TYPE;
BEGIN
   -- 2. 커서 실행
   OPEN emp_cursor;
   
   -- 3. 커서에서 데이터 인출
   -- into절에 들어가는건 커서 정의 select문에 있는 컬럼 수와 같아야 한다
   -- select절에 순서와 동일하게 넣어줘야함
   FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
   
   -- 3.5 데잍를 기반으로 연산
   DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
   
   -- 4. 커서 종료
   CLOSE emp_cursor;
END;
/

-- 명시적 커서의 속성과 기본 LOOP문
DECLARE
   -- 1. 커서 정의
   CURSOR emp_cursor IS
      SELECT employee_id, last_name, hire_date
      FROM   employees;
   
   -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
   v_eid   employees.employee_id%TYPE;
   v_ename employees.last_name%TYPE;
   v_hdate employees.hire_date%TYPE;
BEGIN
   -- 2. 커서 실행
   OPEN emp_cursor;
   
   LOOP
      -- 3. 커서에서 데이터 인출
      -- 현재 커서의 실제 데이터 수를 확인은 불가 
      FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
      EXIT WHEN emp_cursor%NOTFOUND; -- FETCH를 이용해서 가져온 데이터가 새롭지 않을 때 무한루프 종료조건
   
      -- 3.5 데이터를 기반으로 연산
      DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT || ' : '); -- FETCH를 실행해서 가져온 행 수 
      DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
   END LOOP;
   -- 4. 커서 종료
   -- close작업을 하지 않으면 계속 마지막행 데이터를 보고있을꺼임 즉, 커서는 종료되기 전까지 계속 실행중
   CLOSE emp_cursor;
END;
/

-- ISOPEN
DECLARE
   -- 1. 커서 정의
   CURSOR emp_cursor IS
      SELECT employee_id, last_name, hire_date
      FROM   employees;
   
   -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
   v_eid   employees.employee_id%TYPE;
   v_ename employees.last_name%TYPE;
   v_hdate employees.hire_date%TYPE;
BEGIN
   -- 2. 커서 실행
   OPEN emp_cursor;
   
   LOOP
      -- 3. 커서에서 데이터 인출
      -- 현재 커서의 실제 데이터 수를 확인은 불가 
      FETCH emp_cursor INTO v_eid, v_ename, v_hdate;
      EXIT WHEN emp_cursor%NOTFOUND; -- FETCH를 이용해서 가져온 데이터가 새롭지 않을 때 무한루프 종료조건
   
      -- 3.5 데이터를 기반으로 연산
      DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT || ' : '); -- FETCH를 실행해서 가져온 행 수 
      DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_hdate);
   END LOOP;
   -- ERROR 1 : 커서가 실행된 상태에서 다시 실행 -> ORA-06511: PL/SQL: cursor already open
   -- OPEN emp_cursor;
   IF NOT emp_cursor%ISOPEN THEN -- 커서 실행 여부 확인
      OPEN emp_cursor;
   END IF;
   
   -- 4. 커서 종료
   -- close작업을 하지 않으면 계속 마지막행 데이터를 보고있을꺼임 즉, 커서는 종료되기 전까지 계속 실행중
   CLOSE emp_cursor;
   -- ERROR 2 : 커서가 종료된 상태에서 속성 사용 -> ORA-01001: invalid cursor
   -- DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT);
END;
/

-- 주의사항 : 명시적 커서는 결과가 없는 경우 에러가 발생하지 않음.
-- 특정 부서에 속한 사원의 사원번호와 이름, 업무를 출력
-- 명시적 커서 -> SQL의 SELEC문을 요구
SELECT employee_id, last_name, job_id
FROM   employees
WHERE  department_id = &부서번호;
-- 부서번호 : 0  => 데이터 없음
-- 부서번호 : 10 => 데이터 한건
-- 부서번호 : 50 => 데이터 여러건

DECLARE
   SELECT employee_id, last_name, job_id
   FROM   employees
   WHERE  department_id := &부서번호;
   
   v_eid   employees.employee_id%TYPE;
   v_ename employees.last_name%TYPE;
   v_job   employees.job_id%TYPE;
BEGIN
   -- 2. 커서 실행
   OPEN emp_of_dept_cursor;
   
   LOOP
      -- 3. 데이터 인출
      FETCH emp_of_dept_cursor INTO v_eid, v_ename, v_job;
      EXIT WHEN emp_of_dept_cursor%NOTFOUND;
      
      -- 4. 데이터 인출 성공 시 연산
      DBMS_OUTPUT.PUT_LINE(v_eid || ', ' || v_ename || ', ' || v_job);
   END LOOP;
   
   -- 5. 커서 종료
   CLOSE emp_of_dept_cursor;
END;
/

DECLARE
    -- 1. 커서 정의
    -- 데이터가 없어도 오류나지않음
    CURSOR emp_of_dept_cursor IS
    SELECT employee_id, last_name, job_id
    FROM   employees
    WHERE  department_id = &부서번호;

    -- INTO절에 사용할 변수가 필요 => 커서의 SELECT절 컬럼 구성만큼
    v_eid   employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_job   employees.job_id%TYPE;

    v_count NUMBER;
BEGIN
    -- 2. 커서 실행
    OPEN emp_of_dept_cursor;

    LOOP
       -- 3. 데이터 인출
       FETCH emp_of_dept_cursor INTO v_eid , v_ename , v_job;
       v_count := emp_of_dept_cursor%ROWCOUNT;
       EXIT WHEN emp_of_dept_cursor%NOTFOUND;
       
       -- 4. 데이터 인출 성공 시 연산
       DBMS_OUTPUT.PUT(emp_of_dept_cursor%ROWCOUNT || ' : '); -- LOOPT문 내부 유동값, 현재 반환된 데이터 갯수
       DBMS_OUTPUT.PUT_LINE(v_eid ||  ', ' ||  v_ename ||  ', ' || v_job);
    END LOOP ;
    
    -- LOOP문 바깥 고정값, 커서의 총 데이터 갯수
    
    DBMS_OUTPUT.PUT_LINE(emp_of_dept_cursor%ROWCOUNT);
    IF emp_of_dept_cursor%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('해당 부서는 소속사원이 없습니다.');
    END IF;
    
    -- 5. 커서 종료
    CLOSE emp_of_dept_cursor;
END;
/

-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

-- ==========================================================================================
-- 커서 FOR LOOP : 명시적 커서를 사용하는 단축방법
-- 1) 문법
DECLARE
   CURSOR 커서명 IS
      SELECT문;
BEGIN
   FOR 임시변수(레코드타입) IN 커서명 LOOP -- 암시적으로 OPEN과 FETCH
       -- 커서에 데이터가 존재하는 경우 수행하는 코드
   END LOOP; -- 암시적으로 CLOSE
END;
/

-- 2) 적용
DECLARE
   CURSOR emp_cursor IS
      SELECT employee_id, last_name, salary
      FROM   employees;
BEGIN
   FOR emp_rec IN emp_cursor LOOP
      DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ' ');
      DBMS_OUTPUT.PUT(emp_rec.employee_id);
      DBMS_OUTPUT.PUT(', ' || emp_rec.last_name);
      DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.salary);
   END LOOP;
END;
/

-- 부서번호를 입력받아 해당 부서에 소속된 사원정보(사원번호, 이름, 급여)를 출력하세요.
-- 부서번호 0 : 커서의 데이터가 없음
-- 부서번호 50 : 커서의 데이터가 존재함
DECLARE
   CURSOR emp_dept_cursor IS
      SELECT employee_id eid, last_name ename, salary sal
      FROM   employees
      WHERE  department_id = &부서번호;
BEGIN
   FOR emp_rec IN emp_dept_cursor LOOP
       DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ' ');
       DBMS_OUTPUT.PUT(emp_rec.eid);
       DBMS_OUTPUT.PUT(', ' || emp_rec.ename);
       DBMS_OUTPUT.PUT_LINE(', ' || emp_rec.sal);
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('총 데이터 갯수 : ' || emp_dept_cursor%ROWCOUNT); -- 커서가 종료되고 난 시점이라서 에러가 뜬다 : ORA-01001: invalid cursor
END;
/

-- 커서 FOR LOOP 문의 경우 명시적 커서의 데이터를 보장할 수 있을때만 사용