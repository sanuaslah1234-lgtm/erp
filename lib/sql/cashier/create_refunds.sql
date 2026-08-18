CREATE TABLE IF NOT EXISTS refunds (
    id SERIAL PRIMARY KEY,
    refund_number VARCHAR(50) UNIQUE NOT NULL,
    order_id INT NOT NULL REFERENCES pos_orders(id),
    refund_amount NUMERIC(12,2) NOT NULL,
    refund_method VARCHAR(30) NOT NULL,
    reason TEXT,
    processed_by INT NOT NULL REFERENCES users(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_refunds_order_id ON refunds(order_id);
