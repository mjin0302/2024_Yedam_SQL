-- DBMS_OUTPUT.PUT_LINE ���ν����� �����ϱ� ���� ���� ����
SET SERVEROUTPUT ON 

-- �Ͻ��� Ŀ�� : SQL���� ���� ����� ���� �޸� ����
-- => �� ���� : DML�� ������ Ȯ��, SQL%ROWCOUNT
-- => ���ǻ��� : ������ ����� SQL���� ����� Ȯ�� ����

BEGIN
    DELETE FROM employees
    WHERE employee_id = 0;
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '���� �����Ǿ����ϴ�.');
END;
/


-- ���ǹ�
-- 1) �⺻ IF�� : Ư�� ������ TRUE �� ��츸
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�.');
    END IF;
END;
/

SELECT employee_id
FROM employees
WHERE employee_id NOT IN ( SELECT manager_id
                           FROM employees
                           WHERE manager_id IS NOT NULL
                           UNION
                           SELECT manager_id
                           FROM departments
                           WHERE manager_id IS NOT NULL);

-- 2) IF ~ ELSE �� : Ư�� ������ �������� TRUE/FALSE ��� Ȯ��
BEGIN
    DELETE FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF SQL%ROWCOUNT >= 1 THEN
        -- ���ǽ��� TRUE�� ���
        DBMS_OUTPUT.PUT_LINE('���������� �����Ǿ����ϴ�.');
    ELSE
        -- ���� ������ ��� ���ǽ��� FALSE�� ���
        DBMS_OUTPUT.PUT_LINE('�������� �ʾҽ��ϴ�.');
        DBMS_OUTPUT.PUT_LINE('�����ȣ�� Ȯ�����ּ���.');
    END IF;

END;
/
-- 3) IF ~ ELSIF ~ ELSE �� : ���� ������ ������� �� ����� ���� ó��
DECLARE
    v_score NUMBER(2,0) := &����;
    v_grade CHAR(1);
BEGIN
    -- v_score�� ������ �ִ밪�� �ּҰ� : �ּҰ� < v_score < �ִ밪
    IF v_score >= 90 THEN -- 90 <= v_score < 100
        v_grade := 'A';
    ELSIF v_score >= 80 THEN -- 80 <= v_score < 90
        V_grade := 'B';
    ELSIF v_score >= 70 THEN -- 70 <= v_score < 80
        V_grade := 'C';
    ELSIF v_score >= 60 THEN -- 60 <= v_score < 70
        V_grade := 'D';
    ELSE  -- ==> �⺻������ ��ü ����  -- v_score  < 60
        v_grade := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(v_grade);
END;
/

-- �����ȣ�� �Է¹޾� �ش� ����� ����(JOB_ID)�� ������ ���('SA'�� ���Ե� ���)�� Ȯ�����ּ���.
-- ��¹��� : �ش� ����� �������� �����о� �Դϴ�.

/*
1. �����ȣ�� �Է¹޾�
2. �ش����� ������ ������ ��� Ȯ�� => ���ǹ�
2-1) �Է� : �����ȣ -> �ʿ� : ���� , SELECT��
SELECT ����
FROM employees
WHERE �����ȣ = �Է¹��� �����ȣ;
2-2)
IF ������ ������ ��� => UPPER(����) LIKE '%SA%' THEN
    ��� : '�ش� ����� �������� �����о� �Դϴ�.'
END IF;

*/

-- SELECT��
SELECT job_id
FROM employees
WHERE employee_id = &�����ȣ;


DECLARE
    v_job employees.job_id%TYPE;
BEGIN
    SELECT job_id
    INTO v_job
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF UPPER(v_job) LIKE '%SA%' THEN
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� �����о� �Դϴ�.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('�ش� ����� �������� ' || v_job || ' �Դϴ�.');
    END IF;
END;
/

SELECT employee_id, job_id
FROM employees
WHERE job_id LIKE 'SA_%';

