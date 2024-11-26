-- 조합 데이터 유형 : 여러 값을 가질 수 있는 데이터 타입
-- RECORD : 내부에 필드를 가지는 데이터 구조, SELECT문 처럼 데이터를 조회하는 경우 많이 쓰임.
-- 1) 문법
DECLARE
   -- 1. 레코드 타입 정의
   TYPE 레코드타입명 IS RECORD
         (필드명 데이터타입,
          필드명 데이터타입 := 초기값,
          필드명 데이터타입 NOT NULL := 초기값);
   -- 2. 변수 선언
   -- 변수명 레코드타입명;
BEGIN
   -- 3. 사용
   변수명.필드명 := 변경값;
   -- 내부에 필드를 선택해서 출력해야함
   -- 레코드 타입 통채로 출력은 불가 에러뜸
   -- 데이터 타입은 어떤것도 상관없음 단, CONSTANT는 안되유 ~~
   DBMS_OUTPUT.PUT_LINE(변수명.필드명);
END;
/

-- 2. 적용
DECLARE
   -- 1. 레코드 타입 정의
   TYPE emp_record_type IS RECORD
         (empno NUMBER(6,0),
          ename employees.last_name%TYPE NOT NULL := 'Hong',
          sal   employees.salary%TYPE := 0);
          
   -- 2) 변수선언
   v_emp_info emp_record_type;
   v_emp_rec  emp_record_type;
BEGIN
   -- 3. 사용
   DBMS_OUTPUT.PUT(v_emp_info.empno);
   DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
   DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
   
   v_emp_rec.empno := &사원번호;
   
   SELECT employee_id, last_name, salary
   INTO   v_emp_info
   FROM   employees
   WHERE  employee_id = v_emp_rec.empno;
   
   DBMS_OUTPUT.PUT(v_emp_info.empno);
   DBMS_OUTPUT.PUT(', ' || v_emp_info.ename);
   DBMS_OUTPUT.PUT_LINE(', ' || v_emp_info.sal);
END;
/