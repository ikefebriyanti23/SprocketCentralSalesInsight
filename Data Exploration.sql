/*Data Exploration*/
/*Displaying the Data*/
SELECT*
FROM CustomerDemographic;

SELECT*
FROM CustomerAddress;

SELECT*
FROM Transactions;

SELECT*
FROM NewCustomerList;

/* TOP 10 Products*/
SELECT TOP 10 products, COUNT(*) AS quantity_sold
FROM Transactions
GROUP BY products
ORDER BY quantity_sold DESC;

/*Customer Demographic*/
SELECT dem.gender, dem.age_group, COUNT(*) AS total_purchase
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
WHERE dem.age_group IS NOT NULL
GROUP BY dem.gender, dem.age_group
ORDER BY dem.gender, dem.age_group;

/*Sales Trend in Latest 5 Months*/
ALTER TABLE Transactions
ADD latest_purchase int;

UPDATE Transactions
SET latest_purchase = DATEDIFF(month, new_transactiondate, '2017/12/31');

SELECT latest_purchase, COUNT(*) AS total_transactions
FROM Transactions
WHERE latest_purchase <= 5
GROUP BY latest_purchase
ORDER BY latest_purchase DESC;

/*Total Customers*/
SELECT COUNT (DISTINCT(customer_id)) AS total_customers
FROM Transactions;

/*Total Customers in Past Month*/
SELECT COUNT(DISTINCT(customer_id)) AS customers_past_month
FROM Transactions
WHERE latest_purchase = 0;

/*Show Current Customers*/
SELECT dem.customer_name, dem.job_title, adr.[address], adr.postcode, adr.[state]
FROM CustomerDemographic AS dem
LEFT JOIN CustomerAddress AS adr
ON dem.customer_id = adr.customer_id
WHERE dem.job_title IS NOT NULL AND adr.[address] IS NOT NULL AND adr.[state] IS NOT NULL
ORDER BY adr.postcode, adr.[state];

/*Show Target Customers*/
SELECT newcustomer_name, age_group, [address], newcus_state
FROM NewCustomerList
WHERE age_group IS NOT NULL
ORDER BY postcode, newcus_state;