/*
3.
�����ȣ�� �Է�(ġȯ�������&)�� ���
�Ի����� 2025�� ����(2025�� ����)�̸� 'New employee' ���
      2025�� �����̸� 'Career employee' ���
��, DBMS_OUTPUT.PUT_LINE ~ �� �ѹ��� ���
*/

/*
1. �����ȣ�� �Է¹޾�
2. �����ȣ -> �Ի��� ��ȸ, SELECT��
3. �Ի����� 2025�� ����(2025�� ����) -> 'New employee'
           2025�� ����             -> 'Career employee'
*/

-- SELECT��
SELECT hire_date
FROM employees
WHERE employee_id = &�����ȣ;

-- ���ǹ�
IF �Ի��� >= 2025�� THEN
    ��� : 'New employee';
ELSE
    ��� : 'Career employee';
END If;

-- PL/SQL
DECLARE
    v_hdate employees.hire_date%TYPE;
    v_msg VARCHAR2(100);
BEGIN
    -- 1)
    SELECT hire_date
    INTO v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- 2)
    -- IF v_hdate >= TO_DATE('2025-01-01', 'yyyy-MM-dd') THEN
    IF TO_CHAR(v_hdate, 'yyyy') >= '2025' THEN
       v_msg := 'New employee';
    ELSE
       v_msg := 'Career employee';
    END If;
    
    DBMS_OUTPUT.PUT_LINE(v_msg);
END;
/

/*
4.
create table test01(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

create table test02(empid, ename, hiredate)
as
  select employee_id, last_name, hire_date
  from   employees
  where  employee_id = 0;

�����ȣ�� �Է�(ġȯ�������&)�� ���
����� �� 2025�� ����(2025�� ����)�� �Ի��� ����� �����ȣ, 
����̸�, �Ի����� test01 ���̺� �Է��ϰ�, 2025�� ������ 
�Ի��� ����� �����ȣ,����̸�,�Ի����� test02 ���̺� �Է��Ͻÿ�.
*/

/*
1. �����ȣ�� �Է¹޾�
2. �����ȣ -> �����ȣ, ����̸�, �Ի��� ��ȸ, SELECT��
3. �Ի����� 2025�� ����(2025�� ����) -> ����� �����ȣ, ����̸�, �Ի����� test01 ���̺� �Է�
           2025�� ����             -> ����� �����ȣ, ����̸�, �Ի����� test02 ���̺� �Է�
*/

-- SELECT��
SELECT employee_id, last_name, hire_date
FROM employees
WHERE employee_id = &�����ȣ;

-- ���ǹ�
IF �Ի��� >= 2025�� THEN
    INSERT INTO test01 (empid, ename, hiredate)
    VALUES ();
ELSE 
    INSERT INTO test02 (empid, ename, hiredate)
    VALUES ();
END IF;

-- PL/SQL
DECLARE
    v_eid employees.employee_id%TYPE;
    v_ename employees.last_name%TYPE;
    v_hdate employees.hire_date%TYPE;
BEGIN
    SELECT employee_id, last_name, hire_date
    INTO v_eid, v_ename, v_hdate
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    IF v_hdate >= TO_DATE('20250101', 'yyyyMMdd') THEN
        INSERT INTO test01 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    ELSE 
        INSERT INTO test02 (empid, ename, hiredate)
        VALUES (v_eid, v_ename, v_hdate);
    END IF;
END;
/
SELECT *
FROM test02;

/*
5.
�޿���  5000�����̸� 20% �λ�� �޿�
�޿��� 10000�����̸� 15% �λ�� �޿�
�޿��� 15000�����̸� 10% �λ�� �޿�
�޿��� 15001�̻��̸� �޿� �λ����

�����ȣ�� �Է�(ġȯ����)�ϸ� ����̸�, �޿�, �λ�� �޿��� ��µǵ��� PL/SQL ����� �����Ͻÿ�.
*/

