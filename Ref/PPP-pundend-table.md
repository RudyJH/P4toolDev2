--- The goal is to create a dynamic, self-updating database of public individuals.
--- The public individuals intended to be tracked include politicians, opinion writers and celebrities. 
--- Individuals will be tracked with these characteristics referred to as a "PPPProfile":

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
  id           UUID          PRIMARY KEY DEFAULT gen_random_uuid(),
  email        VARCHAR(255)  NOT NULL UNIQUE,
  username     VARCHAR(50)   NOT NULL UNIQUE,
  password_hash TEXT         NOT NULL,
  first_name   VARCHAR(100),
  last_name    VARCHAR(100),
  role         VARCHAR(20)   NOT NULL DEFAULT 'user'
                              CHECK (role IN ('admin', 'user', 'viewer')),
  is_active    BOOLEAN       NOT NULL DEFAULT TRUE,
  created_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW(),
  updated_at   TIMESTAMPTZ   NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_users_email    ON users (email);
CREATE INDEX idx_users_username ON users (username);
CREATE INDEX idx_users_role     ON users (role);

-- Auto-update updated_at
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();