-- UPDATE 문

UPDATE employees
SET
	fire_at = NOW()
	, deleted_at = NOW()
WHERE
	emp_id = 100020
;	


select * 
FROM  salaries 
WHERE 
	emp_id = 100020
;	

UPDATE salaries
SET 
	salary = 30000000
WHERE 
	sal_id = 1022182
;	


SELECT *
FROM salaries
WHERE 
	emp_id = 100000
	AND end_at IS NULL
;	


