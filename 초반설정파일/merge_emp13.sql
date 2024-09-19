MERGE INTO emp13 c
     USING employees e
     ON (c.employee_id = e.employee_id)
   WHEN MATCHED THEN
     UPDATE SET
       c.last_name      = e.last_name,
       c.job_id         = e.job_id,
       c.salary         = e.salary,
       c.department_id  = e.department_id
      DELETE WHERE (e.commission_pct IS NULL)
   WHEN NOT MATCHED THEN
     INSERT VALUES(e.employee_id, e.last_name,e.job_id,
          e.salary, e.commission_pct, e.department_id)
/
COMMIT
/
