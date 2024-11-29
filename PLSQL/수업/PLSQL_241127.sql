SET SERVEROUTPUT ON

--커서 FOR LOOP : 명시적 커서를 사용하는 단축방법
--1)문법
DECLARE
    CURSOR 커서명 IS 
        SELECT문;
BEGIN
    FOR 임시변수(레코드타입) IN 커서명 LOOP --암시적으로 OPEN 와 FETCH
        --커서에 데이터가 존재하는 경우 수행하는 코드
    END LOOP; --암시적으로 CLOSE
END;
/

--2)적용
DECLARE
    CURSOR emp_cursor IS
        SELECT employee_id , last_name , salary
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        DBMS_OUTPUT.PUT(emp_cursor%ROWCOUNT || ':');
        DBMS_OUTPUT.PUT(emp_rec.employee_id);
        DBMS_OUTPUT.PUT(','||emp_rec.last_name);
        DBMS_OUTPUT.PUT_line(','||emp_rec.salary);
    END LOOP;  
END;
/

--부서번호를 입력받아 해당부서에 소속된 사원정보(사원번호, 이름, 급여)를 출력하세요
--부서번호 0 : 커서의 데이터가 없음 (커서의 데이터가 없다 = FOR LOOP조건에 만족 하지 않아서 아에 FOR LOOP실행 안함 (루프가 실행이 안됨)
--부서번호 50 :커서의 데이터가 존재함 

DECLARE
    CURSOR emp_dept_cursor IS
        SELECT employee_id eid, last_name ename, salary sal
        FROM employees
        WHERE department_id = &부서번호;
BEGIN
    FOR emp_rec IN emp_dept_cursor LOOP
        DBMS_OUTPUT.PUT(emp_dept_cursor%ROWCOUNT || ':');
        DBMS_OUTPUT.PUT(emp_rec.eid);
        DBMS_OUTPUT.PUT(','||emp_rec.ename);
        DBMS_OUTPUT.PUT_LINE(','||emp_rec.sal);
    END LOOP; -- 암시적으로 CLOSE
    
    --DBMS_OUTPUT.PUT_LINE('총 데이터 갯수: '|| emp_dept_cursor%ROWCOUNT); 
    --"invalid cursor" 오류 뜬다 => CURSOR FOR LOOP 경우  FOR LOOP 밖에서는 ROWCOUNT ,ROWCOUNT 실행 불가  (<-> ISOPEN만 사용가능)
END;
/

--커서 FOR LOOP문의 경우 명시적 커서의 데이터를 보장 할 수 없을때(데이터가 없을 수도 있는 경우) 사용 불가
-- == 데이터를 보장 할 수 있는 경우 만 사용 


/*
1.
사원(employees) 테이블에서
사원의 사원번호, 사원이름, 입사연도를 
다음 기준에 맞게 각각 test01, test02에 입력하시오.

입사년도가 2025년(포함) 이전 입사한 사원은 test01 테이블에 입력
입사년도가 2025년 이후 입사한 사원은 test02 테이블에 입력
*/
DECLARE 
    CURSOR emp_cursor IS 
        SELECT employee_id eid , last_name ename, hire_date hdate
        FROM employees;
BEGIN
    FOR emp_rec IN emp_cursor LOOP
        IF TO_CHAR(emp_rec.hdate,'yyyy') >= '2025'
        THEN INSERT INTO test01 (empid,ename,hiredate)
            VALUES (emp_rec.eid , emp_rec.ename , emp_rec.hdate);
        ELSE INSERT INTO test02
            VALUES emp_rec; -- test01와 emp_cursor 의 컬럼(필드)의 구성이 동일하기 때문에 가능하다. 
        END IF;
    END LOOP;
END;
/
select *
from test02;

/*
2.
부서번호를 입력할 경우(&치환변수 사용)
해당하는 부서의 사원이름, 입사일자, 부서명을 출력하시오.
*/
DECLARE
    CURSOR emp_det_cursor IS 
        SELECT e.last_name ename, e.hire_date hdate, d.department_name dname
        FROM employees e JOIN departments d
                        ON (e.department_id = d.department_id)
        WHERE e.department_id = &부서번호;
BEGIN
    FOR dep_rec IN emp_det_cursor LOOP
        DBMS_OUTPUT.PUT(emp_det_cursor%ROWCOUNT || ':');
        DBMS_OUTPUT.PUT(dep_rec.ename);
        DBMS_OUTPUT.PUT(','||dep_rec.hdate);
        DBMS_OUTPUT.PUT_LINE(','||dep_rec.dname);  
     END LOOP;
END;
/

--서브쿼리 활용  (커서 for loop는 서브쿼리 활용해서 동작 가능 단, rowcount, notfound같은 속성 접근이 불가함으로 데이터 테스트 용으로 사용)
BEGIN
    FOR dep_rec IN (
                    SELECT e.last_name ename, e.hire_date hdate, d.department_name dname
                    FROM employees e JOIN departments d
                                    ON (e.department_id = d.department_id)
                    WHERE e.department_id = &부서번호  ) LOOP
        DBMS_OUTPUT.PUT_LINE(dep_rec.ename||','||dep_rec.hdate||','||dep_rec.dname)  
     END LOOP;
END;
/


/*
3.
부서번호를 입력(&사용)할 경우 
사원이름, 급여, 연봉->(급여*12+(급여*nvl(커미션퍼센트,0)*12))
을 출력하는  PL/SQL을 작성하시오.
*/
--3.1 연봉을 따로 계산 (변수 따로 지정)
SELECT last_name, salary, commission_pct
FROM employees
WHERE department_id = &부서번호;

DECLARE
    CURSOR emp_in_dept_cursor is 
        SELECT last_name ename, salary sal, commission_pct
        FROM employees
        WHERE department_id = &부서번호; 
    v_year NUMBER(10,2); --연봉
    
    --ROWDATA를 커서를 통해서 가져오기 
BEGIN
    --FOR LOOP로 데이터 출력 
    FOR info IN emp_in_dept_cursor LOOP
        v_year := (info.sal*12 + (info.sal*nvl(info.commission_pct,0)*12)); --커서에서 데이터의 null이 있는 경우를 처리 하지 않았기 때문에 NVL사용 
        DBMS_OUTPUT.PUT_LINE(info.ename||','||info.sal||','||v_year);
    END LOOP;
END;
/

-- 3-2 (커서 내부에서 서브쿼리 사용)
SELECT last_name, salary, (salary*12+(salary*nvl(commission_pct,0)*12))
FROM employees
WHERE department_id = &부서번호;

DECLARE
    CURSOR emp_in_dept_cursor IS
        SELECT last_name ename, salary sal, (salary*12+(salary*nvl(commission_pct,0)*12)) as year 
        FROM employees
        WHERE department_id = &부서번호;
        
BEGIN
   FOR info IN emp_in_dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(info.ename||','||info.sal||','||info.year);
   END LOOP;
END;
/

--예외처리 : 예외가 발생했을 때 정상적으로 작업이 종료될 수 있도록 처리
--1)문법
DECLARE
BEGIN
EXCEPTION 
    WHEN 예외이름 THEN -- 필요한 만큼 추가 가능
        --예외발생시 처리하는 코드 
    WHEN OTHERS THEN --위의 정의된 예외말고 발생하는 경우 일괄처리 
    --예외발생시 처리하는 코드 