/*
1. �����ȣ �Է� -> ����̸�, �޿�, �λ�� �޿��� ���
-1) SELECT�� : �����ȣ -> ����̸�, �޿�
-2) �λ�� �޿�?
    �޿���  5000�����̸� 20% �λ�� �޿�
    �޿��� 10000�����̸� 15% �λ�� �޿�
    �޿��� 15000�����̸� 10% �λ�� �޿�
    �޿��� 15001�̻��̸� �޿� �λ����
*/

DECLARE
    v_ename employees.last_name%TYPE;
    v_sal empeloyees.salary%TYPE;
    v_new_sal v_sal%TYPE;
    v_raise NUMBER(5,2);
BEGIN
    -- 1) SELECT��
    SELECT last_name, salary
    INTO v_ename, v_sal
    FROM employees
    WHERE employee_id = &�����ȣ;
    
    -- 2) ���ǹ�
    IF v_sal <= 5000 THEN
        v_raise := 20;
    ELSIF v_sal <= 10000 THEN
         v_raise := 15;
    ELSIF v_sal <= 15000 THEN
         v_raise := 10;
    ELSE -- �޿��� 15001�̻�
         v_raise := 0;
    END IF;
    
    v_new_sal := v_sal + v_sal * (v_raise/100);
    
    DBMS_OUTPUT.PUT_LINE(v_ename || ', ' || v_sal || ', ' || v_new_sal);
END;
/

-- LOOP��
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello!!!');
    END LOOP;
END;
/

-- �⺻ LOOP�� : ���Ǿ��� ���� LOOP���� �ǹ� => �ݵ�� EXIT���� �����϶�� ����
-- 1) ����
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        EXIT WHEN -- ���������� �ǹ�
    END LOOP;
END;
/
-- 2) ����
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        EXIT;
    END LOOP;
END;
/

DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ��ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;
END;
/

-- 1 ���� 10���� ������ ���� ���ϱ�
/*
1) 1���� 10���� ����
2) �� �������� ����
*/

-- 1) �������� ���ϱ�
-- 2) �������� ���� : ������ ���ϱ�
DECLARE
    v_num NUMBER(2,0) := 1; -- ���� : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- ����
BEGIN
    LOOP
    
        DBMS_OUTPUT.PUT_LINE(v_num); -- ���⼭ ������ ����
        v_sum := v_sum + v_num;      -- �� ������ ���տ� ��� ���ϱ�
        
        v_num := v_num + 1;
        EXIT WHEN v_num > 10;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_sum);
END;
/

/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    

*/
/*
 �ݺ��ϰ��� �ϴ� �ڵ� : * ���ϱ� *   , �̰� �� 5�� �ݺ�
*/
DECLARE
    v_count NUMBER(1,0) := 0;  -- �ݺ� Ƚ��
    v_tree VARCHAR2(6)  := ''; -- '*' ����
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        -- �ݺ��� �����ϰ��� �ϴ� �ڵ�
        v_count := v_count + 1;
        EXIT WHEN v_count >= 5;
    END LOOP;  

END;
/
DECLARE
    v_tree VARCHAR2(6)  := ''; -- '*' ����
BEGIN
    LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
        
        -- �ݺ��� �����ϰ��� �ϴ� �ڵ�
        EXIT WHEN LENGTH(v_tree) >= 5;
    END LOOP;  
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/

-- �ݺ��ϰ��� �ϴ� �ڵ� : ���ϴ� ���� ���� ( ����, 1 ~ 9 ) => �ݺ���
DECLARE
    v_dan CONSTANT NUMBER(2, 0) := &��;
    v_num NUMBER(2,0) := 1;     -- ���ϴ� �� : ����, 1 ~ 9
BEGIN
    LOOP
        -- v_num ���;
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
    
        v_num := v_num + 1;
        EXIT WHEN v_num > 9;
    END LOOP;
END;
/



/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�. => ���� �ݺ���
-- 1) 2 ~ 9 ��, ���� �����ؾ� ��. => ù��° LOOP��
-- 2) �ش� ���� ���ϴ� ���� 1 ~ 9 ���� ������ ���� ��� => �ι�° LOOP��
*/

