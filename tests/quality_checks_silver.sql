/*
==================================================================================================
Quality Checks
==================================================================================================
Script Purpose:

This script runs a set of data quality checks against the "silver" schema to validate
consistency, completeness, and correctness of the loaded data.

Checks included:
- Null or duplicate primary keys
- Leading/trailing whitespace in text fields
- Value range and format validation (dates, numeric fields)
- Logical date ordering (start <= end)
- Cross-field consistency (related fields that must align)

Usage:
- Run these checks after loading data into the silver layer.
- Investigate and resolve any rows returned by the queries.
==================================================================================================
*/

--
-- Checking table: silver.crm_cust_info
--

-- Verify there are no NULLs or duplicate primary keys (expect no rows returned)
SELECT 
  cst_id,
  COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Identify values with leading or trailing spaces (expect no rows returned)
SELECT
  cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

-- Review distinct values for standardization and allowed values
-- (expect a small, known set of values; investigate unexpected entries)
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

-- Full table preview for manual inspection (use with caution on large tables)
SELECT * FROM silver.crm_cust_info;

--
-- Checking table: silver.crm_prd_info
--

-- Verify there are no NULLs or duplicate primary keys (expect no rows returned)
SELECT
  prd_id,
  COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Find product name or line values with unwanted leading/trailing spaces
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

SELECT prd_line
FROM silver.crm_prd_info
WHERE prd_line != TRIM(prd_line);

-- Check for NULL or negative costs (expect no rows returned)
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost < 0;

-- Review distinct product lines to validate standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for invalid date ranges where end date is before start date
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Full table preview for manual inspection (use with caution on large tables)
SELECT * FROM silver.crm_prd_info;

--
-- Checking table: silver.crm_sales_details
--

-- Validate date values and formats (adjust predicates to match your date encoding)
SELECT
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt = 0 OR sls_order_dt != 8 OR sls_order_dt > 20500101;

-- Check logical ordering of dates: order <= ship <= due
SELECT
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_ship_dt > sls_due_dt;

-- Ensure sales, quantity, and price are present and positive (expect no rows returned)
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
  sls_price;

-- Full table preview for manual inspection (use with caution on large tables)
SELECT * FROM silver.crm_sales_details;

--
-- Checking table: silver.erp_cust_az12
-- (customer master from ERP)
--

-- Verify there are no duplicate customer IDs (expect no rows returned)
SELECT
  CID,
  COUNT(*)
FROM silver.erp_cust_az12
GROUP BY CID
HAVING COUNT(*) > 1;

-- Identify birth dates that are in the future (invalid)
SELECT BDATE
FROM silver.erp_cust_az12
WHERE BDATE > GETDATE();

-- Review distinct gender values to ensure standardization
SELECT DISTINCT GEN
FROM silver.erp_cust_az12;

--
-- Checking table: silver.erp_loc_a101
-- (location/address reference table)
--

-- Verify there are no duplicate location IDs (expect no rows returned)
SELECT
  CID,
  COUNT(*)
FROM silver.erp_loc_a101
GROUP BY CID
HAVING COUNT(*) > 1;

-- Review distinct country codes/names to validate standardization
SELECT DISTINCT CNTRY
FROM silver.erp_loc_a101;
