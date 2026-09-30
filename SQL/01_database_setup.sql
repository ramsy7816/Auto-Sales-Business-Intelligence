Create database auto_sales_analysis;

CREATE TABLE auto_sales (
    ordernumber INT,
    quantityordered INT,
    priceeach DECIMAL(10,2),
    orderlinenumber INT,
    sales DECIMAL(12,2),
    orderdate DATE,
    status VARCHAR(20),
    productline VARCHAR(100),
    msrp DECIMAL(10,2),
    productcode VARCHAR(20),
    customername VARCHAR(150),
    phone VARCHAR(50),
    addressline1 VARCHAR(200),
    city VARCHAR(100),
    postalcode VARCHAR(20),
    country VARCHAR(100),
    contactlastname VARCHAR(100),
    contactfirstname VARCHAR(100),
    dealsize VARCHAR(20),
    year INT,
    month INT,
    month_name VARCHAR(20),
    quarter INT,
    yearMonth VARCHAR(10),
    calculated_sales DECIMAL(12,2),
    sales_difference DECIMAL(12,2),
    discount_amount DECIMAL(10,2),
    percent_discount DECIMAL(10,2)
);

