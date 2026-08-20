-- ============================================================
-- SALES_ORDERS TABLE
-- Minimal schema so Sales Reports has real data to summarize.
-- This will likely be superseded/extended once the Branch Manager's
-- "Sales Orders" module is built — this is enough for Reports to work now.
-- ============================================================

CREATE TABLE IF NOT EXISTS sales_orders (
    id             SERIAL PRIMARY KEY,
    order_number   VARCHAR(50)   NOT NULL UNIQUE,
    customer_name  VARCHAR(150)  NOT NULL DEFAULT 'Walk-in Customer',
    subtotal       NUMERIC(12,2) NOT NULL DEFAULT 0,
    discount       NUMERIC(12,2) NOT NULL DEFAULT 0,
    total          NUMERIC(12,2) NOT NULL DEFAULT 0,
    status         VARCHAR(20)   NOT NULL DEFAULT 'completed', -- completed | pending | cancelled
    branch_id      INT,
    created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_sales_orders_created_at ON sales_orders (created_at);
CREATE INDEX IF NOT EXISTS idx_sales_orders_customer    ON sales_orders (customer_name);

-- A few sample rows so the Reports page has something to show immediately.
INSERT INTO sales_orders (order_number, customer_name, subtotal, discount, total, status, created_at)
VALUES
  ('SO-1001', 'Walk-in Customer', 500.00, 0.00,  500.00, 'completed', NOW() - INTERVAL '2 days'),
  ('SO-1002', 'Ravi Kumar',       1200.00, 100.00, 1100.00, 'completed', NOW() - INTERVAL '5 days'),
  ('SO-1003', 'Priya Nair',       750.00,  50.00,  700.00, 'completed', NOW() - INTERVAL '10 days'),
  ('SO-1004', 'Walk-in Customer', 300.00,  0.00,   300.00, 'cancelled', NOW() - INTERVAL '1 day')
ON CONFLICT (order_number) DO NOTHING;