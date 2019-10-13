DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS receipts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
   ID INT PRIMARY KEY,
   lastName VARCHAR(255),
   firstName VARCHAR(255)
);

CREATE TABLE receipts (
   ReceiptNumber INT PRIMARY KEY,
   Date DATE,
   CustomerId INT,
   FOREIGN KEY (CustomerId) REFERENCES customers (ID)
);

CREATE TABLE goods (
   ID VARCHAR(255) PRIMARY KEY,
   Flavor VARCHAR(255),
   Food VARCHAR(255),
   Price DECIMAL(7, 2)
);

CREATE TABLE items (
   Receipt INT,
   Ordinal INT,
   Item VARCHAR(255),
   FOREIGN KEY (Item) REFERENCES goods (ID),
   FOREIGN KEY (Receipt) REFERENCES receipts (ReceiptNumber),
   PRIMARY KEY (Receipt, Ordinal, Item)
);
