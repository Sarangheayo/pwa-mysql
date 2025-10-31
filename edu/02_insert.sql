-- INSERT 문
-- 신규 데이터를 저장하기 위해 사용하는 문.
INSERT INTO employees (
	`name`
	,birth
	,gender
	,hire_at
	,fire_at
	,sup_id
	,created_at
	,updated_at
	,deleted_at
)
VALUES (
	'최설아'
	,'2001-01-18'
	,'F'
	,'2025-10-31'
	,NULL
	,NULL
	,NOW()
	,NOW()
	,NULL
);

-- 이름, 입사일, 생일을 불러와서 조합해서 찾기
SELECT *
FROM employees
WHERE
	`name` = '최설아'
	AND birth = '2001-01-18'
	AND hire_at = '2025-10-31'
; 


INSERT INTO salaries (
	emp_id
	,salary
	,start_at 
)
VALUES (
	100019
	,'3243246463452352'
	,NOW()
);

-- SELECT INSERT (HONEY TIP)
INSERT INTO salaries (
	emp_id
	,salary
	,start_at
)
SELECT 
	emp_id
	,3000000000 salary
	,created_at
FROM employees
WHERE
	`name` = '최설아'
	AND birth = '2001-01-18'
	AND hire_at = '2025-10-31'
; 





















 