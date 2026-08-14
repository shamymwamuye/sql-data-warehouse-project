/*
===========================================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===========================================================================================
Script Purpose:

This stored procedure performs the ETL (Extract, Transform, Load) process to 
populate the 'silver' tables from the 'bronze' schema.

It performs the following actions:
- Truncates the Silver tables.
- Uses the 'INSERT INTO' statement to load cleaned and transformed data from Bronze into Silver tables.

Parameters:
None

Usage Example:
EXEC silver.load_silver;
===========================================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '=========================================================';
		PRINT 'Loading Silver Layer';
		PRINT '=========================================================';


		PRINT '---------------------------------------------------------';
		PRINT 'Loading CRM Tables';
		PRINT '---------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_cust_info';
		TRUNCATE TABLE silver.crm_cust_info;

		PRINT '>> Inserting Data into: silver.crm_cust_info';
		INSERT INTO silver.crm_cust_info (
			cst_id, 
			cst_key,
			cst_firstname,
			cst_lastname,
			cst_marital_status,
			cst_gndr,
			cst_create_date
		)
		SELECT
			cst_id, 
			cst_key,
			TRIM(cst_firstname) AS cst_firstname, -- Remove unwanted spaces from the first name
			TRIM(cst_lastname) AS cst_lastname, -- Remove unwanted spaces from the last name
			CASE
				WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
				WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
				ELSE 'n/a'
			END AS cst_marital_status, -- Normalize marital status to a readable format
			CASE
				WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
				WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
				ELSE 'n/a'
			END AS cst_gndr, -- Normalize gender to a readable format
			cst_create_date
		FROM
		(
		SELECT 
			*,
			ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL
		) t 
		WHERE flag = 1; -- Select the most recent record per customer

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.crm_prd_info;

		PRINT '>> Inserting Data into: silver.crm_prd_info';
		INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,	
			prd_nm,
			prd_cost,	
			prd_line,	
			prd_start_dt,	
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(TRIM(prd_key), 1, 5), '-', '_') AS cat_id, -- Extract and standardize the category ID
			SUBSTRING(TRIM(prd_key), 7, LEN(prd_key)) AS prd_key, -- Remove the category prefix from the product key
			prd_nm,
			COALESCE(prd_cost, 0) AS prd_cost,
			CASE UPPER(TRIM(prd_line))
				WHEN 'M' THEN 'Mountain'
				WHEN 'R' THEN 'Road'
				WHEN 'S' THEN 'Other Sales'
				WHEN 'T' THEN 'Touring'
				ELSE 'n/a'
			END AS prd_line, -- Map product line codes to descriptive values
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
				AS DATE
				) AS prd_end_dt -- Calculate end date as one day before the next start date
		FROM bronze.crm_prd_info;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_sales_details';
		TRUNCATE TABLE silver.crm_sales_details;

		PRINT '>> Inserting Data into: silver.crm_sales_details';
		INSERT INTO silver.crm_sales_details (
			sls_ord_num,	
			sls_prd_key,
			sls_cust_id,
			sls_order_dt,	
			sls_ship_dt,
			sls_due_dt,
			sls_sales,
			sls_quantity,	
			sls_price
		)
		SELECT
			sls_ord_num,
			sls_prd_key,
			sls_cust_id,
			CASE
				WHEN sls_order_dt = 0 OR LEN(sls_order_dt) <> 8 OR sls_order_dt > 20500101 THEN NULL
				ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
			END AS sls_order_dt,
			CASE
				WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) <> 8 OR sls_ship_dt > 20500101 THEN NULL
				ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
			END AS sls_ship_dt,
			CASE
				WHEN sls_due_dt = 0 OR LEN(sls_due_dt) <> 8 OR sls_due_dt > 20500101 THEN NULL
				ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
			END AS sls_due_dt,
			CASE
				WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)  
					THEN sls_quantity * ABS(sls_price)
				ELSE sls_sales 
			END AS sls_sales, -- Recalculate sales if the original value is missing or incorrect
			sls_quantity,
			CASE
				WHEN sls_price IS NULL OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity, 0)
				ELSE sls_price 
			END AS sls_price -- Derive the price if the original value is invalid
		FROM bronze.crm_sales_details;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';




		PRINT '---------------------------------------------------------';
		PRINT 'Loading ERP Tables';
		PRINT '---------------------------------------------------------';


		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_cust_az12';
		TRUNCATE TABLE silver.erp_cust_az12;

		PRINT '>> Inserting Data into: silver.erp_cust_az12';
		INSERT INTO silver.erp_cust_az12 (
			CID,
			BDATE,
			GEN
		)
		SELECT
			CASE
				WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID)) -- Remove the unwanted 'NAS' prefix from the CID column
				ELSE CID
			END AS CID,
			CASE
				WHEN BDATE > GETDATE() THEN NULL
				ELSE BDATE
			END AS BDATE, -- Handle future birth dates
			CASE
				WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS GEN -- Map gender codes to meaningful values
		FROM bronze.erp_cust_az12;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_loc_a101';
		TRUNCATE TABLE silver.erp_loc_a101;

		PRINT '>> Inserting Data into: silver.erp_loc_a101';
		INSERT INTO silver.erp_loc_a101 (
		CID,
		CNTRY
		)
		SELECT
			REPLACE(CID, '-', '') AS CID,
			CASE
				WHEN UPPER(TRIM(CNTRY)) IN ('DE', 'GERMANY') THEN 'Germany'
				WHEN UPPER(TRIM(CNTRY)) IN ('USA', 'UNITED STATES', 'US') THEN 'United States'
				WHEN TRIM(CNTRY) = '' OR TRIM(CNTRY) IS NULL THEN 'n/a'
				ELSE TRIM(CNTRY)
			END AS CNTRY
		FROM bronze.erp_loc_a101;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';



		SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.erp_px_cat_giv2';
		TRUNCATE TABLE silver.erp_px_cat_giv2;

		PRINT '>> Inserting Data into: silver.erp_px_cat_giv2';
		INSERT INTO silver.erp_px_cat_giv2 (
			ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		)
		SELECT
			REPLACE(ID, '_', '-') AS ID,
			CAT,
			SUBCAT,
			MAINTENANCE
		FROM bronze.erp_px_cat_giv2;

		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '>> -------------';


		SET @batch_end_time = GETDATE();
		PRINT '=========================================================';
		PRINT 'Silver Layer Loading Completed Successfully';
		PRINT '  - Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================================';
	END TRY
	BEGIN CATCH
		PRINT '=========================================================';
		PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================================';

		THROW;
	END CATCH
END;
