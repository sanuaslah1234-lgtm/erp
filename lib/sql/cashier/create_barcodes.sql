CREATE TABLE IF NOT EXISTS barcodes (
    id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(id),
    barcode VARCHAR(100) NOT NULL,
    label_quantity INT NOT NULL DEFAULT 1,
    created_by INT REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_barcodes_product_id ON barcodes(product_id);
