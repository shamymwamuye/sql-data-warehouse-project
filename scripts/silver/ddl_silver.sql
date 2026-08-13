/*
==================================================================================================
DDL Script: Create Silver Tables
==================================================================================================
Script Purpose:
- Define the Silver-layer tables used by the data warehouse ETL pipelines.
- This script drops existing Silver tables (if present) and recreates them with the canonical DDL.

Usage:
- Run in the context of the target database (e.g., the Data Warehouse database).
- This file contains T-SQL batch separators (GO). Execute with a client that 
  recognizes GO (sqlcmd, SSMS, Azure Data Studio).
- Running this script will irreversibly drop the listed tables; back up any production data before running.

Conventions:
- All Silver tables include dwh_create_date (DATETIME2) defaulting to GETDATE() to record load time.
- Column names follow the project naming conventions: <prefix>_<name>.
==================================================================================================
*/

-- Remove and re-create customer master information table (silver.crm_cust_info)
-- Purpose: Customer master information sourced from CRM.
DROP TABLE IF EXISTS silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
	cst_id INT,	
	cst_key NVARCHAR(50),	
	cst_firstname NVARCHAR(50),	
	cst_lastname NVARCHAR(50),	
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),	
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Remove and re-create product master table (silver.crm_prd_info)
-- Purpose: Product master information from CRM/source systems.
DROP TABLE IF EXISTS silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50),
	prd_key NVARCHAR(50),	
	prd_nm NVARCHAR(50),
	prd_cost INT,	
	prd_line NVARCHAR(50),
	prd_start_dt DATE,	
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Remove and re-create sales transaction details (silver.crm_sales_details)
-- Purpose: Sales transaction details ingested from CRM/source systems, cleaned/standardized in Silver
DROP TABLE IF EXISTS silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
	sls_ord_num NVARCHAR(50),	
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt DATE,	
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,	
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Remove and re-create ERP customer demographics table (silver.erp_cust_az12)
-- Purpose: Customer demographic data from ERP (source: erp_cust_az12).
-- Notes: CID is the source system key; BDATE = birth date; GEN = gender.
DROP TABLE IF EXISTS silver.erp_cust_az12;
GO

CREATE TABLE silver.erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE DATE,	
	GEN NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Remove and re-create ERP location table (silver.erp_loc_a101)
-- Purpose: Location / country data from ERP (source: erp_loc_a101).
-- Notes: CID links to customer identifier in ERP; CNTRY stores country name or code.
DROP TABLE IF EXISTS silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
	CID NVARCHAR(50),	
	CNTRY NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO


-- Remove and re-create ERP product/category metadata (silver.erp_px_cat_giv2)
-- Purpose: Product category mapping and metadata from ERP (source: erp_px_cat_giv2).
-- Notes: Contains category/subcategory and maintenance information from the source.
DROP TABLE IF EXISTS silver.erp_px_cat_giv2;
GO

CREATE TABLE silver.erp_px_cat_giv2 (
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);
GO

