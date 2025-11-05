-- JOIN문

-- 두 개 이상의 테이블을 묶어서 하나의 결과 집합으로 출력

-- INNER JOIN
-- 복수의 테이블이 공통적으로 만족하는 레코드를 출력(교집합)
-- INNER JOIN에서 INNER 를 안적어도 자체 생략돼있는 걸로 판단 가능 

-- 전 사원의 사번, 이름, 현재급여를 출력해주세요
SELECT 
	emp.emp_id
	,emp.`name`
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS NULL
ORDER BY emp.emp_id ASC
;

-- 10번의 사번, 이름, 현재급여를 출력해주세요	

-- 현재 부서가 사업부에 소속해 있는 사원들의 평균 연봉

-- 현재 재직 중인 사원의 사번, 이름, 생일, 부서명 
-- right join은 하지마세요. left 기준으로 하세요
-- 제일 왼쪽에 있는 테이블의 레코드 수가 양이 적을 수록 성능 good.  

SELECT
	 depe.emp_id
	 ,emp.`name`
	 ,emp.birth
	 ,dept.dept_name
FROM department_emps depe
	JOIN departments dept
		ON depe.dept_code = dept.dept_code
			AND depe.end_at IS NULL
	JOIN employees emp
		ON depe.emp_id = emp.emp_id
			AND emp.fire_at IS NULL
;

SELECT
	 depe.emp_id
	 ,emp.`name`
	 ,emp.birth
	 ,dept.dept_name
FROM department_emps depe
	JOIN departments dept
		ON depe.dept_code = dept.dept_code		
	JOIN employees emp
		ON depe.emp_id = emp.emp_id
WHERE
	depe.end_at IS NULL
	AND emp.fire_at IS NULL
;


-- LEFT JOIN
SELECT 
	emp.emp_id	
	,sal.salary
FROM employees emp
	LEFT JOIN salaries sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS NULL 
;

-- UNION
-- 두 쿼리의 결과를 합쳐서 출력
-- UNION은 중복 값을 제거하고 출력하고, UNION ALL은 중복 값도 출력
-- 10005이 중복되므로 10001과 10005 사원의 2개의 레코드만 출력

SELECT * FROM employees WHERE emp_id = 10001 OR emp_id = 10005
UNION
SELECT * FROM employees WHERE emp_id = 10005
;

-- 중복 레코드도 출력하므로 10001 1개와 10005 2개로 총 3개의 레코드 출력
SELECT * FROM employees WHERE emp_id = 10001 OR emp_id = 10005
UNION ALL
SELECT * FROM employees WHERE emp_id = 10005
;

-- SELF JOIN
-- 같은 테이블끼리 JOIN, 새로운 테이블 추가 시 문제 발생 가능

SELECT 
	emp.emp_id AS junior_id 
	,emp.`name` AS junior_name	
	,supemp.emp_id AS supervisor_id
	,supemp.`name` AS superviosor_name
FROM employees emp
	JOIN employees supemp
		ON emp.sup_id = supemp.emp_id
 			AND emp.emp_id IS NOT NULL
;




				