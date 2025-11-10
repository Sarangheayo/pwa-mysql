SELECT 
	gender
	,COUNT(*) AS cnt
-- 	,CONCAT(ROUND(COUNT(*) * 100.0000 / SUM(COUNT(*)) OVER (), 4), '%') AS pct
	, CONCAT(ROUND(COUNT(*) * 100.0000 / SUM(COUNT(*)) OVER (), 4), '%' ) AS pct
FROM employees
GROUP BY gender
;



-- ERD 만들어보기 (사원)
CREATE TABLE `employees` (
	`emp_id`	BIGINT UNSIGNED AUTO_INCREMENT	NOT NULL,
	`name`	VARCHAR(50)	NOT NULL,
	`birth`	DATE	NULL,
	`gender`	CHAR(1)	NOT NULL	COMMENT "'M'은 남자 'F'는 여자",
	`hire_at`	DATE	NOT NULL,
	`fire_at`	DATE	NULL,
	`sup_id`	BIGINT UNSIGNED	NOT NULL,
	`created_at`	CURRENT_TIMESTAMP()	NOT NULL,
	`updated_at`	CURRENT_TIMESTAMP()	NULL,
	`deleted_at`	CURRENT_TIMESTAMP()	NULL
);

ALTER TABLE `employees` ADD CONSTRAINT `PK_EMPLOYEES` PRIMARY KEY (
	`emp_id`
);


-- ERD EXAMPLE (연봉)
CREATE TABLE `salaries` (
	`sal_id`	BIGINT UNSIGNED AUTO_INCREMENT	NOT NULL,
	`emp_id`	BIGINT	NOT NULL,
	`salary`	BIGINT	NULL,
	`hire_at`	DATE	NOT NULL,
	`end_at`	DATE	NULL	DEFAULT NULL,
	`created_at`	TIMESTAMP	NOT NULL	DEFAULT CURRENT_TIMESTAMP(),
	`updated_at`	TIMESTAMP	NOT NULL	DEFAULT CURRENT_TIMESTAMP(),
	`deleted_at`	TIMESTAMP	NULL
);

ALTER TABLE `employees` ADD CONSTRAINT `PK_EMPLOYEES` PRIMARY KEY (
	`emp_id`
);

ALTER TABLE `salaries` ADD CONSTRAINT `PK_SALARIES` PRIMARY KEY (
	`sal_id`
);

16:40분까지 마무리 


-- 1. 모든 직원의 이름과 입사일을 조회하세요.

SELECT
	`name` 
	,hire_at
FROM employees
;	
	

-- 2. 'd005' 부서에 속한 모든 직원의 직원 ID를 조회하세요.
 
SELECT 
	emp_id
FROM department_emps 
WHERE 
	dept_code = 'D005' 
	AND end_at IS NULL	
; 


-- BJ T
SELECT 
	depe.emp_id
FROM department_emps depe 
		JOIN employees emp
			ON depe.emp_id = emp.emp_id
			AND emp.fire_at IS NULL
WHERE 
	depe.dept_code = 'D005'
	AND depe.end_at IS NULL 
;	

-- 3. 1995년 1월 1일 이후에 입사한 모든 직원의 정보를 입사일 순서대로 정렬하여 조회하세요.

SELECT *
FROM employees
WHERE
	hire_at >= '1995-01-01'
ORDER BY hire_at ASC	
;


SELECT *
	FROM employees
WHERE 
	hire_at >='	YYYY-MM-DD HH:mm:ss.sss' ms 도 출력 가능
;	



-- ** 4. 각 부서별로 몇 명의 직원이 있는지 계산하고, 직원 수가 많은 부서부터 순서대로 보여주세요.
SELECT
	COUNT(dept.dept_name) dept_order
	, dept.dept_name dept_name
FROM departments dept
	JOIN department_emps depe
		ON dept.dept_code = depe.dept_code
GROUP BY dept.dept_name
ORDER BY dept_order DESC
;

-- bj T
SELECT 
	dept_code
	,COUNT(*) cnt_emps
	-- null인 건 제외하고 가져오고 싶으면 하나씩 적어주고, 특정 컬럼만 가져오고 싶으면
	-- 그렇게 적어주세요
FROM department_emps
WHERE 
	end_at IS NULL
GROUP BY dept_code
ORDER BY cnt_emps DESC
;

-- 좀 더 엮고 싶으면 이름 연결하고, 좀더 정규화 제대로 하고 싶으면 employess.fire_at is null 주기



SELECT
	COUNT(depe.dept_emp_id) depe_cnt 
	, dept.dept_name