END;
/
--2)적용
--2.1) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름도 존재하는 예외사항  
-- SELECT 기반으로 처리 
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    --부서번호 0 : ORA-01403 , NO_DATA_FOUND
    --부서번호 10 :정상실행 
    --부서번호 50 : ORA-01422: exact fetch returns more than requested number of rows (= TOO_MANY_ROWS) 행보다 출력될 데이터가 더 많다.
     DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다.');
        --PL/SQL 프로시저가 성공적으로 완료되었습니다. 
        -- = 정상적으로 종료 되었으나, DBMS_OUTPUT.PUT_LINE(v_ename);이 실행되지 않음, 
        -- 즉, 예외 발생시 다시 원래 흐름으로 올라갈수는 없고 정상 종료 하게 해준다.
        
    WHEN OTHERS THEN  
         DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생하였습니다.');
         -- 해당 경우는 WHEN OTHERS THEN  의 경우에만 출력된다. WHEN NO_DATA_FOUND THEN  의 경우에는 해당 코드 거치지 않고 바로 END로 간다.
         DBMS_OUTPUT.PUT_LINE('블럭이 종료 되었습니다.');
END;
/
--2.2) 이미 오라클에 정의되어 있고(에러코드가 있음) 이름도 존재하지 않는 예외사항 
--대표적으로 DELETE, UPDATE 
DECLARE 
    -- ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found 해당 오류 이름 선언 
    e_emps_remaining EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_emps_remaining,-02292);
    -- PRAGMA 별도의 전처리 과정을 사용하는 명령어 
