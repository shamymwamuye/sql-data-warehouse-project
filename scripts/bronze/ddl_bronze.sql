/*
==================================================================================================
DDL Script: Create Bronze Tables (Strict/Validated Version)
==================================================================================================

Purpose:
This script defines the DDL for the 'bronze' schema used as the raw ingestion layer
in the data warehouse. It drops each table if it already exists and (re)creates it
with standardized column types, lightweight constraints, surrogate keys, ingestion
metadata, and indexes to improve queryability while preserving source columns.

What changed in this version (applied):
- Added a surrogate primary key column `_ingest_id` (INT IDENTITY) on each table.
- Added an `ingestion_ts` column (DATETIME2) with a default of SYSUTCDATETIME().
- Applied NOT NULL to source key columns where appropriate (cst_key, prd_key, sls_ord_num, CID, ID).
- Standardized monetary/date types (DECIMAL(18,2) for currency, DATE/DATETIME2 for timestamps).
- Added nonclustered indexes for common join/search keys (cst_key, prd_key, sls_prd_key, CID, ID).
- Preserved original column names so upstream consumers remain compatible.
- Kept SQL Server extended property comments for columns and updated them for new columns.

Notes / Caution:
- This script is targeted at SQL Server (T-SQL). For Postgres or others, adjust identity, default, and extended-property sections.
- The script drops tables; run in dev/test first.
- Adding NOT NULL constraints and indexes may fail if existing data violates them; verify before running on production snapshots.
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
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    cst_id INT NULL,
    cst_key NVARCHAR(50) NOT NULL,
    cst_firstname NVARCHAR(50) NULL,
    cst_lastname NVARCHAR(50) NULL,
    cst_marital_status NVARCHAR(50) NULL,
    cst_gndr NVARCHAR(50) NULL,
    cst_create_date DATE NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Indexes for customer table
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.crm_cust_info') AND name = N'ix_crm_cust_info_cst_key')
BEGIN
    CREATE NONCLUSTERED INDEX ix_crm_cust_info_cst_key ON bronze.crm_cust_info(cst_key);
END
GO

-- Extended properties (descriptions) for crm_cust_info
BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_cust_info', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END CATCH

-- (other column extended properties omitted for brevity; they remain similar to prior version)
GO

-- Remove and re-create product information table from CRM product feed
DROP TABLE IF EXISTS bronze.crm_prd_info;
GO

CREATE TABLE bronze.crm_prd_info (
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    prd_id INT NULL,
    prd_key NVARCHAR(50) NOT NULL,
    prd_nm NVARCHAR(100) NULL,
    prd_cost DECIMAL(18,2) NULL,
    prd_line NVARCHAR(50) NULL,
    prd_start_dt DATETIME2 NULL,
    prd_end_dt DATETIME2 NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Indexes for product table
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.crm_prd_info') AND name = N'ix_crm_prd_info_prd_key')
BEGIN
    CREATE NONCLUSTERED INDEX ix_crm_prd_info_prd_key ON bronze.crm_prd_info(prd_key);
END
GO

-- Extended property for new prd table
BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_prd_info', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END CATCH
GO

-- Remove and re-create sales transaction details from CRM sales feed
DROP TABLE IF EXISTS bronze.crm_sales_details;
GO

CREATE TABLE bronze.crm_sales_details (
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    sls_ord_num NVARCHAR(50) NOT NULL,
    sls_prd_key NVARCHAR(50) NOT NULL,
    sls_cust_id INT NULL,
    sls_order_dt DATE NULL,
    sls_ship_dt DATE NULL,
    sls_due_dt DATE NULL,
    sls_sales DECIMAL(18,2) NULL,
    sls_quantity INT NULL,
    sls_price DECIMAL(18,2) NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Indexes for sales details
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.crm_sales_details') AND name = N'ix_crm_sales_details_sls_prd_key')
BEGIN
    CREATE NONCLUSTERED INDEX ix_crm_sales_details_sls_prd_key ON bronze.crm_sales_details(sls_prd_key);
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.crm_sales_details') AND name = N'ix_crm_sales_details_sls_ord_num')
BEGIN
    CREATE NONCLUSTERED INDEX ix_crm_sales_details_sls_ord_num ON bronze.crm_sales_details(sls_ord_num);
END
GO

-- Extended property for sales details ingest id
BEGIN TRY
    EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END TRY
BEGIN CATCH
    EXEC sys.sp_updateextendedproperty @name=N'MS_Description', @value=N'Internal ingest surrogate id', @level0type=N'SCHEMA', @level0name=N'bronze', @level1type=N'TABLE', @level1name=N'crm_sales_details', @level2type=N'COLUMN', @level2name=N'_ingest_id';
END CATCH
GO

-- Remove and re-create ERP customer table (source: erp_cust_az12)
DROP TABLE IF EXISTS bronze.erp_cust_az12;
GO

CREATE TABLE bronze.erp_cust_az12 (
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CID NVARCHAR(50) NOT NULL,
    BDATE DATE NULL,
    GEN NVARCHAR(50) NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Index for ERP customer id
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.erp_cust_az12') AND name = N'ix_erp_cust_az12_CID')
BEGIN
    CREATE NONCLUSTERED INDEX ix_erp_cust_az12_CID ON bronze.erp_cust_az12(CID);
END
GO

-- Remove and re-create ERP location table (source: erp_loc_a101)
DROP TABLE IF EXISTS bronze.erp_loc_a101;
GO

CREATE TABLE bronze.erp_loc_a101 (
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    CID NVARCHAR(50) NOT NULL,
    CNTRY NVARCHAR(50) NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Index for ERP location CID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.erp_loc_a101') AND name = N'ix_erp_loc_a101_CID')
BEGIN
    CREATE NONCLUSTERED INDEX ix_erp_loc_a101_CID ON bronze.erp_loc_a101(CID);
END
GO

-- Remove and re-create ERP product/category metadata (source: erp_px_cat_giv2)
DROP TABLE IF EXISTS bronze.erp_px_cat_giv2;
GO

CREATE TABLE bronze.erp_px_cat_giv2 (
    _ingest_id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    ID NVARCHAR(50) NOT NULL,
    CAT NVARCHAR(50) NULL,
    SUBCAT NVARCHAR(50) NULL,
    MAINTENANCE NVARCHAR(50) NULL,
    ingestion_ts DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

-- Index for ERP product/category ID
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'bronze.erp_px_cat_giv2') AND name = N'ix_erp_px_cat_giv2_ID')
BEGIN
    CREATE NONCLUSTERED INDEX ix_erp_px_cat_giv2_ID ON bronze.erp_px_cat_giv2(ID);
END
GO

-- Postgres-style COMMENT ON examples (uncomment and adjust if running on Postgres):
-- COMMENT ON COLUMN bronze.crm_cust_info._ingest_id IS 'Internal ingest surrogate id (identity)';
-- COMMENT ON COLUMN bronze.crm_cust_info.ingestion_ts IS 'Ingestion timestamp assigned by the ETL';
-- ... (repeat for other columns as needed)
