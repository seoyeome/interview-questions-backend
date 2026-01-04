-- V60: Create posts table for community feature

CREATE TABLE posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    view_count INT NOT NULL DEFAULT 0,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX idx_posts_user_id ON posts(user_id);
CREATE INDEX idx_posts_category ON posts(category);
CREATE INDEX idx_posts_created_at ON posts(created_at DESC);
CREATE INDEX idx_posts_deleted_at ON posts(deleted_at) WHERE deleted_at IS NULL;

-- Comments
COMMENT ON TABLE posts IS '커뮤니티 게시글 테이블';
COMMENT ON COLUMN posts.id IS '게시글 ID (UUID)';
COMMENT ON COLUMN posts.user_id IS '작성자 ID';
COMMENT ON COLUMN posts.title IS '게시글 제목';
COMMENT ON COLUMN posts.content IS '게시글 내용';
COMMENT ON COLUMN posts.view_count IS '조회수';
COMMENT ON COLUMN posts.category IS '게시글 카테고리 (QUESTION, FREE)';
COMMENT ON COLUMN posts.deleted_at IS 'Soft delete 시간';
