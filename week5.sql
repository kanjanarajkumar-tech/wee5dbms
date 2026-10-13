CREATE DATABASE IF NOT EXISTS NICHE;
USE NICHE;

CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(50) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100) UNIQUE
);

CREATE TABLE Product (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2),
    Stock INT
);

CREATE TABLE Orders (
    Order_ID INT PRIMARY KEY,
    Customer_ID INT NOT NULL,
    Order_Date DATE,
    Total_Amount DECIMAL(10,2),
    Order_Status VARCHAR(20),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);

CREATE TABLE Payment (
    Payment_ID VARCHAR(10) PRIMARY KEY,
    Order_ID INT UNIQUE NOT NULL,
    Payment_Date DATE NOT NULL,
    Payment_Mode VARCHAR(30) NOT NULL,
    Payment_Status VARCHAR(20) NOT NULL,
    Transaction_Amount DECIMAL(10,2) NOT NULL CHECK (Transaction_Amount > 0),
    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    CHECK (Payment_Mode IN ('UPI', 'Credit Card', 'Debit Card', 'Net Banking', 'Cash on Delivery')),
    CHECK (Payment_Status IN ('Success', 'Failed', 'Pending'))
);

INSERT INTO Customer VALUES
(101, 'Rahul', '9876543210', 'rahul@gmail.com'),
(102, 'Priya', '9876543211', 'priya@gmail.com'),
(103, 'Arun', '9876543212', 'arun@gmail.com');

INSERT INTO Product VALUES
(201, 'Laptop', 50000, 10),
(202, 'Mouse', 500, 50),
(203, 'Mobile', 20000, 20);

INSERT INTO Orders VALUES
(5001, 101, '2026-10-01', 51000, 'Delivered'),
(5002, 102, '2026-10-02', 20000, 'Shipped'),
(5003, 101, '2026-10-03', 2000, 'Delivered');

INSERT INTO Payment VALUES
('P101', 5001, '2026-10-01', 'UPI', 'Success', 51000),
('P102', 5002, '2026-10-02', 'Credit Card', 'Failed', 20000),
('P103', 5003, '2026-10-03', 'Debit Card', 'Success', 2000);

UPDATE Payment
SET Payment_Status = 'Success'
WHERE Payment_ID = 'P102';

SELECT * FROM Payment;

SELECT * FROM Payment
WHERE Payment_Status = 'Success';

SELECT * FROM Payment
WHERE Payment_Status = 'Failed';

SELECT * FROM Payment
WHERE Payment_Status = 'Pending';

SELECT Payment_Status, COUNT(*) AS Total
FROM Payment
GROUP BY Payment_Status;

SELECT Payment_Mode, COUNT(*) AS Total
FROM Payment
GROUP BY Payment_Mode;

SELECT Payment_Mode, COUNT(*) AS Total
FROM Payment
GROUP BY Payment_Mode
ORDER BY Total DESC
LIMIT 1;

SELECT SUM(Transaction_Amount) AS Total_Revenue
FROM Payment
WHERE Payment_Status = 'Success';

SELECT Payment_Mode, SUM(Transaction_Amount) AS Revenue
FROM Payment
WHERE Payment_Status = 'Success'
GROUP BY Payment_Mode;

SELECT AVG(Transaction_Amount) AS Average_Amount
FROM Payment
WHERE Payment_Status = 'Success';

SELECT COUNT(*) AS UPI_Payments
FROM Payment
WHERE Payment_Mode = 'UPI';

SELECT COUNT(*) AS Card_Payments
FROM Payment
WHERE Payment_Mode IN ('Credit Card', 'Debit Card');

SELECT C.Customer_Name, O.Order_ID,
       P.Payment_Mode, P.Transaction_Amount,
       P.Payment_Status
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID;

SELECT C.Customer_Name, P.Payment_ID,
       P.Order_ID, P.Payment_Date,
       P.Payment_Mode, P.Transaction_Amount,
       P.Payment_Status
FROM Customer C
JOIN Orders O ON C.Customer_ID = O.Customer_ID
JOIN Payment P ON O.Order_ID = P.Order_ID;

UPDATE Payment
SET Payment_Status = 'Success'
WHERE Payment_ID = 'P102'
AND Payment_Status = 'Failed';

DELETE FROM Payment
WHERE Payment_ID = 'P102'
AND Payment_Status = 'Failed';