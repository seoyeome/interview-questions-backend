-- AI 사용량 quota 테이블 생성
CREATE TABLE ai_usage_quota (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    usage_date DATE NOT NULL,
    count INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT fk_ai_quota_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 성능 최적화를 위한 복합 인덱스
CREATE INDEX idx_user_date ON ai_usage_quota(user_id, usage_date);
