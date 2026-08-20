CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS inventory (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    product_id UUID NOT NULL,

    warehouse_id UUID NOT NULL,

    quantity INTEGER NOT NULL DEFAULT 0,

    minimum_stock INTEGER NOT NULL DEFAULT 10,

    maximum_stock INTEGER NOT NULL DEFAULT 1000,

    reorder_level INTEGER NOT NULL DEFAULT 20,

    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT inventory_product_fk
        FOREIGN KEY (product_id)
        REFERENCES products(id)
        ON DELETE CASCADE,

    CONSTRAINT inventory_warehouse_fk
        FOREIGN KEY (warehouse_id)
        REFERENCES warehouses(id)
        ON DELETE CASCADE,

    CONSTRAINT inventory_product_warehouse_unique
        UNIQUE (product_id, warehouse_id)
);

CREATE INDEX IF NOT EXISTS inventory_product_idx
ON inventory(product_id);

CREATE INDEX IF NOT EXISTS inventory_warehouse_idx
ON inventory(warehouse_id);