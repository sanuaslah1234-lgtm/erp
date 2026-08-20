CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    name VARCHAR(255) NOT NULL,

    sku VARCHAR(100) NOT NULL UNIQUE,

    description TEXT,

    price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    cost_price NUMERIC(12, 2) NOT NULL DEFAULT 0,

    category_id UUID,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS products_name_idx
ON products(name);

CREATE INDEX IF NOT EXISTS products_sku_idx
ON products(sku);