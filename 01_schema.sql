USE OFML_ProductDB;

-- Tabela produktów bazowych
CREATE TABLE Products (
    product_id VARCHAR(10) NOT NULL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0),
    is_active BIT NOT NULL DEFAULT 1
);

-- Tabela cech konfiguracyjnych
CREATE TABLE Product_Features(
    features_id VARCHAR(10) NOT NULL PRIMARY KEY,
    product_id VARCHAR(10) NOT NULL REFERENCES Products(product_id),
    features_name VARCHAR(50) NOT NULL,
    is_mandatory BIT NOT NULL
);

-- Tabela opcji i wariantów przypisanych do cech
CREATE TABLE Feature_options(
    option_id VARCHAR(10) NOT NULL PRIMARY KEY,
    features_id VARCHAR(10) NOT NULL REFERENCES Product_Features(features_id), 
    option_name VARCHAR(100) NOT NULL,
    sku_code VARCHAR(10) NOT NULL,
    price_delta DECIMAL(10,2) NOT NULL CHECK (price_delta >= 0)
);

-- Tabela wykluczeń
CREATE TABLE Incompatibility_Rules(
    option_id_1 VARCHAR(10) NOT NULL REFERENCES Feature_options(option_id),
    option_id_2 VARCHAR(10) NOT NULL REFERENCES Feature_options(option_id),
    reason VARCHAR(200) NOT NULL,
    CHECK (option_id_1 < option_id_2),
    PRIMARY KEY (option_id_1, option_id_2) 
);