FROM department_emps depe
	JOIN departments dept
		ON depe.dept_code = depe.dept_code
		AND depe.end_at IS NULL
		AND depe.dept_code IS NOT NULL
GROUP BY 
	depe.dept_emp_id
	, dept.dept_name
ORDER BY 
	depe_cnt DESC
;	


-- 5. 각 직원의 현재 연봉 정보를 조회하세요.
SELECT 
	emp_id
	,CEILING (AVG(salary)) emp_current_sal
FROM salaries
GROUP BY emp_id
;


-- bj t
SELECT 
	emp_id
	,salary
FROM salaries
WHERE 
	end_at IS NULL
;


-- 6. 각 직원의 이름과 해당 직원의 현재 부서 이름을 함께 조회하세요.
SELECT DISTINCT emp.emp_id
	,emp.`name`
	, dept.dept_name
FROM employees emp
	JOIN department_emps depe
		ON emp.emp_id = depe.emp_id
			AND emp.fire_at IS NULL
	JOIN departments dept
		ON depe.dept_code = dept.dept_code
		AND depe.end_at IS NULL
GROUP BY 
	emp.`name`
	, depe.dept_emp_id
ORDER BY emp.`name` ASC
;

-- bj T
SELECT
	emp.`name`
	,dep.dept_name
FROM employees emp
	JOIN department_emps depe
		ON emp.emp_id = depe.emp_id
		AND emp.fire_at IS NULL
		AND depe.end_at IS NULL
	JOIN departments dep
		ON depe.dept_code = dep.dept_code
;


-- 7. '마케팅부' 부서의 현재 매니저의 이름을 조회하세요.
SELECT 
	emp.`name`
FROM employees emp
	JOIN department_managers depm
		ON emp.emp_id = depm.emp_id
		AND emp.fire_at IS NULL 	
	JOIN departments dept
		ON depm.dept_code = dept.dept_code
		AND dept.dept_name = '마케팅부'
	-- AND dept.end_at IS NULL 빼먹지 마세용 ! 전부 체크해주기
		AND depm.end_at IS NULL	
;

SELECT
	emp.`name`
FROM departments dep
	JOIN department_managers depm
		ON dep.dept_code = depm.dept_code
		AND dep.dept_name = '마케팅부'
		AND dep.end_at IS NULL
		AND depm.end_at IS NULL
	JOIN employees emp 
		ON depm.emp_id = emp.emp_id
		AND emp.fire_at IS NULL		
;		
-- 맞는지 검사
SELECT 
 	`name`
FROM employees
 WHERE 
 	emp_id = 10540
; 	


-- 8. 현재 재직 중인 각 직원의 이름, 성별, 직책(title)을 조회하세요.


SELECT 
	emp.`name`
	, emp.gender
	, titles.title
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL 
		AND tite.end_at IS NULL	
	JOIN titles 
		ON tite.title_code = titles.title_code
ORDER BY emp.`name` ASC		
;

-- bj T
SELECT 
	emp.`name`
	,emp.gender
	,tit.title
FROM employees emp
	JOIN title_emps tite
		ON emp.emp_id = tite.emp_id
		AND emp.fire_at IS NULL
		AND tite.end_at IS NULL
	JOIN titles tit
 		ON tite.title_code = tit.title_code
;
-- dbms 마다 차이는 있음. null도 인덱싱을 할 수 이씅ㅁ

-- 9. 현재 가장 높은 연봉을 받는 상위 5명의 직원 ID와 연봉을 조회하세요.


SELECT 
	emp.emp_id
	, sal.salary
FROM employees emp
	JOIN salaries sal
		ON emp.emp_id = sal.emp_id
		AND emp.fire_at IS NULL 
		AND sal.end_at IS NULL
GROUP BY 
	emp.emp_id
	, sal.salary 
ORDER BY salary DESC
LIMIT 5
; 


-- bj T

SELECT
	emp.emp_id
	,sal.salary
FROM salaries sal
	JOIN employees emp
		ON sal.emp_id = emp.emp_id
		AND emp.fire_at IS null
		AND sal.end_at IS NULL 
ORDER BY sal.salary DESC
LIMIT 5 OFFSET 5
-- 6-10등까지 레코드 구해야 한다면 저렇게 사용 가능.
-- 커서 5의 여기 다음 레코드부터 5개 읽은 후, 6번부터 5개. 
;



-- 10. 각 부서의 현재 평균 연봉을 계산하고, 평균 연봉이 60000000 이상인 부서만 조회하세요.
-- 각 사원들의 연봉 평균 계산 후, 부서로 감싸기 	
SELECT 
	depe.dept_code
	,CEILING(AVG(sal.salary)) sal_avg
