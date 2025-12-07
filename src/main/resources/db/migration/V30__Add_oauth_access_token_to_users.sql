-- Add column to store OAuth provider access tokens for unlink operations
ALTER TABLE users
ADD COLUMN IF NOT EXISTS oauth_access_token VARCHAR(500);

-- Optional index if queries filter by this column (cleanup/unlink jobs)
CREATE INDEX IF NOT EXISTS idx_users_oauth_access_token ON users(oauth_access_token);
