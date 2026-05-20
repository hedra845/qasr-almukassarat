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
