-- WMS Database Schema
-- Author: Shivam Kumar
-- Description: Core relational schema for Warehouse Management System.

-- ====================================
-- 1. Products
-- ====================================
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    unit_price DECIMAL(10,2) NOT NULL
);

-- ====================================
-- 2. Clients
-- ====================================
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ====================================
-- 3. Inventory
-- One row per product tracking current stock.
-- ====================================
CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index to speed look‑ups by quantity or updates
CREATE INDEX idx_inventory_quantity ON inventory(quantity);

-- ====================================
-- 4. Orders
-- ====================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(client_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'PENDING'
);

CREATE INDEX idx_orders_date ON orders(order_date);

-- ====================================
-- 5. Order Items
-- Line items belonging to an order.
-- ====================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL
);

CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_order_items_order   ON order_items(order_id);

-- ====================================
-- Sample Analytical Queries
-- ====================================

-- Q1: Current stock value per product
/*
SELECT 
    p.sku,
    p.name,
    i.quantity,
    (i.quantity * p.unit_price) AS stock_value
FROM inventory i
JOIN products p ON p.product_id = i.product_id
ORDER BY stock_value DESC;
*/

-- Q2: Orders with client info in the last 30 days
/*
SELECT
    o.order_id,
    o.order_date,
    c.name          AS client_name,
    SUM(oi.quantity) AS total_items
FROM orders o
JOIN clients c   ON c.client_id = o.client_id
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY o.order_id, c.name
ORDER BY o.order_date DESC;
*/

-- Q3: Top 5 products by units sold
/*
SELECT
    p.sku,
    p.name,
    SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.sku, p.name
ORDER BY units_sold DESC
LIMIT 5;
*/