DECLARE
    v_dan NUMBER(2,0) := 2; -- �� : ( ����, 2 ~ 9)
    v_num NUMBER(2,0) := 1;     -- ���ϴ� �� : ����, 1 ~ 9
BEGIN
    LOOP
        -- v_dan�� ���
        v_num := 1; -- ���� LOOP���� ���� �ʱ�ȭ �ʿ�
        LOOP
            -- v_num ���;
            DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
    
            v_num := v_num + 1;
            EXIT WHEN v_num > 9;
        END LOOP; -- 2���� ���� ���� v_num = 10;
        
        v_dan := v_dan + 1;
        EXIT WHEN v_dan > 9;
    END LOOP;
END;
/

-- WHILE LOOP�� : Ư�������� �����ϴ� ���� �ݺ��ϴ� LOOP���� �ǹ� => ��쿡 ���� ������ �ȵǴ� ��쵵 ����.
-- 1) ����
BEGIN
    WHILE �ݺ����� LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
END;
/

-- 2) ����
DECLARE
    v_count NUMBER(1,0) := 0;
BEGIN
    WHILE v_count < 5 LOOP -- ��Ȯ�� �ݺ����� ǥ��
        -- �ݺ��ϰ��� �ϴ� �ڵ�
        DBMS_OUTPUT.PUT_LINE('Hello !!!');
        
        -- LOOP���� �����ϴ� �ڵ�
        v_count := v_count + 1;
    END LOOP;
END;
/

-- 1 ���� 10���� ������ ���� ���ϱ�
/*
1) 1���� 10���� ����
2) �� �������� ����
*/

-- 1) 1���� 10���� ����
DECLARE
    v_num NUMBER(2,0) := 1; -- ���� : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- ����
BEGIN
    WHILE v_num <= 10 LOOP
        -- v_num ��� => ���� ���ϱ�
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_sum);
END;
/

-- �⺻ LOOP������ ��ȯ
DECLARE
    v_num NUMBER(2,0) := 1; -- ���� : 1 ~ 10
    v_sum NUMBER(2,0) := 0; -- ����
BEGIN
    -- WHILE v_num <= 10 LOOP
    LOOP
        v_sum := v_sum + v_num;
        
        v_num := v_num + 1;
        -- WHILE v_num <= 10
        EXIT WHEN v_num > 10; 
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_sum);
END;
/

/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
*         
**        
***       
****     
*****    

*/

declare
    --���� ����
    v_tree varchar2(10) := '*';
begin
    --v_tree ���ڿ� ���̰� 5���� �۰ų� ���������� �ݺ��� ����
    while NVL(length(v_tree),0) <= 5 loop
        dbms_output.put_line(v_tree);
        v_tree := v_tree || '*'; --�ݺ����� ����� ������ '*'�߰�
    end loop;
end;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/

DECLARE
    v_dan NUMBER(2,0) := &��;
    v_num NUMBER(2,0) := 1;
BEGIN
    WHILE v_num < 10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || v_num || ' = ' || (v_dan * v_num));
        v_num := v_num + 1; -- 10
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
*/

DECLARE
    v_dan NUMBER(4,0) :=2; --�� (����, 2~9)
    v_number NUMBER(4,0):= 1; --(����1~9)
BEGIN
    WHILE v_dan<=9 LOOP -- ���� �ݺ�
        v_number:= 1;
        WHILE v_number<=9 LOOP -- ���ϴ¼��� �ݺ�
            DBMS_OUTPUT.PUT_LINE(v_dan||'*'||v_number||'='|| (v_number*v_dan));
       
            v_number := v_number+1;                    
        END LOOP;
        v_dan := v_dan + 1;
    END LOOP;
END;
/

