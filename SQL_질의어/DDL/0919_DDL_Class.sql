SELECT table_name
FROm   user_tables;

-- object_type이 뭐가 있는지 보여줌
SELECT DISTINCT object_type
FROM   user_objects;

-- 사용자가 소유한 테이블, 뷰, 동의어 및 시퀀스 질의
SELECT * 
FROM   user_catalog;