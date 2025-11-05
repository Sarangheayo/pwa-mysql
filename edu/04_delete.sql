-- DELETE 문

DELETE FROM salaries
WHERE
	emp_id = 100020
;	

DELETE FROM employees 
WHERE 
	emp_id = 100020
	AND `birth` = '2001-01-18'
;

