/*
==================================================================================================
Quality Checks
==================================================================================================
Script Pupose:

This script performs various checks for data consistency, accuracy, and standardization across the
'silver' schema.
It includes checks for:
- Null or duplicate primary keys.
- Unwanted spaces in string fields.
- Data standardization and consistency.
- Invalid date ranges and orders.
- Data consistency between related fields.

Usage Notes:
- Run these checks after data loading silver layer
- Investigate and resilve any discrepancies found during the checks
==================================================================================================
*/

==================================================================================================
-- Checking crm_cust_info Table
==================================================================================================

-- Checking for Nulls or duplicates in Primary Key
-- Expectation: No Results
SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL


-- Check for unwanted spaces
-- Expectation: No Results
SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


-- Data Standardization & Consistency
-- Expectation: No Results
SELECT
DISTINCT cst_marital_status
FROM silver.crm_cust_info

SELECT
DISTINCT cst_gndr
FROM silver.crm_cust_info


SELECT * FROM silver.crm_cust_info

==================================================================================================
-- Checking crm_prd_info Table
==================================================================================================

-- Checking for Nulls or duplicates in Primary Key
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL 


-- Check for unwanted spaces
SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

SELECT
prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line)

-- Check for NULLs or Negative Numbers
SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0


-- Data Standardization & Consistency
SELECT
DISTINCT prd_line
FROM silver.crm_prd_info

-- Check for Invalid Orders
SELECT
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info


==================================================================================================
-- Checking crm_sales_details Table
==================================================================================================
-- Check for invalid dates
SELECT
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt = 0 OR sls_order_dt != 8 OR sls_order_dt > 20500101


-- Check for invalid date orders
SELECT
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_ship_dt > sls_due_dt


-- Check Data Consistency: Between sales, quantity, and price
-- Values should not be NULLs, Zeros and Negatives

SELECT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE 
	sls_sales IS NULL OR sls_sales <= 0
	OR sls_quantity IS NULL OR sls_quantity <= 0
	OR sls_price IS NULL OR sls_price <= 0
ORDER BY 
	sls_sales,
	sls_quantity,
	sls_price
	

SELECT * FROM silver.crm_sales_details


==================================================================================================
-- Checking crm_prd_info Table
==================================================================================================
-- Checking for Nulls or duplicates in Primary Key
-- Expectations: No Results
SELECT
	CID,
	COUNT(*)
FROM silver.erp_cust_az12
GROUP BY CID
HAVING COUNT(*) > 1


-- Out of Range Dates
SELECT
BDATE
FROM silver.erp_cust_az12
WHERE BDATE > GETDATE()

-- Data Standardization & Consistency
SELECT
DISTINCT GEN
FROM silver.erp_cust_az12


==================================================================================================
-- Checking erp_loc_a101 Table
==================================================================================================
-- Checking for Nulls or duplicates in Primary Key
-- Expectations: No Results
SELECT
CID,
COUNT(*)
FROM silver.erp_loc_a101
GROUP BY CID
HAVING COUNT(*) > 1


-- Data Standardization & Consistency
SELECT
DISTINCT CNTRY
FROM silver.erp_loc_a101
