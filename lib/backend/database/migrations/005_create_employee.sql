-- =========================================================
-- 005_create_employee.sql
-- Employee / User table
-- =========================================================

CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    full_name VARCHAR(150),

    email VARCHAR(255) NOT NULL UNIQUE,

    employee_id VARCHAR(100) UNIQUE,

    phone VARCHAR(30) NOT NULL UNIQUE,

    password_hash TEXT NOT NULL,

    plain_password TEXT,

    is_verified BOOLEAN NOT NULL DEFAULT FALSE,

    first_login BOOLEAN NOT NULL DEFAULT TRUE,

    verification_token TEXT,

    verification_expires TIMESTAMP,

    role VARCHAR(50),

    role_id UUID,

    type VARCHAR(50),

    branch_id UUID,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- INDEXES
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_users_employee_id
ON users(employee_id);

CREATE INDEX IF NOT EXISTS idx_users_role_id
ON users(role_id);

CREATE INDEX IF NOT EXISTS idx_users_branch_id
ON users(branch_id);

CREATE INDEX IF NOT EXISTS idx_users_email
ON users(email);

CREATE INDEX IF NOT EXISTS idx_users_phone
ON users(phone);