--  DB 생성

CREATE DATABASE mydb;

-- DB 선택

USE mydb;

-- DB 삭제

DROP DATABASE mydb;

-- 스키마: CREATE(생성), ALTER(수정), DROP(삭제)

-- --------------
-- 테이블 생성
-- --------------

CREATE TABLE users(
	id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	, `name` VARCHAR(50) NOT NULL COMMENT '이름'
	, gender CHAR(1) NOT NULL COMMENT 'F=여자, M=남자, N=선택안함(대문자로 적을 것)'
	, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	, updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	, deleted_at DATETIME 
); 

-- 게시글 테이블
-- PK, 유저번호, 제목, 내용, 작성일, 수정일, 삭제일

CREATE TABLE posts(
	id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT
	, user_id BIGINT UNSIGNED NOT NULL COMMENT '개인 고유 번호' 
	, title VARCHAR(50) NOT NULL COMMENT '50자 이내'
	, content VARCHAR(500) COMMENT '500자 이내'
	, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	, updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
	, deleted_at DATETIME 
);


-- --------------
-- 테이블 수정(FK 추가방법)
-- --------------
ALTER TABLE posts
	ADD CONSTRAINT fk_posts_user_id
	FOREIGN KEY (user_id)
	REFERENCES users(id)
-- ON UPDATE SET DEFAULT 
-- ON DELETE CASCADE 이것들도 pg단에서 처리. fk도 잘안씀 
--  - **ON DELETE + 동작**
--    상위 테이블의 값이 삭제될 경우의 동작
--  - **ON UPDATE + 동작**
--    상위 테이블의 값이 수정될 경우의 동작
--  - 이하 설정할 수 있는 동작
--  - **CASCADE** : 하위 테이블의 데이터도 같이 삭제 또는 수정
--       - **SET NULL** : 하위 테이블의 데이터는 NULL로 변경
--       - **NO ACTION** : 하위 테이블의 데이터는 유지
--       - **SET DEFAULT** : 하위 테이블의 데이터는 필드의 기본값으로 설정
--       - **RESTRICT** : 하위 테이블에 데이터가 남아 있으면, 상위 테이블의 데이터를 삭제하거나 수정 불가	
;


-- FK 삭제
ALTER TABLE posts 
DROP CONSTRAINT fk_posts_user_id
;

-- --------------
-- 컬럼 추가
-- --------------
ALTER TABLE posts 
ADD COLUMN image VARCHAR(100) 
;  


-- --------------
-- 컬럼 제거
-- --------------
ALTER TABLE posts
DROP COLUMN image
;


-- --------------
-- 컬럼 수정
-- --------------
ALTER TABLE users
MODIFY COLUMN gender VARCHAR(10) NOT NULL COMMENT '남자, 여자, 말 안함'
;

-- --------------
-- AUTO_INCREMENT 값 변경
-- --------------
ALTER TABLE users AUTO_INCREMENT = 10;


-- --------------
-- 테이블 삭제
-- --------------
DROP TABLE posts;
DROP TABLE users;


-- --------------
-- 테이블의 모든 데이터 삭제
-- --------------
-- TRUNCATE TABLE salaries 이력도 없는 DDL 친구 













