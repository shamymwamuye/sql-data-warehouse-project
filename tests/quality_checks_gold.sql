/*
=========================================================================================
Quality Checks
=========================================================================================
Script Purpose:
This script performs quality checks to validate the integrity, consistency, and accuracy 
of the Gold Layer. These checks ensure:
- Uniqueness of surrogate keys in dimension tables.
- Referential integrity between fact and dimension tables.
- Validation of relationships in the data model for analytical purposes.

Usage Notes:
- Investigate and resolve any discrepancies found during the checks.
=========================================================================================
*/

-- ======================================================================================
-- Checking 'gold.dim_customers'
-- ======================================================================================
-- Check for the uniqueness of customer key in the gold.dim_customers
-- Expectation: No results
SELECT 
  customer_key,
  COUNT(*) As duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1

-- ======================================================================================
-- Checking 'gold.dim_products'
-- ======================================================================================
-- Check for the uniqueness of product key in the gold.dim_products
-- Expectation: No results
SELECT 
  product_key,
  COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1

-- ======================================================================================
-- Checking 'gold.fact_sales'
-- ======================================================================================
-- Check the data model connectivity between fact and dimensions
SELECT 
* 
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
	ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products AS p
	ON f.product_key = p.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