FROM salaries sal
	JOIN department_emps depe
		ON depe.emp_id = sal.emp_id
		AND depe.end_at IS NULL 
		AND sal.end_at IS NULL
GROUP BY depe.dept_code
HAVING sal_avg >= 40000000
;


SELECT 
 	 depe.dept_code
   ,dept.dept_name
	,ROUND(AVG(sal.salary))
FROM salaries sal
GROUP BY
		sal.emp_id	
		,sal.salary	
	JOIN department_emps depe
		ON sal.emp_id = depe.emp_id
		AND sal.end_at IS NULL
		AND depe.end_at IS NULL
	JOIN departments dept
		ON depe.dept_code = dept.dept_code
		AND dept.end_at IS NULL
GROUP BY 
	depe.dept_code
	,dept.dept_name
HAVING 
	AVG(sal.salary) >= 60000000 DESC 
;	
	
	
-- bj T
SELECT 
	depe.dept_code
	,AVG(sal.salary) avg_salary
FROM salaries sal
	JOIN department_emps depe
		ON sal.emp_id = depe.emp_id
		AND sal.end_at IS NULL
		AND depe.end_at IS null
GROUP BY depe.dept_code
	HAVING avg_salary >= 60000000 
;	
	
	
-- ------------------------------------------------------------------------	
	
	
DROP TABLE users;
 	
	
CREATE TABLE user(
	userid INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	, username VARCHAR(30) NOT NULL 
	, authflg CHAR(1) DEFAULT 0
	, birthday DATE NOT NULL
-- , created_at `user`DATETIME DEFAULT CURRENT_TIMESTAMP()
-- 	, created_at DATETIME DEFAULT (CURDATE())
);
	

	
--	[11]에서 만든 테이블에 아래 데이터를 입력해 주세요.
-- 문제에 하라는 대로 다하세요

-- 유저id : 자동증가
-- 유저 이름 : ‘그린’
-- AuthFlg : ‘0’
-- 생일 : 2024-01-26
-- 생성일 : 오늘 날짜
-- 
-- ALTER TABLE users
-- ADD COLUMN username VARCHAR(30)
-- ;
-- 

-- 유저 이름 : ‘테스터’
-- AuthFlg : ‘1’
-- 생일 : 2007-03-01

INSERT INTO users (`username`, authFlg, birthday)
VALUES ('테스터', 1,  '2007-03-01');


ALTER TABLE users;

UPDATE users
SET username = '테스터';

UPDATE users
SET authFlg = 1;

UPDATE users
SET birthday = '2007-03-01';	


ALTER TABLE users
DROP COLUMN 
;

DELETE FROM users
	WHERE userid = 1; 

ALTER TABLE users
ADD COLUMN addr VARCHAR(100) NOT NULL DEFAULT -;
	
	
CREATE TABLE users(
userid INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, username VARCHAR(30) NOT NULL 
, authflg CHAR(1) DEFAULT 0
, birthday DATE NOT NULL
, created_at DATETIME DEFAULT CURRENT_TIMESTAMP()
);

-- 하나씩 출력하는 법 

SELECT * 
FROM users 
WHERE `username` = 'green';

SELECT 
	birthday 
FROM users 
WHERE users.birthday
	AND `username` = 'green';

SELECT 
	rankm.rankid
FROM users 
	JOIN rankmanagement rankm
	ON users.userid = rankm.userid
	AND users.birthday = '2024-01-26'
;

-- -------------------------------------------------

-- 한꺼번에 출력하는 법  

SELECT
	users.username
	,users.birthday
	,rankm.rankid
FROM users	
	JOIN rankmanagement rankm
		ON users.userid = rankm.userid
		AND users.birthday = '2024-01-26'
		AND users.username = 'green'
		AND rankm.rankname = 'manager'
GROUP BY 
	users.username 
	,users.birthday
	,rankm.rankid
;





-- users 테이블 생성
CREATE TABLE users(
	userid INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	,`username` VARCHAR(30) NOT NULL
	,authflg CHAR(1) DEFAULT '0'
	,birthday DATE NOT NULL
	,created_at DATETIME DEFAULT CRE
);
-- rankmanagement 테이블 생성
CREATE TABLE rankmanagement(
	rankid INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	,userid INT UNSIGNED NOT NULL
	,`rankname` VARCHAR(30) NOT NULL
);



SELECT 
   users.username
	,users.birthday
	,rankm.rankname
FROM users 
	JOIN rankmanagement rankm
	ON users.userid = rankm.userid
	AND users.birthday = '2024-01-26'
;
















	