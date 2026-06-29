-- : 24 products using LOCAL images (no external CDN cache issues)
-- File location: Cartova/seed_products.sql
-- Run in MySQL Workbench or: mysql -u root  < seed_products.sql

USE ;

CREATE TABLE IF NOT EXISTS products (
    product_id   INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    description  TEXT,
    price        DECIMAL(10, 2) NOT NULL,
    stock        INT NOT NULL DEFAULT 0,
    image_url    VARCHAR(500)
);

DELETE FROM products;
ALTER TABLE products AUTO_INCREMENT = 1;

INSERT INTO products (product_name, description, price, stock, image_url) VALUES
('iPhone 15', 'Apple iPhone 15 with A16 Bionic chip, 48MP camera, and Dynamic Island display.', 79999.00, 45, 'images/products/01-iphone-15.webp'),
('boAt Rockerz 450', 'boAt Rockerz 450 wireless on-ear headphones with 15-hour playback and deep bass.', 1499.00, 120, 'images/products/02-boat-rockerz.webp'),
('City Laptop Backpack', 'Water-resistant laptop backpack with padded compartment and USB charging port.', 2499.00, 80, 'images/products/03-backpack.webp'),
('Smart Watch Pro', 'AMOLED smartwatch with heart-rate monitor, GPS, and 7-day battery life.', 4999.00, 65, 'images/products/04-smartwatch.webp'),
('Samsung Galaxy S24', 'Samsung Galaxy S24 flagship phone with AI camera tools and vivid AMOLED screen.', 74999.00, 38, 'images/products/05-samsung-s24.webp'),
('Sony WH-1000XM5', 'Sony premium noise-cancelling over-ear headphones with 30-hour battery.', 29990.00, 55, 'images/products/06-sony-xm5.webp'),
('boAt Airdopes 141', 'boAt Airdopes 141 true wireless earbuds with ENx noise cancellation.', 1299.00, 200, 'images/products/07-boat-airdopes.webp'),
('MacBook Air M3', 'Apple MacBook Air M3 with 13-inch Liquid Retina display and all-day battery.', 114900.00, 22, 'images/products/08-macbook.webp'),
('Dell XPS 15', 'Dell XPS 15 laptop with Intel Core i7, 16GB RAM, and InfinityEdge display.', 89990.00, 18, 'images/products/09-dell-xps.webp'),
('iPad Pro 11', 'Apple iPad Pro 11-inch with M2 chip, ProMotion display, and Apple Pencil support.', 81900.00, 30, 'images/products/10-ipad.webp'),
('Nike Air Max 90', 'Classic Nike Air Max 90 sneakers with visible Air cushioning and durable outsole.', 8995.00, 90, 'images/products/11-nike-airmax.webp'),
('Levi''s Denim Jacket', 'Levi''s trucker denim jacket with classic fit and premium cotton fabric.', 4599.00, 70, 'images/products/12-levis-jacket.webp'),
('Ray-Ban Aviator', 'Ray-Ban Aviator classic sunglasses with UV protection and metal frame.', 6990.00, 60, 'images/products/13-rayban.webp'),
('Philips Air Fryer', 'Philips digital air fryer with rapid air technology and 4.1L capacity.', 8999.00, 40, 'images/products/14-air-fryer.webp'),
('Instant Pot Duo', 'Instant Pot Duo 7-in-1 electric pressure cooker for fast home cooking.', 7499.00, 35, 'images/products/15-instant-pot.webp'),
('Dyson V15 Detect', 'Dyson V15 Detect cordless vacuum with laser dust detection.', 54900.00, 15, 'images/products/16-dyson-vacuum.webp'),
('Fitbit Charge 6', 'Fitbit Charge 6 fitness tracker with GPS, heart rate, and sleep tracking.', 9999.00, 85, 'images/products/17-fitbit.webp'),
('Premium Yoga Mat', 'Non-slip 6mm yoga mat with carrying strap for home and studio workouts.', 1299.00, 150, 'images/products/18-yoga-mat.webp'),
('L''Oreal Skincare Kit', 'L''Oreal Paris skincare set with cleanser, serum, and moisturizer.', 2499.00, 95, 'images/products/19-loreal-skincare.webp'),
('Chanel Coco Mademoiselle', 'Chanel Coco Mademoiselle eau de parfum with fresh floral fragrance.', 8990.00, 25, 'images/products/20-chanel-perfume.webp'),
('Kindle Paperwhite', 'Amazon Kindle Paperwhite with 6.8-inch glare-free display and weeks of battery.', 13999.00, 50, 'images/products/21-kindle.webp'),
('PlayStation 5 Slim', 'Sony PlayStation 5 Slim console with ultra-fast SSD and DualSense controller.', 54990.00, 12, 'images/products/22-ps5.webp'),
('Canon EOS R50', 'Canon EOS R50 mirrorless camera with 24.2MP sensor and 4K video recording.', 62995.00, 20, 'images/products/23-canon-camera.webp'),
('JBL Flip 6', 'JBL Flip 6 portable Bluetooth speaker with IP67 waterproof rating.', 6999.00, 75, 'images/products/24-jbl-speaker.webp');

SELECT product_id, product_name, image_url FROM products;
