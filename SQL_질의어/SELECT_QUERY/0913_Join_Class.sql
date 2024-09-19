-- CROSS JOIN (표준 조인)
SELECT last_name,
       department_name
FROM   employees CROSS JOIN departments;

-- CROSS JOIN (oracle 조인)
SELECT last_name,
       department_name
FROM   employees, departments;

-- NATUAL JOIN (표준 조인) : 두 테이블 사이에 동일한 컬럼명이 있을 때만 사용 가능
SELECT   d.department_id,
         d.department_name,
         location_id, -- 이걸 기준으로 조인하기 때문에 어느 테이블꺼인지 정해줄 필요가 없다
         l.city
FROM     departments d NATURAL JOIN locations l
ORDER BY d.department_id;

-- NATUAL JOIN (oracle 조인)
SELECT   d.department_id,
         d.department_name,
         l.location_id,
         l.city
FROM     departments d, locations l
WHERE    d.location_id = l.location_id;

-- USING 조인 (표준)
SELECT   employee_id,
         last_name
         location_id,
         department_id
FROM     employees JOIN departments
                   USING(department_id);

-- INNER JOIN : 두 테이블을 조인해서 일치하는 열만 반환함
-- 표준조인
SELECT e.employee_id,
       e.last_name,
       e.department_id,
       d.department_id,
       d.location_id
FROM   employees e JOIN departments d
                    ON(e.department_id = d.department_id);

-- oracle JOIN
SELECT e.employee_id,
       e.last_name,
       e.department_id,
       d.department_id,
       d.location_id
FROM   employees e, departments d
WHERE  e.department_id = d.department_id;

/* 사원 이름 (last_name)과 해당 사원이 소속되어 있는 부서 이름(department_name)을
출력하세요 */
-- 표준 조인
SELECT e.last_name,
       d.department_name
FROM   employees e JOIN departments d
                   ON  e.department_id = d.department_id;

-- oracle 조인
SELECT e.last_name,
       d.department_name
FROM   employees e, departments d
WHERE  e.department_id = d.department_id;

SELECt employee_id,
       city,
       department_name
FROM   employees e JOIN departments d
                     ON (d.department_id = e.department_id)
                   JOIN locations l
                     ON (d.location_id = l.location_id);

SELECT e.employee_id,
       l.city,
       d.department_name
FROM   employees e, departments d, locations l
WHERE  d.department_id = e.department_id 
AND    d.location_id = l.location_id;

SELECT employee_id,
       city,
       department_name
FROM   employees e JOIN departments d
                     ON (d.department_id = e.department_id)
                   JOIN locations l
                     ON (d.location_id = l.location_id)
                    AND e.manager_id = 149;

SELECT w.last_name emp,
       m.last_name mgr
FROM   employees w JOIN employees m
                     ON (w.manager_id = m.employee_id);
                     
SELECT w.last_name emp,
       m.last_name mgr
FROM   employees w, employees m
WHERE  w.manager_id = m.employee_id;

-- 비동등 조인
SELECT e.last_name,
       e.salary,
       j.grade_level
FROM   employees e JOIN job_grades j
                     ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- LEFT OUTER JOIN
SELECT e.last_name,
       e.department_id,
       d.department_name
FROM   employees e LEFT OUTER JOIN departments d
                                ON (e.department_id  = d.department_id);

-- ORACLE LEFT OUTER JOIN
SELECT e.last_name,
       e.department_id,
       d.department_name
FROM   employees e, departments d
WHERE  e.department_id  = d.department_id(+);

-- RIGHT OUTER JOIN
SELECT e.last_name,
       e.department_id,
       d.department_name
FROM   employees e RIGHT OUTER JOIN departments d
                                ON (e.department_id  = d.department_id);

-- ORACLE RIGHT OUTER JOIN
SELECT e.last_name,
       e.department_id,
       d.department_name
FROM   employees e, departments d
WHERE  e.department_id(+) = d.department_id;
                                
-- FULL OUTER JOIN
SELECT e.last_name,
       e.department_id,
       d.department_name
FROM   employees e FULL OUTER JOIN departments d
                                ON (e.department_id  = d.department_id);

