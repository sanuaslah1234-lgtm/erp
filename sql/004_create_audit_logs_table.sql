-- ============================================================
-- AUDIT_LOGS TABLE
-- References the SHARED employees table (FK only, no columns touched).
-- ============================================================

CREATE TABLE IF NOT EXISTS audit_logs (
    id            SERIAL PRIMARY KEY,
    employee_id   INT REFERENCES employees(id) ON DELETE SET NULL,
    action        VARCHAR(20)  NOT NULL,  -- LOGIN | LOGOUT | CREATE | UPDATE | DELETE
    module        VARCHAR(30)  NOT NULL,  -- Employee | Branch | Manager | Reports | Auth | Settings
    description   VARCHAR(255) NOT NULL,
    ip_address    VARCHAR(45)  NOT NULL DEFAULT '::1',
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_audit_logs_employee_id ON audit_logs (employee_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at  ON audit_logs (created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_module      ON audit_logs (module);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action      ON audit_logs (action);

-- Sample data so the page shows real activity immediately.
-- Uses whichever employee currently has the lowest id (your first admin/manager account),
-- so this works regardless of what's already in your employees table.
DO $$
DECLARE
  emp_id INT;
BEGIN
  SELECT id INTO emp_id FROM employees ORDER BY id ASC LIMIT 1;

  IF emp_id IS NOT NULL THEN
    INSERT INTO audit_logs (employee_id, action, module, description, ip_address, created_at) VALUES
      (emp_id, 'LOGIN',  'Employee', 'Logged in at 11:00 AM', '::1', NOW() - INTERVAL '4 minutes'),
      (emp_id, 'LOGIN',  'Employee', 'Logged in at 10:13 AM', '::1', NOW() - INTERVAL '51 minutes'),
      (emp_id, 'LOGIN',  'Employee', 'Logged in at 09:31 AM', '::1', NOW() - INTERVAL '1 hour 33 minutes'),
      (emp_id, 'CREATE', 'Branch',   'Created branch HB-1',   '::1', NOW() - INTERVAL '1 day'),
      (emp_id, 'UPDATE', 'Branch',   'Updated branch HB-1',   '::1', NOW() - INTERVAL '2 days')
    ON CONFLICT DO NOTHING;
  END IF;
END $$;