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

SELECT * FROM sales_reps;