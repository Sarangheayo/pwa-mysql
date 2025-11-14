SELECT 
	tite.emp_id, 
	emp.`name`,
	tite.title_code
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND tite.emp_id = 1
		AND tite.end_at IS null
;

-- sequelize 작성 시 my sql join 평문 작성 후 로직 진행. 

	

