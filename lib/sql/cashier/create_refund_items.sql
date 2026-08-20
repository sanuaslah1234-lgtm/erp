CREATE TABLE IF NOT EXISTS refund_items (
    id SERIAL PRIMARY KEY,
    refund_id INT NOT NULL REFERENCES refunds(id) ON DELETE CASCADE,
    order_item_id INT NOT NULL REFERENCES pos_order_items(id),
    product_id INT NOT NULL REFERENCES products(id),
    quantity NUMERIC(12,3) NOT NULL,
    refund_amount NUMERIC(12,2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_refund_items_refund_id ON refund_items(refund_id);
