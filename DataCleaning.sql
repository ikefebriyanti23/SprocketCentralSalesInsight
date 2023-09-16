/*KPMG VIRTUAL INTERNSHIP EXPERIENCE*/
/*DATA CLEANING: CustomerAddress*/
--Correcting Inconsistencies in State
SELECT*
FROM CustomerAddress;

UPDATE CustomerAddress
SET state = 
CASE
	WHEN state = 'VIC' THEN 'Victoria'
	WHEN state = 'QLD' THEN 'Queensland'
	WHEN state = 'NSW' THEN 'New South Wales'
	ELSE state
END;

--Check Duplicates
WITH rownum_CTE AS(
SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY customer_id,
				 address
				 ORDER BY customer_id) AS row_num
FROM CustomerAddress)

SELECT*
FROM rownum_CTE
WHERE row_num>1;

/*There are no duplicates in the data*/

/*DATA CLEANING: CustomerDemographic*/
SELECT*
FROM CustomerDemographic;

--Correcting Inconsistencies in Gender
SELECT DISTINCT gender
FROM CustomerDemographic;

-- UPDATE CustomerDemographic
 SET gender = 
 CASE
	WHEN gender = 'F' THEN 'Female'
	WHEN gender = 'Femal' THEN 'Female'
	WHEN gender = 'U' THEN 'Undisclosed'
	WHEN gender = 'M' THEN 'Male'
	ELSE gender
END;

--Correcting Deceased Indicator
UPDATE CustomerDemographic
SET deceased_indicator = 
CASE
	WHEN deceased_indicator = 'N' THEN 'No'
	WHEN deceased_indicator = 'Y' THEN 'Yes'
	ELSE deceased_indicator
END;

SELECT DISTINCT deceased_indicator
FROM CustomerDemographic;

--Concatenate first_name and last_name
ALTER TABLE CustomerDemographic
ADD customer_name nvarchar(255);

UPDATE CustomerDemographic
SET customer_name = CONCAT(first_name,' ',last_name);

--Standardize Date Format
ALTER TABLE CustomerDemographic
ADD customer_dob DATE;

UPDATE CustomerDemographic
SET customer_dob = CONVERT(date,DOB);

--Remove Duplicates
WITH rownum_CTE AS(
SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY customer_name
				 ORDER BY customer_id) AS row_num
FROM CustomerDemographic)

SELECT*
FROM rownum_CTE
WHERE row_num>1;

--Delete Unused Columns
SELECT*
FROM CustomerDemographic;

ALTER TABLE CustomerDemographic
DROP COLUMN first_name, last_name, DOB, [default];

/*DATA CLEANING: NewCustomerList*/
--Concatenate first_name and last_name
ALTER TABLE NewCustomerList
ADD newcustomer_name nvarchar(255);

UPDATE NewCustomerList
SET newcustomer_name = CONCAT (first_name,' ',last_name);

SELECT newcustomer_name
FROM NewCustomerList;

--Standardize DOB Format
SELECT DOB
FROM NewCustomerList;

ALTER TABLE NewCustomerList
ADD customer_dob DATE;

UPDATE NewCustomerList
SET customer_dob=
CASE
	WHEN DOB NOT LIKE '%-%' THEN CAST(DOB-2 AS DATETIME)
	ELSE DOB
END
FROM NewCustomerlist;

--Change gender Format
ALTER TABLE NewCustomerList
ADD newcus_gender nvarchar(50);

UPDATE NewCustomerList
SET newcus_gender = 
CASE
	WHEN gender = 'U' THEN 'Undisclosed'
	ELSE gender
END;

--Change deceased_indicator Format
ALTER TABLE NewCustomerList
ADD deceased_ind nvarchar(10);

UPDATE NewCustomerList
SET deceased_ind = 
CASE
	WHEN deceased_indicator = 'N' THEN 'No'
	ELSE deceased_indicator
END;

--Change state Format
ALTER TABLE NewCustomerList
ADD newcus_state nvarchar(50);

UPDATE NewCustomerList
SET newcus_state =
CASE
	WHEN state = 'VIC' THEN 'Victoria'
	WHEN state = 'QLD' THEN 'Queensland'
	WHEN state = 'NSW' THEN 'New South Wales'
END;

