-- test

-- 1. 사원의 사원번호, 이름, 직급코드를 출력해 주세요.

-- SELECT 
-- 	emp.emp_id
-- 	,emp.`name`
-- 	,tite.title_code
-- FROM employees emp
-- 	JOIN title_emps tite
-- 		ON emp.emp_id = tite.emp_id
-- 			AND end_at IS NULL
-- ; 

SELECT
	emp.emp_id
	,emp.`name`
	,tite.title_code 
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
			AND tite.end_at IS NULL
;			


-- 2. 사원의 사원번호, 성별, 현재 연봉을 출력해 주세요.

-- SELECT 
-- 	emp.emp_id
-- 	,emp.`gender`
-- 	,sal.salary
-- FROM employees emp
-- 	JOIN salaries sal
-- 		ON emp.emp_id = sal.emp_id
-- 			AND end_at IS NULL and 에 테이블 명 기억! 
-- ;

SELECT 
	emp.emp_id
	,emp.`gender`
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS NULL
;			


-- 3. 10010 사원의 이름과 과거부터 현재까지 연봉 이력을 출력해 주세요.

-- SELECT 
-- 	emp.emp_id
-- 	,emp.`name`
-- 	,sal.salary
-- -- 	,sal.start_at
-- -- 	,sal.end_at
-- FROM employees emp 
-- 	JOIN salaries sal
-- 		ON emp.emp_id = sal.emp_id
-- 			AND sal.salary 
-- WHERE emp.emp_id = 10010			  
-- ;

SELECT 
	emp.`name`
	,sal.start_at
	,sal.end_at
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND emp.emp_id = 10010
ORDER BY sal.start_at ASC
;

-- 4. 사원의 사원번호, 이름, 소속부서명을 출력해 주세요.
-- SELECT 
-- 	emp.emp_id
-- 	,emp.`name`
-- 	,dep.dept_name
-- FROM employees emp
-- 	JOIN department_emps depe
-- 		ON emp.emp_id = depe.emp_id
-- 	JOIN departments dep
-- 		ON depe.dept_code = dep.dept_code
-- 			AND emp.fire_at IS NULL 
-- ;	
SELECT
 	emp.emp_id
	,emp.`name`
	,dept.dept_name
FROM employees emp
	JOIN department_emps depe
		ON emp.emp_id = depe.emp_id
		AND depe.end_at IS NULL
	JOIN departments dept
		ON dept.dept_code = depe.dept_code
;		


-- 5. 현재 연봉의 상위 10위까지 사원의 사번, 이름, 연봉을 출력해 주세요.
-- SELECT 
-- 	emp.emp_id
-- 	,emp.`name`
-- 	,sal.salary
-- 	,ROW_NUMBER() OVER(ORDER BY salary DESC) AS sal_rank
-- FROM salaries sal
-- 	JOIN employees emp
-- 		ON emp.emp_id = sal.emp_id
-- 			AND sal.end_at IS NULL
-- LIMIT 10
-- ;	

-- --- let's pratice tgt
SELECT 
	emp.emp_id
	,emp.`name`
	,sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND sal.end_at IS NULL
-- AND emp.fire_at IS NULL 안정성을 위해 퇴사자도 넣어주는 게 좋다.
-- GROUP BY emp.emp_id 이미 sal.end_at 에 null을 줬으니 한 사원의 하나의 
-- 연봉이므로 굳이 그룹을 지을 필요가 없다.
ORDER BY sal.salary DESC
LIMIT 10
;

-- ---- subquery version
SELECT
	emp.emp_id
	,emp.`name`
	,tmp_sal.salary
FROM employees emp
	JOIN (
		SELECT 
			sal.emp_id
			,sal.salary
		FROM salaries sal
		WHERE 
			sal.end_at IS NULL
		ORDER BY sal.salary DESC
		LIMIT 10  
	) tmp_sal
		ON emp.emp_id = tmp_sal.emp_id
ORDER BY tmp_sal.salary DESC		
;

-- 6. 현재 각 부서의 부서장의 부서명, 이름, 입사일을 출력해 주세요.
-- SELECT DISTINCT
-- 	de.dept_name
-- 	,emp.`name`	
-- 	,depe.start_at
-- FROM department_emps	depe
-- 	JOIN employees emp
-- 		ON emp.emp_id = depe.emp_id
-- 	JOIN department_managers depm
-- 		ON depe.dept_code = depm.dept_code
-- 	JOIN departments de
-- 		ON depm.dept_code = de.dept_code	
-- 			AND de.end_at IS NULL
-- GROUP BY de.dept_name
-- ;
-- 

SELECT 
	dept.dept_name
	,emp.`name`
	,emp.hire_at
FROM department_managers depm
	JOIN departments dept
		ON depm.dept_code = dept.dept_code
		AND depm.end_at IS NULL
	JOIN employees emp
		ON depm.emp_id = emp.emp_id
		AND emp.fire_at IS NULL		
ORDER BY dept.dept_code ASC
;		

