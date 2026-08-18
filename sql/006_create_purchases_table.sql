-- ============================================================
-- PURCHASES TABLE — powers Purchase Reports
-- ============================================================

CREATE TABLE IF NOT EXISTS purchases (
    id             SERIAL PRIMARY KEY,
    po_number      VARCHAR(50)   NOT NULL UNIQUE,
    supplier_name  VARCHAR(150)  NOT NULL,
    subtotal       NUMERIC(12,2) NOT NULL DEFAULT 0,
    tax            NUMERIC(12,2) NOT NULL DEFAULT 0,
    total          NUMERIC(12,2) NOT NULL DEFAULT 0,
    status         VARCHAR(20)   NOT NULL DEFAULT 'completed', -- completed | pending | cancelled
    branch_id      INT,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_purchases_created_at ON purchases (created_at);
CREATE INDEX IF NOT EXISTS idx_purchases_supplier    ON purchases (supplier_name);

INSERT INTO purchases (po_number, supplier_name, subtotal, tax, total, status, created_at)
VALUES
  ('PO-2001', 'Global Coffee Supplies', 2000.00, 200.00, 2200.00, 'completed', NOW() - INTERVAL '3 days'),
  ('PO-2002', 'Fresh Dairy Co.',        850.00,  85.00,  935.00,  'completed', NOW() - INTERVAL '7 days'),
  ('PO-2003', 'Packaging Partners',     420.00,  42.00,  462.00,  'pending',   NOW() - INTERVAL '1 day'),
  ('PO-2004', 'Global Coffee Supplies', 1300.00, 130.00, 1430.00, 'cancelled', NOW() - INTERVAL '12 days')
ON CONFLICT (po_number) DO NOTHING;