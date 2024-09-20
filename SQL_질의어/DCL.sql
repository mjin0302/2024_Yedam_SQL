SELECT * 
FROM   system_privilege_map;

CREATE USER kmj IDENTIFIED BY kmj;

GRANT create session
TO    kmj, hr;

-- 권한 주기
GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW
TO    kmj;

-- 권한뺏기
REVOKE CREATE TABLE,
       CREATE VIEW
FROM   kmj;

-- 비밀번호 변경
ALTER USER kmj
IDENTIFIED BY lion; -- lion이 변결 할 비밀번호임

-- 권한 바구니 생성
CREATE ROLE manager;

-- 바구니에 권한 저장 해놓기
GRANT create session, create table, create view
TO    manager;

-- kmj에게 manager 바구니에 담긴 권한 주기
GRANT manager
TO    kmj;

-- 롤 삭제
DROP ROLE manager;

-- 관리자 계정에서 kmj한테 hr계정 employees테이블에 대한 select권한을 줄때 
GRANT select
ON    hr.employees
TO    kmj;

-- hr계정에서 다른 사용자한테 권한을 줄때 on절에 계정명을 안써도 무방함
GRANT select
ON    hr.employees
TO    kmj;

REVOKE select
ON     hr.employees
FROM   kmj;

select user_role_privs
from  kmj;

SELECT * 
FROM   DBA_ROLE_PRIVS
WHERE  GRANTEE = 'kmj';