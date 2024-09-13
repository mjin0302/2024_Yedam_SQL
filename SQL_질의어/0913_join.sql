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

SELECT   employee_id,
         last_name
         location_id,
         department_id
FROM     employees JOIN departments
                   USING(department_id);