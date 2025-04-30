-- Question 1: Achieving First Normal Form (1NF)

-- Author: [Canaan]
-- Task:
-- The original table 'ProductDetail' contains a 'Products' column
-- with multiple comma-separated values in a single cell.
-- This violates 1NF, which requires that all columns hold atomic (indivisible) values.

-- Step 1: Create a New Table

-- We create a new table named 'ProductDetail_1NF' that conforms to 1NF.
-- Instead of storing multiple products in one cell, each product will have its own row.

CREATE TABLE ProductDetail_1NF (
    OrderID INT,                      -- Unique identifier for the order
    CustomerName VARCHAR(100),        -- Name of the customer
    Product VARCHAR(50)               -- A single product per row (atomic value)
);

-- =========================
-- Step 2: Insert the Records
-- =========================
-- We now insert each product into its own row, grouped by the same OrderID and CustomerName.
-- This removes the repeating group problem and enforces 1NF.

-- Order 101 by John Doe had: Laptop, Mouse
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Laptop');
INSERT INTO ProductDetail_1NF VALUES (101, 'John Doe', 'Mouse');

-- Order 102 by Jane Smith had: Tablet, Keyboard, Mouse
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Tablet');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Keyboard');
INSERT INTO ProductDetail_1NF VALUES (102, 'Jane Smith', 'Mouse');

-- Order 103 by Emily Clark had: Phone
INSERT INTO ProductDetail_1NF VALUES (103, 'Emily Clark', 'Phone');

-- =========================
-- Final Notes:
-- =========================
-- This new structure satisfies the conditions of 1NF:
-- - Each cell contains a single, indivisible value.
-- - There are no repeating groups or arrays.
-- - Data is organized in a tabular format with consistent column types.

-- Output of a SELECT * FROM ProductDetail_1NF would look like:
-- +---------+---------------+----------+
-- | OrderID | CustomerName  | Product  |
-- +---------+---------------+----------+
-- |   101   | John Doe      | Laptop   |
-- |   101   | John Doe      | Mouse    |
-- |   102   | Jane Smith    | Tablet   |
-- |   102   | Jane Smith    | Keyboard |
-- |   102   | Jane Smith    | Mouse    |
-- |   103   | Emily Clark   | Phone    |
-- +---------+---------------+----------+

-- 
-- Question 2: Achieving Second Normal Form (2NF)

-- Problem:
-- The original table 'OrderDetails' contains a partial dependency:
-- CustomerName depends only on OrderID, not the full composite key (OrderID + Product).

-- Solution:
-- Decompose into two tables to remove partial dependency:
-- 1. Orders table (OrderID → CustomerName)
-- 2. OrderItems table (OrderID + Product → Quantity)

-- ----------------------------------------------
-- Step 1: Create the 'Orders' table
-- Stores one row per order and its associated customer.
-- This removes the partial dependency of CustomerName on OrderID.
-- ----------------------------------------------

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,             -- Unique identifier for each order
    CustomerName VARCHAR(100)            -- Customer's name (fully dependent on OrderID)
);

-- Insert data into Orders table
INSERT INTO Orders VALUES (101, 'John Doe');
INSERT INTO Orders VALUES (102, 'Jane Smith');
INSERT INTO Orders VALUES (103, 'Emily Clark');

-- ----------------------------------------------
-- Step 2: Create the 'OrderItems' table
-- Each row corresponds to a product within an order.
-- Product and Quantity are now fully dependent on the composite key (OrderID, Product).
-- ----------------------------------------------

CREATE TABLE OrderItems (
    OrderID INT,                         -- Reference to the order
    Product VARCHAR(50),                 -- Name of the product
    Quantity INT,                        -- Quantity of the product in that order
    PRIMARY KEY (OrderID, Product),      -- Composite primary key
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) -- Establish relationship
);

-- Insert data into OrderItems table
INSERT INTO OrderItems VALUES (101, 'Laptop', 2);
INSERT INTO OrderItems VALUES (101, 'Mouse', 1);
INSERT INTO OrderItems VALUES (102, 'Tablet', 3);
INSERT INTO OrderItems VALUES (102, 'Keyboard', 1);
INSERT INTO OrderItems VALUES (102, 'Mouse', 2);
INSERT INTO OrderItems VALUES (103, 'Phone', 1);

-- ==============================================
-- Final Notes:
-- - We've now removed the partial dependency by separating customer data.
-- - This structure adheres to the rules of 2NF.
-- - All non-key attributes depend on the entire primary key of their respective tables.
