-- 튜토리얼 완료 여부 컬럼 추가
ALTER TABLE users
ADD COLUMN tutorial_completed BOOLEAN NOT NULL DEFAULT FALSE;

-- 기존 사용자는 튜토리얼 완료 처리 (optional - 필요시 주석 해제)
-- UPDATE users SET tutorial_completed = TRUE WHERE created_at < NOW();
