-- TABLE : 동일한 데이터 타입의 값을 여러개 가진다
--         주로, 레코드 타입과 함께 특정 테이블의 모든 데이터를 변수에 담을 때 사용
-- 1) 문법
DECLARE
   -- 1. 타입 정의
   TYPE 테이블타입명 IS TABLE OF 데이터타입
      INDEX BY BINARY_INTEGER;
   
   -- 2. 변수 선언
   변수명 테이블타입명;
BEGIN
   -- 3. 사용
   변수명(인덱스) := 초기값;
   DBMS_OUTPUT.PUT_LINE(변수명(인덱스));
END;
/

-- 2. 적용
DECLARE
   -- 1) 정의
   TYPE num_table_type IS TABLE OF NUMBER
      INDEX BY PLS_INTEGER;
   -- 2) 변수 선언
   v_num_info num_table_type;
BEGIN
   v_num_info(-5) := 1000;
   v_num_info(1111111111) := 1234;
   DBMS_OUTPUT.PUT_LINE(v_num_info(-5));
   DBMS_OUTPUT.PUT_LINE(v_num_info(1111111111));
END;
/

-- 테이블 타입의 메서드 활용
DECLARE
   -- 1) 테이블 타입 정의
   TYPE num_table_type IS TABLE OF NUMBER
      INDEX BY BINARY_INTEGER;
      
   -- 2) 변수 선언
   v_num_info num_table_type;
   v_idx NUMBER;
BEGIN
   v_num_info(-23)  := 1;
   v_num_info(-5)   := 2;
   v_num_info(11)   := 3;
   v_num_info(1121) := 4;
   
   DBMS_OUTPUT.PUT_LINE('값의 갯수 : ' || v_num_info.COUNT);
   
   FOR idx IN v_num_info.FIRST .. v_num_info.LAST LOOP
      IF v_num_info.EXISTS(idx) THEN
         DBMS_OUTPUT.PUT_LINE(idx || ' : ' || v_num_info(idx));
      END IF;
   END LOOP;
   
   -- 기본 LOOP문 : 실제 값만 검색
   v_idx := v_num_info.FIRST; -- 초기값 : 첫번째 인덱스 설정
   LOOP
      DBMS_OUTPUT.PUT_LINE(v_idx || ' : ' || v_num_info(v_idx));
      
      EXIT WHEN v_num_info.LAST <= v_idx; -- 첫번째 인덱스보다 마지막 인덱스
      v_idx := v_num_info.NEXT(v_idx);
      
   END LOOP;
END;
/

-- TABLE + RECORD
DECLARE
   -- 1) 타입 정의
   TYPE emp_table_type IS TABLE OF employees%ROWTYPE
      INDEX BY BINARY_INTEGER;
      
   -- 2) 변수를 선언
   v_emp_list emp_table_type;
   v_emp_rec employees%ROWTYPE;
BEGIN
   -- 테이블 조회
   FOR eid IN 100 .. 104 LOOP
      SELECT *
      INTO   v_emp_rec
      FROM   employees
      WHERE  employee_id = eid;
      
      v_emp_list(eid) := v_emp_rec;
   END LOOP;
   
   -- 테이블 타입의 데이터 조회
   FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
      IF v_emp_list.EXISTS(idx) THEN
         -- 해당 인덱스에 데이터가 있는 경우
         DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
         DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
         DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
      END IF;
   END LOOP;
END;
/


DECLARE
   -- 1) 타입 정의
   TYPE emp_table_type IS TABLE OF employees%ROWTYPE
      INDEX BY BINARY_INTEGER;
      
   -- 2) 변수를 선언
   v_emp_list emp_table_type;
   v_emp_rec employees%ROWTYPE;
   
   -- 추가 변수
   v_min employees.employee_id%TYPE;
   v_max v_min%TYPE;
   v_count NUMBER;
BEGIN
   -- employee_id 최소값, 최대값
   SELECT MIN(employee_id), MAX(employee_id)
   INTO   v_min, v_max
   FROM   employees;
   
   -- 테이블 조회
   FOR eid IN v_min .. v_max LOOP
      SELECT COUNT(*)
      INTO   v_count
      FROM   employees
      WHERE  employee_id = eid;
      
      -- 해당 사원번호 기준 데이터가 없는 경우 다음 조건으로
      CONTINUE WHEN v_count = 0;
   
      SELECT *
      INTO   v_emp_rec
      FROM   employees
      WHERE  employee_id = eid;
      
      v_emp_list(eid) := v_emp_rec;
   END LOOP;
   
   -- 테이블 타입의 데이터 조회
   FOR idx IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
      IF v_emp_list.EXISTS(idx) THEN
         -- 해당 인덱스에 데이터가 있는 경우
         DBMS_OUTPUT.PUT(v_emp_list(idx).employee_id);
         DBMS_OUTPUT.PUT(', ' || v_emp_list(idx).last_name);
         DBMS_OUTPUT.PUT_LINE(', ' || v_emp_list(idx).salary);
      END IF;
   END LOOP;
END;
/

-- count 그룹함수는 null 값을 체크함 반환값이 0임
SELECT COUNT(*), COUNT(commission_PCT)
FROM   employees
WHERE  employee_id = 0;
