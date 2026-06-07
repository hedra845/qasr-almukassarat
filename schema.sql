-- Database Schema for Qasr Al-Mukassarat (قصر المكسرات)

-- 1. Categories Table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    emoji VARCHAR(10),
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Products Table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    old_price DECIMAL(10, 2),
    weight VARCHAR(50),
    emoji VARCHAR(10), -- Using emoji for now as in the original code
    image_url TEXT,    -- For future use with real images
    badge VARCHAR(50), -- 'hot', 'new', 'sale', etc.
    rating DECIMAL(2, 1) DEFAULT 5.0,
    reviews_count INTEGER DEFAULT 0,
    stock_quantity INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. Orders Table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(255) NOT NULL,
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    payment_method VARCHAR(50) NOT NULL, -- 'cod', 'card', 'instapay'
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_fee DECIMAL(10, 2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'pending', -- 'pending', 'processing', 'shipped', 'delivered', 'cancelled'
    promo_code VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Order Items Table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL,
    price_at_purchase DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Contact Messages Table
CREATE TABLE contact_messages (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    subject VARCHAR(255),
    message TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'unread', -- 'unread', 'read', 'replied'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Newsletter Subscriptions
CREATE TABLE newsletter_subscriptions (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Initial Data (Seeding)
INSERT INTO categories (name, slug, emoji) VALUES 
('مكسرات', 'nuts', '🥜'),
('فواكه مجففة', 'dried', '🍇'),
('حلويات', 'candy', '🍬'),
('شوكولاتة', 'chocolate', '🍫'),
('هدايا مشكلة', 'mix', '🎁');

INSERT INTO products (category_id, (SELECT id FROM categories WHERE slug = 'nuts'), 'مكسرات مشكلة فاخرة', 149, NULL, '500g', '🥜', 'hot', 5, 234);
-- Note: Fixed the insert to use proper relations if needed, but for simplicity:
-- This is just a schema template.

-- 7. Store Settings Table
CREATE TABLE store_settings (
    id SERIAL PRIMARY KEY,
    key VARCHAR(100) UNIQUE NOT NULL,
    value TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Insert Default Settings
INSERT INTO store_settings (key, value) VALUES 
('phone', '01551407492'),
('address', 'القاهرة، مصر'),
('facebook', ''),
('instagram', ''),
('tiktok', '');

-- 8. Coupons Table
CREATE TABLE IF NOT EXISTS coupons (
    id SERIAL PRIMARY KEY,
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_percent INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. Shipping Zones Table
CREATE TABLE IF NOT EXISTS shipping_zones (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 10. Best Sellers Table
CREATE TABLE IF NOT EXISTS best_sellers (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE UNIQUE,
    sales_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =======================================================
-- Row Level Security (RLS) Configuration & Policies
-- Run these commands in your Supabase SQL Editor to fix authorization/permission errors
-- =======================================================

-- Enable RLS on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE newsletter_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE store_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_zones ENABLE ROW LEVEL SECURITY;
ALTER TABLE best_sellers ENABLE ROW LEVEL SECURITY;

-- 1. Policies for 'best_sellers'
CREATE POLICY "Allow public read access on best_sellers" ON best_sellers FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on best_sellers" ON best_sellers FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on best_sellers" ON best_sellers FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on best_sellers" ON best_sellers FOR DELETE TO authenticated USING (true);

-- 2. Policies for 'categories'
CREATE POLICY "Allow public read access on categories" ON categories FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on categories" ON categories FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on categories" ON categories FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on categories" ON categories FOR DELETE TO authenticated USING (true);

-- 3. Policies for 'products'
CREATE POLICY "Allow public read access on products" ON products FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on products" ON products FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on products" ON products FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on products" ON products FOR DELETE TO authenticated USING (true);

-- 4. Policies for 'orders'
CREATE POLICY "Allow public insert on orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated select on orders" ON orders FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated update on orders" ON orders FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on orders" ON orders FOR DELETE TO authenticated USING (true);

-- 5. Policies for 'order_items'
CREATE POLICY "Allow public insert on order_items" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated select on order_items" ON order_items FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated update on order_items" ON order_items FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on order_items" ON order_items FOR DELETE TO authenticated USING (true);

-- 6. Policies for 'contact_messages'
CREATE POLICY "Allow public insert on contact_messages" ON contact_messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated select on contact_messages" ON contact_messages FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated update on contact_messages" ON contact_messages FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on contact_messages" ON contact_messages FOR DELETE TO authenticated USING (true);

-- 7. Policies for 'newsletter_subscriptions'
CREATE POLICY "Allow public insert on newsletter_subscriptions" ON newsletter_subscriptions FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow authenticated select on newsletter_subscriptions" ON newsletter_subscriptions FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated update on newsletter_subscriptions" ON newsletter_subscriptions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on newsletter_subscriptions" ON newsletter_subscriptions FOR DELETE TO authenticated USING (true);

-- 8. Policies for 'store_settings'
CREATE POLICY "Allow public read access on store_settings" ON store_settings FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on store_settings" ON store_settings FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on store_settings" ON store_settings FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on store_settings" ON store_settings FOR DELETE TO authenticated USING (true);

-- 9. Policies for 'coupons'
CREATE POLICY "Allow public read access on coupons" ON coupons FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on coupons" ON coupons FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on coupons" ON coupons FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on coupons" ON coupons FOR DELETE TO authenticated USING (true);

-- 10. Policies for 'shipping_zones'
CREATE POLICY "Allow public read access on shipping_zones" ON shipping_zones FOR SELECT USING (true);
CREATE POLICY "Allow authenticated insert on shipping_zones" ON shipping_zones FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "Allow authenticated update on shipping_zones" ON shipping_zones FOR UPDATE TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Allow authenticated delete on shipping_zones" ON shipping_zones FOR DELETE TO authenticated USING (true);
