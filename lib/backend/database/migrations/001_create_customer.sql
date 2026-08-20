CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    branch_id UUID,

    name VARCHAR(255) NOT NULL,

    phone VARCHAR(50) NOT NULL UNIQUE,

    email VARCHAR(255) UNIQUE,

    address TEXT,

    loyalty_id VARCHAR(100),

    credit_limit NUMERIC(18, 2) NOT NULL DEFAULT 0.00,

    current_balance NUMERIC(18, 2) NOT NULL DEFAULT 0.00,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);