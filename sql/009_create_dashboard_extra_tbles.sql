-- ============================================================
-- DASHBOARD SUPPORT TABLES
-- These power the parts of "Retail Executive Overview" that have no
-- natural home in existing tables (upcoming events, highlighted
-- performer/SKU, approvals, notices, to-dos). Everything else on this
-- dashboard (stat cards, revenue chart, top categories, stock health,
-- earnings trend) is computed live from your EXISTING tables:
-- products, categories, employees, users, sales_orders, inventory_items.
-- ============================================================

-- Upcoming operational events (supplier restocks, stock audits, etc.)
CREATE TABLE IF NOT EXISTS dashboard_events (
    id          SERIAL PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    location    VARCHAR(150),
    event_date  DATE NOT NULL,
    start_time  VARCHAR(20),
    end_time    VARCHAR(20),
    accent      VARCHAR(20) NOT NULL DEFAULT 'blue', -- blue | red (matches the colored left-border in the card)
    created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Single-row: whatever the admin currently wants highlighted as
-- "Top performer" and "Best-selling SKU". Real, editable, just not
-- auto-computed from transactions yet (that needs a cashier/employee
-- link on sales_orders which doesn't exist in the schema yet).
CREATE TABLE IF NOT EXISTS dashboard_highlights (
    id                    INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    top_performer_name    VARCHAR(150),
    top_performer_role    VARCHAR(150),
    best_selling_sku_name     VARCHAR(200),
    best_selling_sku_category VARCHAR(100),
    best_selling_sku_units    INT,
    updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Pending approvals (leave requests, shift swaps, etc.)
CREATE TABLE IF NOT EXISTS dashboard_approvals (
    id            SERIAL PRIMARY KEY,
    employee_name VARCHAR(150) NOT NULL,
    request_type  VARCHAR(50)  NOT NULL, -- e.g. Leave, Shift swap
    role_label    VARCHAR(100),
    request_date  VARCHAR(50),
    status        VARCHAR(20)  NOT NULL DEFAULT 'pending', -- pending | approved | rejected
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Notice board announcements
CREATE TABLE IF NOT EXISTS dashboard_notices (
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(200) NOT NULL,
    added_on   DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- To-do items with a real, toggleable completion state
CREATE TABLE IF NOT EXISTS dashboard_todos (
    id         SERIAL PRIMARY KEY,
    title      VARCHAR(200) NOT NULL,
    due_label  VARCHAR(50),
    is_done    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- SEED DATA matching your screenshots
-- ============================================================

INSERT INTO dashboard_events (title, location, event_date, start_time, end_time, accent) VALUES
  ('Supplier Restock', 'Main Warehouse', '2026-08-18', '09:10 AM', '10:30 AM', 'blue'),
  ('Stock Audit', 'Main Branch', '2026-08-21', '11:00 AM', '01:00 PM', 'red')
ON CONFLICT DO NOTHING;

INSERT INTO dashboard_highlights (id, top_performer_name, top_performer_role, best_selling_sku_name, best_selling_sku_category, best_selling_sku_units)
VALUES (1, 'Rasha M.', 'Store Manager, Hawally', 'Al Marai Milk 1L', 'Groceries', 1204)
ON CONFLICT (id) DO NOTHING;

INSERT INTO dashboard_approvals (employee_name, request_type, role_label, request_date, status) VALUES
  ('Fahad K.', 'Leave', 'Warehouse Lead', '12-13 May', 'pending'),
  ('Meera S.', 'Shift swap', 'Cashier', '14 May', 'pending')
ON CONFLICT DO NOTHING;

INSERT INTO dashboard_notices (title, added_on) VALUES
  ('New pricing policy rollout', '2026-08-11'),
  ('Ramadan stock planning kickoff', '2026-08-05'),
  ('Supplier contract renewals due', '2026-07-28')
ON CONFLICT DO NOTHING;

INSERT INTO dashboard_todos (title, due_label, is_done) VALUES
  ('Confirm delivery slot — Al Rai', '01:00 PM', TRUE),
  ('Review low-stock alerts', '03:30 PM', FALSE),
  ('Approve leave — 2 employees', '04:50 PM', FALSE)
ON CONFLICT DO NOTHING;