BEGIN 
    DELETE FROM departments
    WHERE department_id = &부서번호;
    -- 오류 1.ORA-02292: integrity constraint (HR.EMP_DEPT_FK) violated - child record found
    --              ->  삭제하고자 하는 데이터를 참조하고 있는 데이터 존재 (자식데이터 존재)
EXCEPTION 
    WHEN e_emps_remaining THEN 
        DBMS_OUTPUT.PUT_LINE('해당부서는 다른 데이블에서 사용 중 입니다. ');
END;
/


--2.3) 사용자 정의 예외 => 오라클 입장에서는 정상코드로 인지 (예외로 강제성을 주는 것)
-- 
DECLARE 
    e_dept_del_fail EXCEPTION;
BEGIN 
    DELETE FROM departments
    WHERE department_id = &부서번호;
    --부서번호 0 인 경우 : 실행시 에러 발생 하지 않으나 '0개 행 이(가) 삭제되었습니다.'으로 뜬다. (정상적으로 수행되지만, 기능상으로 실패로 인지해야 하는 경우)
    
    IF SQL%ROWCOUNT = 0 THEN  -- 데이터 갯수 확인 
        DBMS_OUTPUT.PUT_LINE('해당부서는 존재하지 않습니다. ');
        DBMS_OUTPUT.PUT_LINE('부서번호를 확인해 주세요');
    END IF;

     
END;
/
--예외트랩함수
DECLARE
    v_ename employees.last_name%TYPE;
BEGIN
    SELECT last_name
    INTO v_ename
    FROM employees
    WHERE department_id = &부서번호;
    
    --부서번호 0 : ORA-01403 , NO_DATA_FOUND
    --부서번호 10 :정상실행 
    --부서번호 50 : ORA-01422: exact fetch returns more than requested number of rows (= TOO_MANY_ROWS) 행보다 출력될 데이터가 더 많다.
     DBMS_OUTPUT.PUT_LINE(v_ename);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('해당 부서에 속한 사원이 없습니다.');
        
        
    WHEN OTHERS THEN  
         DBMS_OUTPUT.PUT_LINE('기타 예외사항이 발생하였습니다.');
         
         --에러코드를 보여준다.
         DBMS_OUTPUT.PUT_LINE('ORA'|| SQLCODE); --에러코드 
         DBMS_OUTPUT.PUT_LINE(SUBSTR(SQLERRM,12)); --에러메세지
         
         DBMS_OUTPUT.PUT_LINE('블럭이 종료 되었습니다.');
         
END;
/

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
drop table emp_test;

create table emp_test
as
  select employee_id, last_name
  from   employees
  where  employee_id < 200;
-- 사용자정의 예외사항 사용 
DECLARE 
    e_emp_fail EXCEPTION; -- 사용자정의 예외 이름 선언 
    
BEGIN 
    DELETE FROM emp_test
    WHERE employee_id = &사원번호;
    -- 사용자 정의 오류 ==> 0개 행 이(가) 삭제되었습니다. 
    -- 값이 '' 리터럴 값으로 인식 | 그냥 넣으면 변수로 인식 
    
    --&사원번호 :치환변수 는 가장 먼저 실행 된다. 이때 치환변수에는 리터럴 값으로 
    
    IF SQL%ROWCOUNT = 0 THEN  --데이터 갯수 0인 경우 
        RAISE e_emp_fail; -- 강제로 예외 발생 
    END IF;
    