--Remove Duplicates
WITH rownum_CTE AS(
SELECT*,
	ROW_NUMBER() OVER(
	PARTITION BY first_name,
				 last_name,
				 address
				 ORDER BY newcustomer_name) AS rownum
FROM NewCustomerList)

SELECT*
FROM rownum_CTE;

--Delete Unused Columns
ALTER TABLE NewCustomerList
DROP COLUMN first_name, last_name, gender,DOB, deceased_indicator, [state], F17, F18, F19, F20, F21, [rank], [value];

/*DATA CLEANING: Transactions*/
--Change transaction_date Format
ALTER TABLE Transactions
ADD new_transactiondate DATE;

UPDATE Transactions
SET new_transactiondate = CONVERT(DATE,transaction_date);

SELECT*
FROM Transactions;

--Change online_order Format
ALTER TABLE Transactions
ADD new_onlineorder nvarchar(10);

UPDATE Transactions
SET new_onlineorder = CONVERT(nvarchar,online_order);

ALTER TABLE Transactions
ADD onlineorder_inf nvarchar;

SET ANSI_WARNINGS OFF;
UPDATE Transactions
SET onlineorder_inf = 
CASE
	WHEN new_onlineorder = 0 THEN 'False'
	WHEN new_onlineorder = -1 THEN 'True'
	ELSE new_onlineorder
END;
SET ANSI_WARNINGS ON;

--Change product_first_sold_date Format
ALTER TABLE Transactions
ADD product_firstsold_date DATE;

UPDATE Transactions
SET product_firstsold_date = CONVERT(DATE, product_first_sold_date);

SELECT*
FROM Transactions;

--Renewing product data format
ALTER TABLE Transactions
ADD products varchar(255);

UPDATE Transactions
SET products = CONCAT(brand, ': ', product_line, ' (class: ', product_class, ')')

SELECT*
FROM Transactions;

--Remove Duplicates
WITH rownum_CTE AS(
SELECT*, ROW_NUMBER() OVER(
	PARTITION BY transaction_id,
				 new_transactiondate,
	ORDER BY transaction_id) AS row_num
FROM Transactions)

SELECT *
FROM rownum_CTE
WHERE row_num>1;

--Delete Unused Columns
ALTER TABLE Transactions
DROP COLUMN transaction_date, online_order, product_first_sold_date, new_onlineorder, brand, product_line, product_class;

/*DATA CLEANING #2: AGE GROUPING*/
--Customer Demographic Data
--Add New Column age
ALTER TABLE CustomerDemographic
ADD age int;

UPDATE CustomerDemographic
SET age = DATEDIFF(year, customer_dob, '2017/12/31');

SELECT*
FROM CustomerDemographic;

--Add New Column age_group
ALTER TABLE CustomerDemographic
ADD age_group varchar(255);

UPDATE CustomerDemographic
SET age_group =
CASE 
	WHEN age < 20 THEN '<20'
	WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	WHEN age BETWEEN 40 AND 49 THEN '40-49'
	WHEN age BETWEEN 50 AND 59 THEN '50-59'
	WHEN age BETWEEN 60 AND 69 THEN '60-69'
	WHEN age BETWEEN 70 AND 79 THEN '70-79'
	WHEN age > 79 THEN '>79'
END;

SELECT*
FROM CustomerDemographic;

--New Customer List Data
ALTER TABLE NewCustomerList
ADD age int;

UPDATE NewCustomerList
SET age = DATEDIFF(year, customer_dob, '2017/12/31');

SELECT*
FROM NewCustomerList;

--Add New Column age_group
ALTER TABLE NewCustomerList
ADD age_group varchar(255);

UPDATE NewCustomerList
SET age_group =
CASE 
	WHEN age < 20 THEN '<20'
	WHEN age BETWEEN 20 AND 29 THEN '20-29'
	WHEN age BETWEEN 30 AND 39 THEN '30-39'
	WHEN age BETWEEN 40 AND 49 THEN '40-49'
	WHEN age BETWEEN 50 AND 59 THEN '50-59'
	WHEN age BETWEEN 60 AND 69 THEN '60-69'
	WHEN age BETWEEN 70 AND 79 THEN '70-79'
	WHEN age > 79 THEN '>79'
END;

SELECT*
FROM NewCustomerList;
