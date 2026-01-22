-- ===========================================================
-- DROP TABLES
-- ===========================================================
DROP TABLE IF EXISTS contain CASCADE;
DROP TABLE IF EXISTS product_category CASCADE;
DROP TABLE IF EXISTS "order" CASCADE;
DROP TABLE IF EXISTS product CASCADE;
DROP TABLE IF EXISTS category CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS "admin" CASCADE;

-- ===========================================================
-- TABLE: CUSTOMER
-- ===========================================================

CREATE TABLE "admin" (
    admin_id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);


-- ===========================================================
-- TABLE: CUSTOMER
-- ===========================================================
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    registration_date TIMESTAMP DEFAULT NOW()
);

-- ===========================================================
-- TABLE: CATEGORY
-- ===========================================================
CREATE TABLE category (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    slug VARCHAR(150) UNIQUE NOT NULL
);

-- ===========================================================
-- TABLE: PRODUCT
-- ===========================================================
CREATE TABLE product (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock INT DEFAULT 0,
    sku VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ===========================================================
-- TABLE: ORDER  (quotes car mot réservé)
-- ===========================================================
CREATE TABLE "order" (
    order_id SERIAL PRIMARY KEY,
    order_date TIMESTAMP DEFAULT NOW(),
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    payment_method VARCHAR(50),
    total_amount NUMERIC(12,2),
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- ===========================================================
-- TABLE ASSOCIATIVE: CONTAIN 
-- ===========================================================
CREATE TABLE contain (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES "order"(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- ===========================================================
-- TABLE ASSOCIATIVE: PRODUCT_CATEGORY
-- ===========================================================
CREATE TABLE product_category (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (category_id) REFERENCES category(category_id)
);

-- ===========================================================
-- TABLE : product_log (table pour tracer les changements sur la table Product)
-- ===========================================================


CREATE TABLE product_log (
    log_id SERIAL PRIMARY KEY,
    product_id INT,
    action VARCHAR(10),
    old_data TEXT,
    new_data TEXT,
    log_date TIMESTAMP DEFAULT NOW()
);

