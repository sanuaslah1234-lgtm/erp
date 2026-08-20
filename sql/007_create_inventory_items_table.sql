-- ============================================================
-- INVENTORY_ITEMS TABLE — powers Inventory Reports
-- Inventory is a live snapshot, not a date-ranged transaction log,
-- so there's no "created_at" filtering here — just current stock state.
-- ============================================================

CREATE TABLE IF NOT EXISTS inventory_items (
    id                SERIAL PRIMARY KEY,
    sku               VARCHAR(50)   NOT NULL UNIQUE,
    item_name         VARCHAR(150)  NOT NULL,
    category          VARCHAR(100)  NOT NULL DEFAULT 'Uncategorized',
    quantity_in_stock INT           NOT NULL DEFAULT 0,
    unit_cost         NUMERIC(12,2) NOT NULL DEFAULT 0,
    reorder_level     INT           NOT NULL DEFAULT 10,
    updated_at        TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_inventory_items_category ON inventory_items (category);

INSERT INTO inventory_items (sku, item_name, category, quantity_in_stock, unit_cost, reorder_level)
VALUES
  ('SKU-001', 'Arabica Coffee Beans (1kg)', 'Beverages', 42, 12.50, 15),
  ('SKU-002', 'Whole Milk (1L)',             'Dairy',      8,  1.80, 20),
  ('SKU-003', 'Disposable Cups (100pk)',     'Packaging',  0,  6.00, 10),
  ('SKU-004', 'Sugar Sachets (500pk)',       'Beverages', 60,  4.20, 25),
  ('SKU-005', 'Paper Napkins (200pk)',       'Packaging', 14,  3.10, 15)
ON CONFLICT (sku) DO NOTHING;