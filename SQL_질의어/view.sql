CREATE VIEW empvu80
  AS  SELECT employee_id,
             last_name,
             salary
      FROM   employees
      WHERE  department_id = 80;
      
SELECT *
FROM   empvu80;

CREATE OR REPLACE VIEW salvu50 (id_number,
                                name,
                                ann_salary)
  AS SELECT employee_id,
            last_name,
            salary * 12
     FROM   employees
     WHERE  department_id = 50;
     
SELECT *
FROM   salvu50;

SELECT *
FROM   user_objects;

DROP VIEW v10;

CREATE SEQUENCE dept_deptid_seq
                INCREMENT BY 10
                START WITH   120
                MAXVALUE     9999
                NOCACHE
                NOCYCLE;
DROP SEQUENCE dept_deptid_seq;
INSERT INTO departments
            (department_id,
             department_name, 
             location_id)
VALUES      (dept_deptid_seq.NEXTVAL,
             'Support', 
             2500);

CREATE SYNONYM d_sum
FOR    departments;

DROP SYNONYM d_sum;
select * from d_sum;

