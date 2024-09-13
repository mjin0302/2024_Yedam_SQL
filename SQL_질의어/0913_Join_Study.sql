-- 1. LOCATIONS 및 COUNTRIES 테이블을 사용하여 모든 부서의 주소를 생성하는 query를 작성하시오. 
-- 출력에 위치ID(location_id), 주소(street_address), 구/군(city), 시/도(state_province) 및 국가(country_name)를 표시하시오.
SELECT l.location_id,
       l.street_address,
       l.city,
       l.state_province,
       c.country_name
FROM   LOCATIONS l, COUNTRIES c
WHERE  l.country_id = c.country_id;

-- 2. 모든 사원의 이름, 소속 부서번호 및 부서 이름을 표시하는 query를 작성하시오.
SELECT e.last_name,
       d.department_id,
       d.department_name
FROM   employees e FULL OUTER JOIN departments d
                                ON  e.department_id = d.department_id;
                                
-- 3. Toronto에 근무하는 사원에 대한 보고서를 필요로 합니다. 
--    toronto에서 근무하는 모든 사원의 이름, 직무, 부서번호 및 부서 이름을 표시하시오.
SELECT e.last_name,
       e.job_id,
       e.department_id,
       d.department_name,
       l.city
FROM   employees e, departments d, locations l
WHERE  e.department_id = d.department_id
AND    d.location_id = l.location_id
AND    UPPER(l.city) = UPPER('Toronto');

select * from departments where location_id = 1800;

-- 4. 사원의 이름 및 사원 번호를 해당 관리자의 이름 및 관리자 번호와 함께 표시하는 보고서를 작성하는데, 
--    열 레이블을 각각 Employee, Emp#, Manager 및 Mgr#으로 지정하시오.
SELECT emp.last_name AS Employee,
       emp.department_id AS Emp#,
       mgr.last_name AS Mgr#,
       mgr.manager_id AS Manager
FROM   employees emp, employees mgr
WHERE  mgr.employee_id = emp.manager_id;

-- 5. King과 같이 해당 관리자가 지정되지 않은 사원도 표시하도록 4번 문장을 수정합니다. 사원 번호순으로 결과를 정렬하시오.
SELECT emp.last_name     AS Employee,
       emp.department_id AS Emp#,
       mgr.last_name     AS Mgr#,
       mgr.manager_id    AS Manager
FROM   employees emp LEFT OUTER JOIN employees mgr
                                  ON  (emp.employee_id = mgr.employee_id)
ORDER BY 2;
select * from employees;

-- 6. 직무 등급 및 급여에 대한 보고서를 필요로 합니다. 
--    모든 사원의 이름, 직무, 부서 이름, 급여 및 등급을 표시하는 query를 작성하시오.
SELECT e.last_name,
       e.job_id,
       d.department_name,
       j.grade_level
FROM   employees e, departments d, job_grades j
WHERE  e.department_id = d.department_id
AND    e.salary BETWEEN j.lowest_sal AND j.highest_sal;

SELECT e.last_name,
       e.job_id,
       d.department_name,
       j.grade_level
FROM   employees e JOIN departments d
                     ON e.department_id = d.department_id
                   JOIN job_grades j
                     ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;