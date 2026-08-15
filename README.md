# Data Warehouse and Analytics Project (SQL Server)

Welcome to the **Data Warehouse and Analytics Project** repository.

This portfolio project demonstrates an end-to-end **data warehousing + analytics** workflow—starting from raw CSV extracts (ERP + CRM), building a **SQL Server** data warehouse using the **Medallion Architecture (Bronze/Silver/Gold)**, and finishing with analytics-ready models for reporting and insights.

**Database name:** `DataWarehouse`  
**Schemas:** `bronze`, `silver`, `gold`

---

## Quickstart (Run Order in SSMS)

1. `scripts/init_database.sql` (creates/initializes `DataWarehouse`)
2. `scripts/bronze/ddl_bronze.sql`
3. `scripts/bronze/load_bronze.sql`
4. `scripts/silver/ddl_silver.sql`
5. `scripts/silver/load_silver.sql`
6. `scripts/gold/ddl_gold.sql`
7. (Optional tests) `tests/quality_checks_silver.sql`, `tests/quality_checks_gold.sql`

---

## Table of Contents
- [Overview](#overview)
- [Data Architecture](#data-architecture)
- [Repository Structure](#repository-structure)
- [Data Sources](#data-sources)
- [How to Run (SSMS)](#how-to-run-ssms)
- [Schemas & Layers](#schemas--layers)
- [Data Quality Checks](#data-quality-checks)
- [Documentation](#documentation)
- [License](#license)

---

## Overview

This project includes:

- **Data Architecture** using Medallion layers (**Bronze**, **Silver**, **Gold**)
- **ETL Pipelines** to ingest and transform raw CSV data into a structured warehouse
- **Data Modeling** with an analytics-friendly **Star Schema** (facts & dimensions)
- **Analytics & Reporting** using SQL queries on curated Gold tables

Skills demonstrated:
- SQL Development
- Data Engineering & ETL
- Data Modeling (Dimensional Modeling)
- Data Quality / Testing
- Analytics with SQL

---

## Data Architecture

The warehouse follows the **Medallion Architecture**:

- **Bronze Layer (Raw)**  
  Stores source data as-is (ingested from CSV into SQL Server).

- **Silver Layer (Cleaned/Conformed)**  
  Performs cleansing, standardization, and normalization to prepare for analysis.

- **Gold Layer (Business/Analytics)**  
  Provides business-ready data modeled into a **Star Schema** for reporting and analytics.

Architecture diagrams are available under `docs/`.

---

## Repository Structure

​
sql-data-warehouse-project/
├─ datasets/
│  ├─ source_crm/
│  └─ source_erp/
├─ docs/
│  ├─ data_architecture.png
│  ├─ data_flow.png
│  ├─ data_integration.png
│  ├─ data_model.png
│  ├─ data_catalog.md
│  └─ naming_conventions.md
├─ scripts/
│  ├─ bronze/
│  │  ├─ ddl_bronze.sql
│  │  └─ load_bronze.sql
│  ├─ silver/
│  │  ├─ ddl_silver.sql
│  │  └─ load_silver.sql
│  ├─ gold/
│  │  └─ ddl_gold.sql
│  └─ init_database.sql
├─ tests/
│  ├─ quality_checks_silver.sql
│  └─ quality_checks_gold.sql
└─ LICENSE

---

## Data Sources

This project integrates data from two source systems provided as CSV files:

### CRM (`datasets/source_crm/`)
- `cust_info.csv`
- `prd_info.csv`
- `sales_details.csv`

### ERP (`datasets/source_erp/`)
- `CUST_AZ12.csv`
- `LOC_A101.csv`
- `PX_CAT_G1V2.csv`

---

## How to Run (SSMS)

### Prerequisites
- SQL Server (local or remote instance)
- **SQL Server Management Studio (SSMS)**
- Access to this repo’s `datasets/` folder locally (for CSV loads)

### Steps
1. **Clone the repository**
​
git clone https://github.com/shamymwamuye/sql-data-warehouse-project.git
cd sql-data-warehouse-project

2. **Initialize the database**
   - Open SSMS and connect to your SQL Server instance
   - Run:
     - `scripts/init_database.sql`
   - This initializes the database: `DataWarehouse`

3. **Build + load Bronze (raw layer)**
   - Run:
     - `scripts/bronze/ddl_bronze.sql`
     - `scripts/bronze/load_bronze.sql`

4. **Build + load Silver (cleaned layer)**
   - Run:
     - `scripts/silver/ddl_silver.sql`
     - `scripts/silver/load_silver.sql`

5. **Build Gold (analytics layer / star schema)**
   - Run:
     - `scripts/gold/ddl_gold.sql`

> If your load scripts reference local file paths, update them to match your machine’s absolute path to the `datasets/` folder.

---

## Schemas & Layers

This warehouse uses separate schemas to keep each layer clean and discoverable:

- `bronze.*` — raw ingested tables from source files (minimal/no transformation)
- `silver.*` — cleansed, standardized, conformed tables
- `gold.*` — business-ready dimensional model (facts/dimensions) for analytics

---

## Data Quality Checks

Quality checks are included as SQL scripts:

- Silver checks:
  - `tests/quality_checks_silver.sql`
- Gold checks:
  - `tests/quality_checks_gold.sql`

Run these in SSMS after each layer load to validate cleanliness, consistency, and model integrity.

---

## Documentation

Project documentation and diagrams are located in `docs/`, including:

- `data_architecture.png` — architecture overview
- `data_flow.png` — pipeline flow
- `data_integration.png` — source integration
- `data_model.png` — dimensional model / star schema
- `data_catalog.md` — dataset/table catalog
- `naming_conventions.md` — naming rules used in the warehouse

---

## License

This project is licensed under the **MIT License**. You are free to use, modify, and share it with proper attribution.
