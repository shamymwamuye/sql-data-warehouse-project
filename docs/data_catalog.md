# Data Catalog

This document provides a human- and machine-readable catalog for the objects in the SQL Data Warehouse. It describes business entities, physical tables, key columns, data owners, source systems, refresh frequency, sensitivity/classification, and lineage notes. Keep this file updated whenever schema, owners, or ETL processes change.

## How to use

- Read the high-level sections to understand warehouse layers, naming conventions, and ETL patterns.
- Refer to the Tables section for schema-level details needed for analytics or data access requests.
- Use the Sample Queries section to preview or validate data quickly.

---

## Warehouse layers

- staging: Raw extracts loaded from source systems. Minimal transformations. Short retention.
- ods (operational data store): Cleansed, conformed operational data. Keys assigned where needed.
- dw (data warehouse): Dimensional model (facts and dimensions) optimized for analytics.
- marts: Business-specific data extracts or simplified views for reporting/BI.

---

## Naming conventions

- Schemas reflect layers: `staging`, `ods`, `dw`, `marts`, `lookup`.
- Tables: `<layer>.<subject>[_<role>]` e.g., `dw.sales_fact`, `dw.dim_customer`.
- Columns: `snake_case` or `PascalCase` based on repository convention (update if inconsistent).
- Surrogate keys: `*_sk` (integer) for dimensional keys.
- Business keys: `*_bk` or `<natural_key>` used to deduplicate or identify source rows.

---

## Table catalog (examples)

> Note: Populate the table below with actual objects from your database. This section contains recommended fields and example entries.

- Table: dw.dim_customer
  - Schema: dw
  - Type: Dimension
  - Business description: Master customer record for analytics, consolidated across sources.
  - Primary key: customer_sk (INT, surrogate)
  - Business key(s): customer_id, email
  - Important columns:
    - customer_sk (INT) — surrogate key
    - customer_id (VARCHAR) — source system business key
    - first_name, last_name (VARCHAR)
    - email (VARCHAR)
    - created_date (DATETIME)
    - current_flag (BIT)
  - Source systems: crm.customers (primary), legacy_app.customer_master (secondary)
  - ETL process: ETL proc `etl.dim_customer_upsert` runs nightly; merges on `customer_id` and sets `current_flag`.
  - Refresh frequency: Nightly (02:00 UTC)
  - Retention: Full history kept via effective_date / expiry_date columns
  - Data steward / owner: Analytics Team — data_steering@company.com
  - Sensitivity: PII — masked in downstream marts; access restricted to approved roles
  - Lineage notes: Extracted via API -> staging.customers -> ods.customer -> dw.dim_customer (dedup & SCD Type 2)

- Table: dw.sales_fact
  - Schema: dw
  - Type: Fact
  - Business description: Transactional sales events used for revenue reporting and KPIs.
  - Primary key: sales_fact_sk (INT)
  - Business key(s): order_id
  - Grain: One row per order line item
  - Important columns:
    - sales_fact_sk (INT) — surrogate
    - order_id (VARCHAR)
    - product_id (VARCHAR)
    - customer_sk (INT)
    - order_date (DATETIME)
    - amount (DECIMAL(18,2))
    - currency (VARCHAR)
  - Source systems: ecommerce.orders, pos.transactions
  - ETL process: `etl.load_sales_fact` — integrates and reconciles orders, applies currency conversion
  - Refresh frequency: Hourly incremental, daily full reconcile
  - Retention: Transactional history maintained for 7 years
  - Data steward / owner: Finance Analytics — finance_analytics@company.com
  - Sensitivity: Financial — restricted
  - Lineage notes: Staging loads -> ods.order_events -> join with dw.dim_product and dw.dim_customer -> dw.sales_fact

---

## Column-level metadata (recommended fields)

For each table, track:
- column_name
- data_type
- nullable (Y/N)
- business_description
- example_values
- transformation_logic (if derived)
- sensitivity/classification (e.g., PII, financial, internal)
- owner/steward

Example:
- Table: dw.dim_customer
  - column_name: email
  - data_type: VARCHAR(254)
  - nullable: Y
  - business_description: Customer email address used for communications and identity resolution
  - example_values: user@example.com
  - transformation_logic: Trim, lower-case, mask when exposed to non-authorized users
  - sensitivity: PII
  - steward: data_steering@company.com

---

## Data lineage and transformation notes

- Record the ETL job name, stored procedure, or SSIS package that performs the transformation.
- Include the schedule, key transformation rules, deduplication logic, and any lookup enrichments.
- Example: `etl.dim_customer_upsert` — Steps: 1) extract distinct customer records from staging.customers; 2) normalize names and clean emails; 3) match on customer_id or email; 4) apply SCD Type 2 logic updating effective/expiry dates.

---

## Data quality and monitoring

- Define key DQ checks per table, e.g.:
  - Row count expected ranges (daily/weekly)
  - Null rates for critical columns (e.g., customer_id, order_id < 1%)
  - Referential integrity (customer_sk in facts must exist in dw.dim_customer)
  - Duplicate detection using business keys
- Track alerting channels and SLAs for fixing DQ issues.

---

## Access & governance

- Who can access (roles): db_reader, analytics_user, data_engineer, admin.
- Masking rules for PII and sensitive fields (views in `marts` schema with masked columns).
- Approval process for granting access: Request via internal access portal (link to portal), approval by data steward.

---

## Sample queries

- List most recent rows for a table
  ```sql
  SELECT TOP (100) * FROM dw.sales_fact ORDER BY order_date DESC;
  ```

- Count distinct customers loaded in the last 30 days
  ```sql
  SELECT COUNT(DISTINCT customer_id) AS unique_customers
  FROM ods.customer
  WHERE load_date >= DATEADD(DAY, -30, GETUTCDATE());
  ```

- Validate referential integrity
  ```sql
  SELECT f.order_id
  FROM dw.sales_fact f
  LEFT JOIN dw.dim_customer c ON f.customer_sk = c.customer_sk
  WHERE c.customer_sk IS NULL;
  ```

---

## Glossary

- SCD: Slowly Changing Dimension
- ETL: Extract, Transform, Load
- ODS: Operational Data Store
- DW: Data Warehouse
- SK: Surrogate Key
- BK: Business Key

---

## Change log

- 2026-08-14: Created initial data catalog template and example entries (shamymwamuye)

---

If you want, I can:
- Extract table/column metadata automatically from the database (requires DB connection or exported schema),
- Add a CSV/JSON export of the catalog,
- Integrate this catalog with a documentation site or a Data Catalog tool (e.g., Azure Purview, Collibra).
