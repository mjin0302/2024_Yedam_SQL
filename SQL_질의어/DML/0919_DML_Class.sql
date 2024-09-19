SELECT * FROM departments;
SELECT * FROM employees;

INSERT INTO departments
            (department_id, 
             department_name, 
             manager_id, 
             location_id)
VALUES      (70, 
             'Public Relations', 
             100, 
             1700);
INSERT INTO departments
VALUES      (71, 
             'Public Relations', 
             100, 
             1700);
INSERT INTO departments (department_id, department_name)
VALUES      (30, 
             'Purchasing');
INSERT INTO departments
VALUES (100, 
        'Finance', 
        NULL, 
        '');

INSERT INTO employees
VALUES (113,
        'Louis',
        'Popp',
        'LPOPP',
        '515.124.4567',
        SYSDATE,
        'AC_ACCOUNT',
        6900,
        NULL,
        205,
        110
       );
INSERT INTO employees
VALUES      (114,
             'Den',
             'Raphealy',
             'DRAPHEAL',
             '515.127.4561',
             TO_DATE('02 03, 1999', 'MM DD, YYYY'),
             'SA_REP',
             11000,
             0.2,
             100,
             60);

INSERT INTO sales_reps(id,
                       name,
                       salary, 
                       commission_pct) SELECT employee_id, 
                                              last_name, 
                                              salary, 
                                              commission_pct
                                       FROM   employees
                                       WHERE  job_id LIKE '%REP%';
UPDATE employees
SET    department_id = 50
WHERE  employee_id = 113;

SELECT *
FROM   employees
WHERE  employee_id = 113;

-- employees데이터를 copy_emp테이블에 복사함
INSERT INTO copy_emp
  SELECT *
  FROM   employees;
  
SELECT * FROM copy_emp ORDER BY employee_id;
  
UPDATE copy_emp
SET    department_id = 110;
  
SELECT * FROM copy_emp;

UPDATE employees
SET    job_id = (SELECT job_id
                 FROM   employees
                 WHERE  employee_id = 205),
       salary = (SELECT salary
                 FROM   employees
                 WHERE  employee_id = 205)
WHERE  employee_id = 113;
SELECT * FROM employees WHERE employee_id IN (113, 205);

SELECT * 
FROM   departments;

DELETE FROM departments
WHERE  department_name = 'Finance';

DELETE FROM copy_emp;

ROLLBACK;

SELECT * 
FROM   copy_emp;

TRUNCATE TABLE copy_emp;

commit;

INSERT INTO copy_emp
  SELECT *
  FROM   employees;

SELECT *
FROM   copy_emp;

commit;
UPDATE copy_emp
SET    salary = 9999
WHERE  employee_id = 176;

SELECT *
FROM   copy_emp
WHERE  employee_id = 176;
rollback;