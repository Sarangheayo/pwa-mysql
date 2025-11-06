-- TRANSACTION

-- --------------
-- 트랜잭션 시작
-- --------------
START TRANSACTION;

-- insert 
INSERT INTO employees (`name`, birth, gender, hire_at)
VALUES ('최설아','2001-01-18','F', DATE(NOW()));

-- select
SELECT * FROM employees WHERE `name` = '최설아';		

-- rollback
ROLLBACK;

-- commit
COMMIT; 


