-- DBMS_OUTPIT, PUT_LINE 프로시저를 실행하기 위한 설정 변경
SET SERVEROUTPUT ON;

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
END;
/

--DBMS_OUTPUT.PUT_LINE 프로시저를 실행하기 한 설정 변경 
SET SERVEROUTPUT ON

--조합 데이터 유형 :여러 값을 가질 수 있는 데이터 타입
--RECORD  : 내부에 필드를 가지는 데이터 구조, SELECT문처럼 데이터를 조회하는 경우가 많이 쓰임
--1) 문법 
DECLARE
    --1. 레코드 타입 정의 ( 데이터 타입을 만들어 줘야 한다.)
    TYPE 레코드타입명 IS RECORD
        (필드명 데이터타입, 
        필드명 데이터타입 := 초기값, 
        필드명 데이터타입 NOT NULL :=초기값 <--할당 연산자를 사용한 초기값 
        );

    --2. 변수 선언 
    변수명 레코드타입명;
BEGIN
    --3. 사용 
    -- 테이블에서 데이터를 인출 할 때 사용
    변수명.필드명 := 변경값;
    DBMS_OUTPUT.PUT_LINE(변수명.필드명); --레코드타입 통 채로 출력 불가 
END;
/

--2.적용 
DECLARE 
    --1)타입 정의 
    TYPE emp_record_type IS RECORD -- 이름을 지을때 record_type을 뒤에 붙여서 지어준다(why ?변수명과 레코드 타입을 구별하기 위해서)
        (empno NUMBER(6,0),
         ename employees.last_name%TYPE NOT NULL := 'Hong', -- 초기값과 반드시 같이 사용해야함 (NOT NULL이라서)
         sal   employees.salary%TYPE := 0);
    --2)변수 선언
    v_emp_info emp_record_type; -- emp_record_type -> 얘 자체가 데이터 타입
    v_emp_rec  emp_record_type;

BEGIN
    DBMS_OUTPUT.PUT(v_emp_info.empno); -- 변수명.필드명
    DBMS_OUTPUT.PUT(',' ||  v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(',' || v_emp_info.sal);

    v_emp_rec.empno := &사원번호;

    -- 하나의 변수에 여러가지 데이터 타입이 존재함
    -- 하나의 논리단위로 묶여진다
    -- 테이블이 가지고 있는 행과 같은 의미?
    SELECT employee_id, last_name, salary
    INTO   v_emp_info -- v_emp_info -> 얘 안에 변수들이 선언되어 있어서 가능 ~
    FROM   employees
    WHERE  employee_id = v_emp_rec.empno;

    DBMS_OUTPUT.PUT(v_emp_info.empno);
    DBMS_OUTPUT.PUT(',' ||  v_emp_info.ename);
    DBMS_OUTPUT.PUT_LINE(',' ||  v_emp_info.sal);

END;
/

-- %ROWTYPE : 테이블 혹은 뷰의 한행을 RECORD TYPE으로 반환 => 타입 정의 없이 변수 선언으로 바로 사용
DECLARE
   v_emp_rec employees%ROWTYPE; -- employees 테이블 타입으로 v_emp_rec로 이름을 할꺼다
BEGIN
   SELECT * -- employees이 타입을 가져오기 위해서 전체조회를 해와야한다. 왜냐? 어떤 필드를 가지고 있는지 정확하게 모르기때문이지~~
   INTO v_emp_rec
   FROM employees
   WHERE employee_id = &사원번호;
   
   DBMS_OUTPUT.PUT_LINE(v_emp_rec.employee_id);
   DBMS_OUTPUT.PUT_LINE(v_emp_rec.last_name);
   DBMS_OUTPUT.PUT_LINE(v_emp_rec.salary);
END;
/