-- FOR LOOP�� : ������ ���� �� ��� ������ ������ŭ �ݺ�
-- 1) ����
BEGIN
    FOR �ӽ� ���� IN �ּҰ� .. �ִ밪 LOOP
        -- �ݺ��ϰ��� �ϴ� �ڵ�
    END LOOP;
    -- �ӽú��� : ����Ÿ��, DECLARE���� ���� �������� ����. �ݵ�� �ּҰ��� �ִ밪 ������ �������� ���� => Read Only
    -- �ּҰ�, �ִ밪 : ����, �ݵ�� �ּҰ� <= �ִ밪
END;
/

-- 2) ����
BEGIN 
    FOR idx IN REVERSE 1 .. 5 LOOP -- REVERSE : ���� ���� �����ϴ� ���� ���� ������������ ������ ��
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/
BEGIN 
    FOR idx IN -10 .. -6 LOOP
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/
DECLARE
    v_max NUMBER(2,0) := &�ִ밪;
BEGIN 
    FOR idx IN 5 .. v_max LOOP -- v_max := 0 �ϰ�� FOR LOOP���� ������� ����
        -- idx := 10; -- FOR LOOP���� �ӽú����� ������ �� ����
        DBMS_OUTPUT.PUT_LINE(idx || ' , Hello !!!');
    END LOOP;
END;
/

-- 1 ���� 10���� ������ ���� ���ϱ�
DECLARE
    v_sum NUMBER(2,0) := 0;
BEGIN
    FOR num IN 1 .. 10 LOOP
        -- num : 1 ~ 10 ���� ����
        v_sum := v_sum + num; -- ������ ��
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('���� : ' || v_sum);
END;
/

/*

6. ������ ���� ��µǵ��� �Ͻÿ�.
*          : 1��, * 1�� ���
**         : 2��, * 2�� ���
***        : 3��, * 3�� ���
****       : 4��, * 4�� ���
*****      : 5��, * 5�� ���
=> DBMS_OUTPUT.PUT();
*/

DECLARE
    v_tree VARCHAR2(6) := '';
BEGIN
    FOR count IN 1..5 LOOP
        v_tree := v_tree || '*';
        DBMS_OUTPUT.PUT_LINE(v_tree);
    END LOOP;
END;
/

-- DECLARE �� ���� ���� FOR LOOP�� ���
BEGIN
    FOR line IN 1..5 LOOP -- LINE�� ����, 1 ~ 5
        FOR tree IN 1..line LOOP -- �� LINE���� ��µǴ� '*' ����, LINE = �ִ밪
            DBMS_OUTPUT.PUT('*');
        END LOOP; -- ������ ������� �ǹ�
        DBMS_OUTPUT.PUT_LINE(''); -- ���� ����
    END LOOP;
END;
/

/*
7. ġȯ����(&)�� ����ϸ� ���ڸ� �Է��ϸ� 
�ش� �������� ��µǵ��� �Ͻÿ�.
��) 2 �Է½� �Ʒ��� ���� ���
2 * 1 = 2
2 * 2 = 4
...

*/

DECLARE
    v_dan CONSTANT NUMBER(2,0) := &��;
BEGIN
    FOR num IN 1..9 LOOP -- ���ϴ� �� : ����, 1 ~ 9
        DBMS_OUTPUT.PUT_LINE(v_dan || ' X ' || num || ' = ' || (v_dan * num));
    END LOOP;
END;
/

/*
8. ������ 2~9�ܱ��� ��µǵ��� �Ͻÿ�.
-- 1) 2 ~ 9 ��, ���� �����ؾ� ��. => ù��° LOOP��
-- 2) �ش� ���� ���ϴ� ���� 1 ~ 9 ���� ������ ���� ��� => �ι�° LOOP��
*/

BEGIN
    FOR dan IN 2..9 LOOP -- ù��° LOOP�� : ���� ����, ������ 2 ~ 9
        FOR num IN 1..9 LOOP -- �ι�° LOOP�� : ���ϴ� ���� ����, ������ 1 ~ 9
            -- dan�� ������
            DBMS_OUTPUT.PUT_LINE(dan || ' X ' || num || ' = ' || (dan * num));
        END LOOP;
        -- ���ϴ� ���� ����
    END LOOP;
END;
/