--    IF SQL%ROWCOUNT = 0 THEN
--    DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
--    END IF;
    
EXCEPTION 
    WHEN e_emp_fail THEN -- 예외 발생 시 처리 액션 
    DBMS_OUTPUT.PUT_LINE('해당사원이 없습니다.');
END;
/

--PROCEDURE 
--PROCEDURE 등록 
--1)문법 
CREATE PROCEDURE 프로시저명 
(매개변수명 [모드] 데이터타입, ... ) -- 필요한 만큼 추가 가능

IS 

    -- 선언부(IS와 BEGIN 사이) : 로컬 변수, 커서, 예외사항 등을 선언 
    --단, DECLARE라는 선언은 빠진다. WHY? 충돌이 발생하기 때문에 숨겨준다.

BEGIN 
    --PROCEDURE가 수행 할 코드 
    
EXCEPTION
    --에러 처리 
END;
/

--2) 적용 
--ORA-00955: name is already used by an existing object ->  동일한 이름의 객체는 재등록 불가 
DROP PROCEDURE test_pro; -- 프로시저 삭제 

CREATE PROCEDURE test_pro
(p_msg VARCHAR2)  -- 암시적으로 IN으로 선언  , 매개변수는 크기 지정 불가(넘어오는 값에 대해 크기 지정 불가)
IS
    v_msg VARCHAR2(1000) := 'Hello!';
BEGIN
    DBMS_OUTPUT.PUT_LINE(v_msg || p_msg);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('데이터가 존재하지 않습니다.');
END;
/

--PROCEDURE 호출 
--3) 실행 
DECLARE 
    --v_result VARCHAR2(1000);
BEGIN 
    --오라클이 현재 실행하는  객체가 PROCEDURE 인지 FUNCTION인지 구분 하는 방법 
    -- -> 호출 형태 (왼쪽에 변수가 존재하는가 = 함수 ; v_result := ) 
    --v_result := test_pro('PL/SQL');  -- 함수의 결과값을 변수에 담기 
    --오류 PLS-00222: no function with name 'TEST_PRO' exists in this scope ==>  함수로 인식 
    
    test_pro('PL/SQL'); -- 매개변수로 받아야 하기 때문에 변수에 넣으면 안된다.
END;
/
-- 중간에 실행 가능 하게 해주는 것 
EXECUTE test_pro('WORLD');

--IN모드 : 호출환경 -> 프로시저로 값을 전달, 프로시저 내부에서 상수 취급
DROP PROCEDURE raise_salary;

CREATE PROCEDURE raise_salary
(p_eid IN employees.employee_id%TYPE) -- 매개변수 생성 
IS
BEGIN
    -- PLS-00363: expression 'P_EID' cannot be used as an assignment target (PLS = 문법오류)
    -- ERROR :  MOD = IN 경우 프로시저 내부에서 상수 취급됨으로 값을 변경 불가 하다.
    -- p_eid :=100; 
    
    UPDATE employees
    SET salary = salary*1.1  -- 급여 10퍼 인상 
    WHERE employee_id = p_eid;
    
END;
/

SELECT employee_id , salary
FROM employees
WHERE employee_id IN (100,130,149);

--PROCEDURE호출
DECLARE 
    v_first NUMBER(3,0) := 100; --초기화된 변수
    v_second CONSTANT NUMBER(3,0) := 149; --상수
BEGIN
-- IN 에서는 리터럴값, 상수 값을 넘길 수 있다 
    raise_salary(100); --리터럴
    raise_salary(v_first+30); --표현식
    raise_salary(v_first); -- 초기화된 변수 
    raise_salary(v_second); -- 상수 
END;
/

ROLLBACK;

-- OUT 모드 : 프로시저 => 호출환경으로 값을 반환, 프로시저 내부에서 초기화되지 않는 변수로 인지 
--1) 적용
CREATE PROCEDURE test_p_out
(p_num IN NUMBER,
p_out OUT NUMBER) -- MOD : OUT 지정 
IS 
BEGIN
    DBMS_OUTPUT.PUT_LINE('IN'||p_num);
    DBMS_OUTPUT.PUT_LINE('OUT'||p_out);
    
