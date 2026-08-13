/*
==================================================================================================
DDL Script: Create Bronze Tables
==================================================================================================

Purpose:
This script defines the DDL for the 'bronze' schema used as the raw ingestion layer
in the data warehouse. It drops each table if it already exists and re-creates it
with the expected column structure. Use this script when you need to reset or
standardize the bronze layer schemas before loading raw data.

Notes:
- The bronze schema should contain minimally transformed raw source data. Keep
  the table definitions aligned with the incoming source formats.
- Run in a controlled environment only (development or controlled deployment).
  Dropping tables will remove existing data.
==================================================================================================
*/

-- Remove and re-create customer information table from CRM source
DROP TABLE IF EXISTS bronze.crm_cust_info;
GO

CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE
);
GO


-- Remove and re-create product information table from CRM product feed
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);
GO


-- Remove and re-create sales transaction details from CRM sales feed
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);
GO


-- Remove and re-create ERP customer table (source: erp_cust_az12)
DROP TABLE IF EXISTS bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE DATE,
	GEN NVARCHAR(50)
);
GO


-- Remove and re-create ERP location table (source: erp_loc_a101)
DROP TABLE IF EXISTS bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);
GO


-- Remove and re-create ERP product/category metadata (source: erp_px_cat_giv2)
DROP TABLE IF EXISTS bronze.erp_px_cat_giv2;
GO

CREATE TABLE bronze.erp_px_cat_giv2 (
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);
GO
