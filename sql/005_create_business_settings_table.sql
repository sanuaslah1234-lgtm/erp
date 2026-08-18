-- ============================================================
-- BUSINESS_SETTINGS TABLE
-- Single-row table (id is always 1) — Business Profile tab only.
-- Other tabs (Localization & Finance, Invoicing & Sales, Inventory & POS,
-- Security & System) can extend this table later once their fields
-- are designed — this migration only covers what was in the screenshots.
-- ============================================================

CREATE TABLE IF NOT EXISTS business_settings (
    id                     INT PRIMARY KEY DEFAULT 1 CHECK (id = 1), -- enforces single row
    company_logo_base64    TEXT,
    company_name           VARCHAR(150) NOT NULL DEFAULT '',
    legal_trade_name       VARCHAR(150),
    tax_vat_number         VARCHAR(100),
    official_email         VARCHAR(150),
    business_phone         VARCHAR(30),
    headquarters_address   TEXT,
    updated_at             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Seed the one row with your existing defaults so the page isn't empty.
INSERT INTO business_settings (
    id, company_name, legal_trade_name, tax_vat_number,
    official_email, business_phone, headquarters_address
)
VALUES (
    1, 'afsalkkkaaaaaa', 'ERP Enterprise Solutions Inc.', 'TAX-99887766',
    'support@erp-enterprise.com', '+1 (555) 019-2834',
    '100 Innovation Way, Suite 400, Tech Park, NY 10001'
)
ON CONFLICT (id) DO NOTHING;