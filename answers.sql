-- question 1
-- property_rental_db.sql
-- Property Rental Management System
-- MySQL (InnoDB, utf8mb4)

-- 1. Create database
CREATE DATABASE property_rental_db
DEFAULT CHARACTER SET = utf8mb4 -- this ensures character set that supports all Unicode characters, including emojis and non-Latin scripts
DEFAULT COLLATE = utf8mb4_unicode_ci; -- this defines how text comparison works for ci is case sensitive enables easier sorting 

USE property_rental_db;

-- 2. Table: owners (property owners/landlords)
CREATE TABLE  owners (
  owner_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(30),
  address TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP -- this column and any other in the query is for storing date and time 
) ENGINE=InnoDB;-- this tells sql engine which use the InnoDB storage engine, which supports: transactions,foreign keys and casacading styles


-- 3. Table: tenants (people renting properties)
CREATE TABLE tenants (
  tenant_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(30),
  id_number VARCHAR(100) UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 4. Table: properties
CREATE TABLE  properties (
  property_id INT AUTO_INCREMENT PRIMARY KEY,
  owner_id INT NOT NULL,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  address TEXT NOT NULL,
  property_type ENUM('apartment','house','condo','office','shop','other') DEFAULT 'apartment', -- for anywhere with enum it means a column that can only take one of the predefined values. for example here the predefined values  -- are 'apartment','house','condo','office','shop','other' but default will be apartment
  status ENUM('available','occupied','maintenance') DEFAULT 'available',
  rent_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (owner_id) REFERENCES owners(owner_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Table: leases (agreement between tenant and property)
CREATE TABLE leases (
  lease_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT NOT NULL,
  tenant_id INT NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  monthly_rent DECIMAL(10,2) NOT NULL,
  status ENUM('active','terminated','expired') DEFAULT 'active',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id) ON DELETE CASCADE ON UPDATE CASCADE,
  UNIQUE KEY uk_property_active_lease (property_id, tenant_id, start_date)
) ENGINE=InnoDB;

-- 6. Table: payments
CREATE TABLE  payments (
  payment_id INT AUTO_INCREMENT PRIMARY KEY,
  lease_id INT NOT NULL,
  amount DECIMAL(10,2) NOT NULL,
  payment_date DATE NOT NULL,
  method ENUM('cash','bank_transfer','mobile_money','card') DEFAULT 'cash',
  status ENUM('pending','completed','failed') DEFAULT 'completed',
  FOREIGN KEY (lease_id) REFERENCES leases(lease_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Table: maintenance_requests
CREATE TABLE maintenance_requests (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT NOT NULL,
  tenant_id INT NULL,
  description TEXT NOT NULL,
  status ENUM('open','in_progress','completed','cancelled') DEFAULT 'open',
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (tenant_id) REFERENCES tenants(tenant_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Table: property_images
CREATE TABLE  property_images (
  image_id INT AUTO_INCREMENT PRIMARY KEY,
  property_id INT NOT NULL,
  image_url VARCHAR(500) NOT NULL,
  uploaded_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Table: agents (managing properties on behalf of owners)
CREATE TABLE agents (
  agent_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(30),
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 10. Junction table: agent_properties (M:N between agents and properties)
CREATE TABLE IF NOT EXISTS agent_properties (
  agent_id INT NOT NULL,
  property_id INT NOT NULL,
  assigned_date DATE NOT NULL DEFAULT (CURRENT_DATE),
  PRIMARY KEY (agent_id, property_id),
  FOREIGN KEY (agent_id) REFERENCES agents(agent_id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (property_id) REFERENCES properties(property_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. Constraints example: lease dates
ALTER TABLE leases
  ADD CONSTRAINT chk_lease_dates CHECK (end_date > start_date);




    