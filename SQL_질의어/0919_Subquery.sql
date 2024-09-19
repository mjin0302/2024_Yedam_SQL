SELECT last_name,
       job_id
FROM   employees
WHERE  job_id = (
                  SELECT job_id
                  FROM   employees
                  WHERE  employee_id = 141
                );

SELECT last_name,
       job_id
FROM   employees
WHERE  job_id = (
                  SELECT job_id
                  FROM   employees
                  WHERE  employee_id = 141
                )
AND    employee_id != 141;

SELECT last_name,
       job_id,
       salary
FROM   employees
WHERE  job_id = (
                  SELECT job_id
                  FROM   employees
                  WHERE  employee_id = 'Taylor'
                )
AND    salary > (
                  SELECT salary
                  FROM   employees
                  WHERE  last_name = 'Taylor'
                );
                
SELECT last_name,
       job_id,
       salary
FROM   employees
WHERE  salary = (
                  SELECT MIN(salary)
                  FROM   employees
                );
SELECT last_name,
       job_id,
       salary
FROM   employees
WHERE  job_id = (
                  SELECT job_id
                  FROM   employees
                  WHERE  employee_id = 141
                )
AND    salary > (
                  SELECT salary
                  FROM   employees
                  WHERE  employee_id = 141
                );

SELECT   MIN(salary)
FROM     employees
GROUP BY department_id;

-- 다중행 비교연산자
-- IN ** 가장 많이 사용한다 **
SELECT last_name,
       salary,
       department_id
FROM   employees
WHERE  salary IN (
                  SELECT   MIN(salary)
                  FROM     employees
                  GROUP BY department_id
                 );
                 
SELECT last_name,
       job_id,
       salary
FROM   employees
WHERE  job_id = (
                  SELECT job_id
                  FROM   employees
                  WHERE  employee_id = 141
                )
AND    salary > (
                  SELECT salary
                  FROM   employees
                  WHERE  employee_id = 141
                );

SELECT employee_id,
       last_name,
       job_id,
       salary
FROM   employees
WHERE  salary < ANY (
                      SELECT salary
                      FROM   employees
                      WHERE  job_id = 'IT_PROG'
                    );
                    SELECT last_name,
       job_id,
       salary
FROM   employees
WHERE  salary = (
                  SELECT MIN(salary)
                  FROM   employees
                );
-- 
SELECT employee_id,
       last_name,
       job_id,
       salary
FROM   employees
WHERE  salary > ALL (
                      SELECT salary
                      FROM   employees
                      WHERE  job_id = 'IT_PROG'
                    );

SELECT employee_id,
       manager_id,
       department_id
FROM   empl_demo
WHERE  (manager_id, department_id) IN (
                                        SELECT manager_id,
                                               department_id
                                        FROM   empl_demo
                                        WHERE  first_name = 'John'
                                      )
AND    first_name <> 'John';

SELECT employee_id,
       manager_id,
       department_id
FROM   empl_demo
WHERE  manager_id    IN (
                          SELECT manager_id
                          FROM   empl_demo
                          WHERE  first_name = 'John'
                        )
AND    department_id IN (
                          SELECT department_id
                          FROM   empl_demo
                          WHERE  first_name = 'John'
                        )
AND    first_name <> 'John';