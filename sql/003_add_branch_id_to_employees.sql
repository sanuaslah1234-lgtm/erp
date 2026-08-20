-- ============================================================
-- Adds branch assignment to the SHARED employees table.
-- Purely additive — does not touch any existing column or data.
-- Safe to run even though this table is used by other modules too.
-- ============================================================

ALTER TABLE employees
  ADD COLUMN IF NOT EXISTS branch_id INT REFERENCES branches(id) ON DELETE SET NULL;

CREATE INDEX IF NOT EXISTS idx_employees_role      ON employees (role);
CREATE INDEX IF NOT EXISTS idx_employees_branch_id ON employees (branch_id);