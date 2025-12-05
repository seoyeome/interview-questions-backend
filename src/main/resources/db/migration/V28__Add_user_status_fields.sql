-- Add status management fields to users table

ALTER TABLE users
ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
ADD COLUMN last_login_at TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP,
ADD COLUMN retention_until TIMESTAMP;

-- Create index for status field (for efficient queries)
CREATE INDEX idx_users_status ON users(status);

-- Create index for retention_until (for cleanup batch job)
CREATE INDEX idx_users_retention_until ON users(retention_until);

-- Add comment for documentation
COMMENT ON COLUMN users.status IS 'User account status: ACTIVE, DEACTIVATED, SUSPENDED, DELETED';
COMMENT ON COLUMN users.last_login_at IS 'Last login timestamp';
COMMENT ON COLUMN users.deleted_at IS 'When user was deactivated/deleted';
COMMENT ON COLUMN users.retention_until IS 'Data retention deadline (for legal compliance)';
