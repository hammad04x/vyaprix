/* ======================
   DATABASE
   ====================== */
DROP DATABASE IF EXISTS vyaparix;
CREATE DATABASE vyaparix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE vyaparix;

SET FOREIGN_KEY_CHECKS = 0;

/* ======================
   USERS
   ====================== */
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255) NOT NULL UNIQUE,
  password_hash TEXT,
  image VARCHAR(255),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

/* ======================
   ROLES
   ====================== */
CREATE TABLE roles (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

/* ======================
   COMPANIES
   ====================== */
CREATE TABLE companies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  owner_user_id INT NOT NULL,
  name VARCHAR(255),
  email VARCHAR(255),
  phone_number VARCHAR(20),
  gst_number VARCHAR(50),
  address TEXT,
  status ENUM('active','inactive','suspended') DEFAULT 'active',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_companies_owner FOREIGN KEY (owner_user_id) REFERENCES users(id)
) ENGINE=InnoDB;

/* ======================
   BRANCHES
   ====================== */
CREATE TABLE branches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT NOT NULL,
  name VARCHAR(255),
  address TEXT,
  city VARCHAR(100),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_branches_company FOREIGN KEY (company_id) REFERENCES companies(id)
) ENGINE=InnoDB;

/* ======================
   COMPANY USERS
   ====================== */
CREATE TABLE company_users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  company_id INT NOT NULL,
  branch_id INT NULL,
  role_id INT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (role_id) REFERENCES roles(id)
) ENGINE=InnoDB;

/* ======================
   PERMISSIONS
   ====================== */
CREATE TABLE permissions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  permission_key VARCHAR(100) UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE user_permissions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  permission_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (permission_id) REFERENCES permissions(id)
) ENGINE=InnoDB;

/* ======================
   PRODUCT CATEGORIES
   ====================== */
CREATE TABLE product_categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  parent_id INT NULL,
  name VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES product_categories(id)
) ENGINE=InnoDB;

/* ======================
   BRANDS
   ====================== */
CREATE TABLE brands (
  id INT AUTO_INCREMENT PRIMARY KEY,
  parent_id INT NULL,
  name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (parent_id) REFERENCES brands(id)
) ENGINE=InnoDB;

/* ======================
   ATTRIBUTES
   ====================== */
CREATE TABLE attributes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE category_attributes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  category_id INT,
  attribute_id INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES product_categories(id),
  FOREIGN KEY (attribute_id) REFERENCES attributes(id)
) ENGINE=InnoDB;

/* ======================
   PRODUCTS
   ====================== */
CREATE TABLE products (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT NOT NULL,
  category_id INT,
  brand_id INT,
  name VARCHAR(255),
  units VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (category_id) REFERENCES product_categories(id),
  FOREIGN KEY (brand_id) REFERENCES brands(id)
) ENGINE=InnoDB;

/* ======================
   PRODUCT VARIANTS
   ====================== */
CREATE TABLE product_variants (
  id INT AUTO_INCREMENT PRIMARY KEY,
  product_id INT NOT NULL,
  branch_id INT NOT NULL,
  price DECIMAL(10,2),
  quantity INT,
  sku VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (product_id) REFERENCES products(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;

CREATE TABLE variant_attributes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  variant_id INT,
  attribute_id INT,
  attribute_value VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (variant_id) REFERENCES product_variants(id),
  FOREIGN KEY (attribute_id) REFERENCES attributes(id)
) ENGINE=InnoDB;

/* ======================
   CLIENTS
   ====================== */
CREATE TABLE clients (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  branch_id INT,
  shop_name VARCHAR(255),
  name VARCHAR(255),
  phone VARCHAR(20),
  city VARCHAR(100),
  address TEXT,
  credit_limit DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id)
) ENGINE=InnoDB;

/* ======================
   ORDERS
   ====================== */
CREATE TABLE orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  branch_id INT,
  salesman_id INT,
  client_id INT,
  total_amount DECIMAL(10,2),
  status ENUM('paid','unpaid') DEFAULT 'unpaid',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (salesman_id) REFERENCES users(id),
  FOREIGN KEY (client_id) REFERENCES clients(id)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT,
  variant_id INT,
  quantity INT,
  price DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (variant_id) REFERENCES product_variants(id)
) ENGINE=InnoDB;

/* ======================
   INVOICES
   ====================== */
CREATE TABLE invoices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  branch_id INT,
  order_id INT,
  invoice_number VARCHAR(100) UNIQUE,
  invoice_date DATE,
  due_date DATE,
  subtotal DECIMAL(10,2),
  tax_amount DECIMAL(10,2),
  discount DECIMAL(10,2),
  total_amount DECIMAL(10,2),
  status ENUM('unpaid','paid','cancelled') DEFAULT 'unpaid',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB;

CREATE TABLE invoice_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  invoice_id INT,
  variant_id INT,
  product_name VARCHAR(255),
  sku VARCHAR(100),
  quantity INT,
  unit_price DECIMAL(10,2),
  total_price DECIMAL(10,2),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (invoice_id) REFERENCES invoices(id),
  FOREIGN KEY (variant_id) REFERENCES product_variants(id)
) ENGINE=InnoDB;

/* ======================
   SHIPPING
   ====================== */
CREATE TABLE shipping_orders (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT,
  branch_id INT,
  order_id INT,
  invoice_id INT,
  courier_name VARCHAR(255),
  tracking_id VARCHAR(255),
  docket_number VARCHAR(255),
  shipping_charge DECIMAL(10,2),
  shipping_image VARCHAR(255),
  shipping_status ENUM(
    'pending','dispatched','in_transit',
    'delivered','returned','cancelled'
  ) DEFAULT 'pending',
  box_length DECIMAL(10,2),
  box_width DECIMAL(10,2),
  box_height DECIMAL(10,2),
  box_weight DECIMAL(10,2),
  shipped_date DATE,
  delivered_date DATE,
  remarks TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (company_id) REFERENCES companies(id),
  FOREIGN KEY (branch_id) REFERENCES branches(id),
  FOREIGN KEY (order_id) REFERENCES orders(id),
  FOREIGN KEY (invoice_id) REFERENCES invoices(id)
) ENGINE=InnoDB;

/* ======================
   ACTIVE TOKENS (AUTH)
   ====================== */
CREATE TABLE active_tokens (
  id INT AUTO_INCREMENT PRIMARY KEY,
  access_token VARCHAR(500) DEFAULT NULL,
  refresh_token VARCHAR(500) NOT NULL,
  user_id INT NOT NULL,
  ip_address VARCHAR(255) DEFAULT NULL,
  user_agent TEXT DEFAULT NULL,
  access_expires_at DATETIME DEFAULT NULL,
  refresh_expires_at DATETIME DEFAULT NULL,
  last_activity DATETIME DEFAULT NULL,
  is_blacklisted TINYINT(1) NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  INDEX idx_active_tokens_user (user_id),
  INDEX idx_active_tokens_refresh (refresh_token),

  CONSTRAINT fk_active_tokens_user
    FOREIGN KEY (user_id)
    REFERENCES users(id)
    ON DELETE CASCADE
) ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_unicode_ci;


SET FOREIGN_KEY_CHECKS = 1;
