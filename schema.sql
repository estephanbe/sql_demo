CREATE DATABASE my_store;

USE my_store;

CREATE TABLE Customers (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE Orders (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id INT UNSIGNED,
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(50)
);
