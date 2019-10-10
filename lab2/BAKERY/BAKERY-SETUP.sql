CREATE TABLE Customer (
   ID INT PRIMARY KEY,
   lastName VARCHAR(255),
   firstName VARCHAR(255)
);

CREATE TABLE Receipt (
   ReceiptNumber INT PRIMARY KEY,
   Date DATE,
   Customer INT,
   FOREIGN KEY (Customer) REFERENCES Customer (ID)
);

CREATE TABLE Good (
   ID INT PRIMARY KEY,
   Flavor VARCHAR(255),
   Food VARCHAR(255),
   Price DECIMAL(7, 2)
);

CREATE TABLE Item (
   Receipt INT,
   Ordinal INT,
   Item Int,
   FOREIGN KEY (Item) REFERENCES Good (ID),
   FOREIGN KEY (Receipt) REFERENCES Receipt (ReceiptNumber),
   PRIMARY KEY (Receipt, Ordinal, Item)
);