END; --블록이 종료되는 순간 out모드의 매개변수가 가지고 있는 값이 그대로 반환 [out모드가  null 값이면 null 값 전달]
/

-- 2) 실행 코드 
DECLARE
-- OUT MODE는 반드시 변수가 필요하다 (돌려받을때 공간 필요)
    v_result NUMBER(4,0) := 1234;
BEGIN 
    DBMS_OUTPUT.PUT_LINE('1) result : ' ||v_result); -- v_result : 1234
    test_p_out(1000,v_result); -- 프로시저 내부에서 out값을 null 로 인식 
    DBMS_OUTPUT.PUT_LINE('2) result : ' ||v_result);
END;
/

--더하기 
--1)적용
DROP PROCEDURE pro_plus;
CREATE PROCEDURE pro_plus
--매개변수 설정 
(p_x IN NUMBER,
p_y IN NUMBER,
p_sum OUT NUMBER -- OUT 모드의 최종 값 = RETURN 과 동일한 형태 (함수에서 매개변수 받고 return  값 나오는것과 동일)
)
IS 
BEGIN 
    p_sum := p_x + p_y;
END;
/

--2)실행 
DECLARE 
-- mode : out 의 경우 변수 생성 필요 
    v_total NUMBER(10,0);
BEGIN
    pro_plus(10,25,v_total);
    DBMS_OUTPUT.PUT_LINE(v_total);
END;
/

--IN OUT 모드 : IN 모드와 OUT모드 두가지를 하나의 변수로 처리 
-- 기존의 IN 과 OUT은 따로따로 동작을 하는데 IN OUT의 경우 OUT 모드 기반으로 프로시저를 호출 하면 기존의 값이 IN 값을 덮어 씌여진다

--'0101234123' => '010-1234-1234'
-- 날짜를 지정한 포맷으로 변경  : 오라클의 경우 '24/11/27' 인데  => '24년11월27일' 로 변경 하는 경우 

CREATE PROCEDURE format_phone
(p_phone_no IN OUT VARCHAR2) -- 변수 하나 등록
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('before : ' || p_phone_no); -- 변경전 값
    p_phone_no := SUBSTR(p_phone_no,1,3) --  SUBSTR(대상,자르는 처음 위치, 자를 갯수) : 문자열을 자르는 함수 
                || '-' || SUBSTR(p_phone_no,4,4)
                || '-' || SUBSTR(p_phone_no,8); -- 8번째 부터 나머지 다 
    DBMS_OUTPUT.PUT_LINE('after : ' ||  p_phone_no);
END;
/

--실행
DECLARE 
    v_no VARCHAR2(100) := '01012341234';
BEGIN
    format_phone(v_no); -- IN 값 
     DBMS_OUTPUT.PUT_LINE(v_no); -- OUT 값
     -- 프로시저를 거치면서 원래 데이터('01012341234') 가 사라지고 변경 값이 덮어 씌여 졌다. 
     --'0101234123' 전 => '010-1234-1234'후 둘다 같이 나타낼수 없다. 
END;
/
--PROCEDURE 문제 
--매개변수 MODE = IN 
/*
1.
주민등록번호를 입력하면 
다음과 같이 출력되도록 yedam_ju 프로시저를 작성하시오.

EXECUTE yedam_ju('9501011667777');
950101-1******
EXECUTE yedam_ju('1511013689977');
151101-3******
*/
--프로시저 등록


--실행 
/*
2.
사원번호를 입력할 경우
삭제하는 TEST_PRO 프로시저를 생성하시오.
단, 해당사원이 없는 경우 "해당사원이 없습니다." 출력
예) EXECUTE TEST_PRO(176)
*/

/*
3.
다음과 같이 PL/SQL 블록을 실행할 경우 
사원번호를 입력할 경우 사원의 이름(last_name)의 첫번째 글자를 제외하고는
'*'가 출력되도록 yedam_emp 프로시저를 생성하시오.

실행) EXECUTE yedam_emp(176)
실행결과) TAYLOR -> T*****  <- 이름 크기만큼 별표(*) 출력
*/

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