-- 7. 현재 직급이 "부장"인 사원들의 연봉 평균을 출력해 주세요.
-- SELECT 
-- 	emp.`name`
-- 	,AVG(salary)
-- FROM employees emp
-- 	JOIN title_emps tite
-- 		ON emp.emp_id = tite.emp_id
-- 	JOIN titles te
-- 		ON tite.title_code = te.title_code
-- 			AND te.title = '부장'
-- 			AND tite.end_at IS NULL
--    JOIN salaries sal
-- 			ON tite.emp_id = sal.emp_id
-- ;

SELECT 
	AVG(sal.salary) avg_sal
FROM titles tit
	JOIN title_emps tite
		ON tit.title_code = tite.title_code
		AND tit.title = '부장'
		AND tite.end_at IS NULL
	JOIN salaries sal
		ON tite.emp_id = sal.emp_id
		AND sal.end_at IS NULL
;

-- 현재 각 부장별 이름, 연봉평균
SELECT
	emp.`name`
	,AVG(sal.salary)
FROM titles tit
	JOIN title_emps tite
		ON tit.title_code = tite.title_code
		AND tit.title = '부장'
		AND tite.end_at IS NULL
	JOIN employees emp
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id	
GROUP BY sal.emp_id, emp.`name`
-- 그룹에서 사용한 것만  select에서 사용하는 게 기본 문법 
;

-- ---- bj T
SELECT 
	emp.`name`
	,sub_salaries.avg_sal
FROM employees emp
	JOIN (
		SELECT 
			sal.emp_id
			,AVG(sal.salary) avg_sal
		FROM title_emps tite
			JOIN titles tit
				ON tite.title_code = tit.title_code
				AND tit.title = '부장'
				AND tite.end_at IS NULL
			JOIN 	salaries sal
				ON sal.emp_id = tite.emp_id
		GROUP BY sal.emp_id
	) sub_salaries
-- 서브 쿼리로 만든 테이블임을 명시(방식_복수형명사 사용)
		ON emp.emp_id = sub_salaries.emp_id
		AND emp.fire_at IS NULL 
;
-- join 할 테이블 묶어서 먼저 subquery 하고, 이용하는 편


-- 8. 부서장직을 역임했던 모든 사원의 이름과 입사일, 사번, 부서번호를 출력해 주세요.
-- 중복된 사원 나올 수 있음(Q - 여러 부서 이동을 한 사원이면 어떻게 하나요? )
SELECT
	emp.`name`
	,emp.hire_at
	,emp.emp_id
	,depe.dept_code
FROM employees emp
	JOIN department_emps depe
		ON emp.emp_id = depe.emp_id
	JOIN department_managers depm
		ON depm.emp_id = depe.dept_emp_id
;

SELECT 
	emp.`name`
	,emp.hire_at
	,emp.emp_id
	,depm.dept_code
FROM department_managers depm
	JOIN employees emp
		ON depm.emp_id = emp.emp_id
;


-- 9. 현재 각 직급별 평균연봉 중 60,000,000이상인 직급의 직급명, 평균연봉(정수)를
--		평균연봉 내림차순으로 출력해 주세요.


SELECT
	titles.title_code
	,AVG(sal.salary) AS avg_sal
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
			AND sal.end_at IS NULL
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
			AND tite.end_at IS NULL
GROUP BY 
	titles DESC
	-- 그룹에 바로 desc 줄 수 없음. 
	HAVING
		AVG(sal.salary) >= 60000000
;


SELECT 
	tit.title
	,CEILING(AVG(sal.salary)) avg_sal
FROM salaries sal
	JOIN title_emps tite
		ON sal.emp_id = tite.emp_id
		AND sal.end_at IS NULL 
		AND tite.end_at IS NULL 
	JOIN titles tit
		ON tit.title_code = tite.title_code	 
GROUP BY tit.title
	HAVING avg_sal >= 60000000	
ORDER BY avg_sal DESC
;



-- 10. 성별이 여자인 사원들의 직급별 사원수를 출력해 주세요.
-- SELECT 
-- 	COUNT(*)
-- 	,NULLIF(gender, 'F') AS nullif_gender
-- FROM employees emp
-- 	JOIN title_emps tite
-- 		ON emp.emp_id = tite.emp_id
-- 			AND tite.end_at IS NULL
-- WHERE 
-- GROUP BY tite ASC
-- 	HAVING COUNT(nullif_gender)
-- ;	

SELECT 
	tite.title_code
	,COUNT(*) cnt_f_emp
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL 
		AND tite.end_at IS NULL
		AND emp.gender = 'F' 	
GROUP BY tite.title_code
;

SELECT 
	tite.title_code
	,emp.gender
	,tit.title
	,COUNT(*) cnt__emp
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL 
		AND tite.end_at IS NULL
	JOIN titles tit
		ON tit.title_code = tite.title_code	
GROUP BY tite.title_code, emp.gender, tit.title 
ORDER BY tite.title_code ASC, emp.gender ASC, tit.title ASC 
;
-- 프로그래밍 단에서 f, m은 정렬하면 됨. db에서는 간단히 출력만 하세요.	


	