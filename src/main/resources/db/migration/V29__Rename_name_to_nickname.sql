-- 사용자 테이블의 name 컬럼을 nickname으로 변경
ALTER TABLE users RENAME COLUMN name TO nickname;

-- profile_image_url 컬럼 삭제 (사용하지 않음)
ALTER TABLE users DROP COLUMN IF EXISTS profile_image_url;
