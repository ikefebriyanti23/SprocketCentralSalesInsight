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

/* TOP 5 Products*/
SELECT TOP 5 products, COUNT(*) AS quantity_sold
FROM Transactions
GROUP BY products
ORDER BY quantity_sold DESC;

/*Customer Age Demographic*/
SELECT dem.age_group, COUNT(*) AS total_purchase
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
WHERE dem.age_group IS NOT NULL
GROUP BY dem.age_group
ORDER BY dem.age_group;

--Overall Calculation in Gender
SELECT dem.gender, COUNT(*) AS total_purchase
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
WHERE dem.age_group IS NOT NULL AND dem.gender <> 'Undisclosed'
GROUP BY dem.gender
ORDER BY 2 DESC;

/*Sale per State*/
SELECT adr.[state], COUNT(*) AS purchase_per_state
FROM CustomerDemographic AS dem
LEFT JOIN CustomerAddress AS adr
ON dem.customer_id = adr.customer_id
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
WHERE adr.[state] IS NOT NULL
GROUP BY adr.[state]
ORDER BY 2 DESC;

/*Purchase per Wealth Segment*/
SELECT dem.wealth_segment, COUNT(*) AS total_purchase
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
GROUP BY dem.wealth_segment
ORDER BY 2 DESC;

/*TOP 5 Purchase per Job Industry*/
SELECT TOP 5 dem.job_industry_category, COUNT(*) AS total_purchase
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id
WHERE dem.job_industry_category <> 'n/a'
GROUP BY dem.job_industry_category
ORDER BY 2 DESC;

/*Total Customers and Transactions*/
SELECT COUNT(DISTINCT(tra.customer_id)) AS total_customer, COUNT(*) AS total_transactions
FROM CustomerDemographic AS dem
LEFT JOIN Transactions AS tra
ON dem.customer_id = tra.customer_id;