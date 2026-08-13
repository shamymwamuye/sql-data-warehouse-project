/*
==================================================================================================
DDL Script: Create Bronze Tables
==================================================================================================

Purpose:
This script defines the DDL for the 'bronze' schema used as the raw ingestion layer
in the data warehouse. It drops each table if it already exists and (re)creates it
with the expected column structure and types. Use this script when you need to
reset or standardize the bronze layer schemas before loading raw data.

What changed in this version:
- Ensure the bronze schema exists (SQL Server compatible check).
- Standardized date/time column types (use DATE or DATETIME consistently).
- Converted monetary fields from INT to DECIMAL(18,2).
- Added column-level metadata using SQL Server extended properties (MS_Description).
  Also included Postgres-style COMMENT ON examples (commented) if you prefer Postgres.
- Kept table and column names compatible with upstream sources; no renaming was done.

Notes:
- This file is written for SQL Server (T-SQL) and uses GO batch separators. The
  COMMENT ON examples for Postgres are provided but commented out.
- Adding extended properties will update existing descriptions when present.
- Run in a controlled environment only (development or controlled deployment).
  Dropping tables will remove existing data.
==================================================================================================
*/

-- Create schema if it does not exist (SQL Server)
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'bronze')
BEGIN
    EXEC('CREATE SCHEMA bronze');
END
GO

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

-- Column descriptions (SQL Server extended properties). These update if the property exists.
BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer surrogate identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Customer surrogate identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_id';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source system customer key', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_key';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Source system customer key', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_key';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer first name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_firstname';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Customer first name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_firstname';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer last name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_lastname';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Customer last name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_lastname';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Marital status value from CRM', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_marital_status';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Marital status value from CRM', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_marital_status';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender value from CRM (e.g. M/F/Other)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_gndr';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Gender value from CRM (e.g. M/F/Other)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_gndr';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record creation date in source system', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_create_date';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Record creation date in source system', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'cst_create_date';
END CATCH
GO

-- Remove and re-create product information table from CRM product feed
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    prd_id INT,
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost DECIMAL(18,2),
    prd_line NVARCHAR(50),
    prd_start_dt DATETIME,
    prd_end_dt DATETIME
);
GO

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product surrogate identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product surrogate identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_id';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source product key', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_key';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Source product key', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_key';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_nm';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_nm';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product cost (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_cost';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product cost (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_cost';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product line or category', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_line';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product line or category', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_line';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product availability start datetime', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_start_dt';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product availability start datetime', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_start_dt';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product availability end datetime', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_end_dt';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product availability end datetime', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'prd_end_dt';
END CATCH
GO

-- Remove and re-create sales transaction details from CRM sales feed
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt DATE,
    sls_ship_dt DATE,
    sls_due_dt DATE,
    sls_sales DECIMAL(18,2),
    sls_quantity INT,
    sls_price DECIMAL(18,2)
);
GO

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sales order number', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_ord_num';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Sales order number', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_ord_num';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Product key for the sold item (links to prd_key)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_prd_key';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Product key for the sold item (links to prd_key)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_prd_key';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Customer identifier (links to cst_id)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_cust_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Customer identifier (links to cst_id)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_cust_id';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Order date', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_order_dt';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Order date', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_order_dt';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ship date', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_ship_dt';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Ship date', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_ship_dt';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Due date for payment', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_due_dt';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Due date for payment', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_due_dt';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Total sales amount (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_sales';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Total sales amount (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_sales';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Quantity sold', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_quantity';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Quantity sold', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_quantity';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Unit price (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_price';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Unit price (currency)', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'sls_price';
END CATCH
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

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP customer identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'CID';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'ERP customer identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'CID';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Birth or business date from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'BDATE';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Birth or business date from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'BDATE';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender value from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'GEN';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Gender value from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_cust_az12', @level2type=N'COLUMN', @level2name=N'GEN';
END CATCH
GO

-- Remove and re-create ERP location table (source: erp_loc_a101)
DROP TABLE IF EXISTS bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    CID NVARCHAR(50),
    CNTRY NVARCHAR(50)
);
GO

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP customer identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_loc_a101', @level2type=N'COLUMN', @level2name=N'CID';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'ERP customer identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_loc_a101', @level2type=N'COLUMN', @level2name=N'CID';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Country code or name from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_loc_a101', @level2type=N'COLUMN', @level2name=N'CNTRY';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Country code or name from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_loc_a101', @level2type=N'COLUMN', @level2name=N'CNTRY';
END CATCH
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

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ERP product/category identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'ID';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'ERP product/category identifier', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'ID';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Category name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'CAT';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Category name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'CAT';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Subcategory name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'SUBCAT';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Subcategory name', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'SUBCAT';
END CATCH

BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Maintenance schedule or flag from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'MAINTENANCE';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Maintenance schedule or flag from ERP', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'erp_px_cat_giv2', @level2type=N'COLUMN', @level2name=N'MAINTENANCE';
END CATCH
GO

-- Postgres-style COMMENT ON examples (uncomment if running on Postgres):
-- COMMENT ON COLUMN bronze.crm_cust_info.cst_id IS 'Customer surrogate identifier';
-- COMMENT ON COLUMN bronze.crm_cust_info.cst_key IS 'Source system customer key';
-- ... (repeat for other columns as needed)
