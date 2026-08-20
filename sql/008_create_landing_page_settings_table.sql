-- ============================================================
-- LANDING_PAGE_SETTINGS TABLE
-- Single-row table (id is always 1). Images stored as base64 TEXT,
-- same pattern as business_settings' company logo — no file server needed.
-- ============================================================

CREATE TABLE IF NOT EXISTS landing_page_settings (
    id                          INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),

    -- Navbar
    logo_text                   VARCHAR(100) NOT NULL DEFAULT '',
    logo_highlight               VARCHAR(100) NOT NULL DEFAULT '',
    login_button_text            VARCHAR(100) NOT NULL DEFAULT '',

    -- Hero Section
    hero_tag                     VARCHAR(150) NOT NULL DEFAULT '',
    hero_title                   VARCHAR(255) NOT NULL DEFAULT '',
    hero_description             TEXT,
    hero_button_text             VARCHAR(100) NOT NULL DEFAULT '',
    hero_dashboard_image_base64  TEXT,
    hero_background_image_base64 TEXT,
    dashboard_title              VARCHAR(150) NOT NULL DEFAULT '',
    dashboard_subtitle           VARCHAR(255) NOT NULL DEFAULT '',

    -- About Section
    about_tag                    VARCHAR(150) NOT NULL DEFAULT '',
    about_title                  VARCHAR(255) NOT NULL DEFAULT '',
    about_description            TEXT,
    about_image_1_base64         TEXT,
    about_image_2_base64         TEXT,
    about_image_3_base64         TEXT,
    about_image_4_base64         TEXT,

    -- Footer
    footer_text                  VARCHAR(255) NOT NULL DEFAULT '',

    updated_at                   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Seed with your existing screenshot content so the page isn't empty.
INSERT INTO landing_page_settings (
    id, logo_text, logo_highlight, login_button_text,
    hero_tag, hero_title, hero_description, hero_button_text, dashboard_title, dashboard_subtitle,
    about_tag, about_title, about_description, footer_text
)
VALUES (
    1, 'ERP', 'Clouds', 'Login →',
    'CLOUD ERP PLATFORM', 'Run Your Business Smarter.',
    'Manage inventory, products, warehouses, purchases, suppliers, sales, billing, and business operations with a powerful cloud-based ERP system built for modern businesses.',
    'Get Started Today →', 'ERP Dashboard', 'Real-Time Business Overview',
    'ABOUT ERP CLOUD', 'One Platform. Complete Business Control.',
    'ERPCloud brings your entire business into one powerful platform. Manage inventory, billing, products, warehouses, purchases, suppliers, and business operations with real-time visibility and complete control.',
    '© ERP Cloud. All Rights Reserved.'
)
ON CONFLICT (id) DO NOTHING;