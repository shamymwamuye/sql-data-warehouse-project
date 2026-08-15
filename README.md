# 🏗️ Data Warehouse and Analytics Project

This portfolio project demonstrates an end-to-end **data warehousing + analytics** workflow—starting from raw CSV extracts (ERP + CRM), building a **SQL Server** data warehouse using the **Medallion Architecture (Bronze/Silver/Gold)**, and finishing with analytics-ready models for reporting and insights.

- 🗄️ **Database:** `DataWarehouse`
- 🧱 **Schemas:** `bronze`, `silver`, `gold`
- 🛠️ **Tooling:** SQL Server Management Studio (SSMS)

---

## ⚡ Quickstart (Run Order in SSMS)

1. 🧰 Run `scripts/init_database.sql` *(creates/initializes `DataWarehouse`)*
2. 🥉 Run `scripts/bronze/ddl_bronze.sql`
3. 🥉 Run `scripts/bronze/load_bronze.sql`
4. 🥈 Run `scripts/silver/ddl_silver.sql`
5. 🥈 Run `scripts/silver/load_silver.sql`
6. 🥇 Run `scripts/gold/ddl_gold.sql`
7. ✅ *(Optional)* Run tests:
   - 🥈 `tests/quality_checks_silver.sql`
   - 🥇 `tests/quality_checks_gold.sql`

---

## 📌 Table of Contents
- [🧭 Overview](#-overview)
- [🏛️ Data Architecture](#️-data-architecture)
- [🗂️ Repository Structure](#️-repository-structure)
- [📥 Data Sources](#-data-sources)
- [▶️ How to Run (SSMS)](#️-how-to-run-ssms)
- [🧱 Schemas & Layers](#-schemas--layers)
- [✅ Data Quality Checks](#-data-quality-checks)
- [📚 Documentation](#-documentation)
- [📄 License](#-license)

---

## 🧭 Overview

This project includes:

- 🏛️ **Data Architecture** using Medallion layers (**Bronze**, **Silver**, **Gold**)
- 🔁 **ETL Pipelines** to ingest and transform raw CSV data into a structured warehouse
- ⭐ **Data Modeling** with an analytics-friendly **Star Schema** (facts & dimensions)
- 📊 **Analytics & Reporting** using SQL queries on curated Gold tables

Skills demonstrated:

- 🧠 SQL Development
- 🏗️ Data Engineering & ETL
- 🧩 Dimensional Modeling (Fact & Dimension design)
- 🧪 Data Quality / Testing
- 📈 Analytics with SQL

---

## 🏛️ Data Architecture

The warehouse follows the **Medallion Architecture**:

- 🥉 **Bronze Layer (Raw)**
  -  Stores source data as-is
  -  Data is ingested from CSV files into SQL Server

- 🥈 **Silver Layer (Cleaned / Conformed)**
  -  Cleanses data and resolves quality issues
  -  Standardizes formats and normalizes structures
  -  Prepares integrated data for analytics modeling

- 🥇 **Gold Layer (Business / Analytics)**
  -  Houses business-ready, curated datasets
  -  Modeled into a **Star Schema** for reporting
  -  Optimized for analytical queries

📌 Architecture diagrams are available under `docs/`.

---

## 🗂️ Repository Structure

```
sql-data-warehouse-project/
├─  datasets/
│  ├─  source_crm/
│  └─  source_erp/
├─  docs/
│  ├─  data_architecture.png
│  ├─  data_flow.png
│  ├─  data_integration.png
│  ├─  data_model.png
│  ├─  data_catalog.md
│  └─  naming_conventions.md
├─  scripts/
│  ├─  bronze/
│  │  ├─  ddl_bronze.sql
│  │  └─  load_bronze.sql
│  ├─  silver/
│  │  ├─  ddl_silver.sql
│  │  └─  load_silver.sql
│  ├─  gold/
│  │  └─  ddl_gold.sql
│  └─  init_database.sql
├─  tests/
│  ├─  quality_checks_silver.sql
│  └─  quality_checks_gold.sql
└─  LICENSE
```

---

## 📥 Data Sources

This project integrates data from two source systems provided as CSV files:

### 🤝 CRM (`datasets/source_crm/`)
-  `cust_info.csv` — customer information
-  `prd_info.csv` — product information
-  `sales_details.csv` — sales transactions/details

### 🏢 ERP (`datasets/source_erp/`)
-  `CUST_AZ12.csv` — customer master/extract
-  `LOC_A101.csv` — location extract
-  `PX_CAT_G1V2.csv` — product category extract

---

## ▶️ How to Run (SSMS)

### ✅ Prerequisites
- 🖥️ SQL Server instance (local or remote)
- 🧰 **SQL Server Management Studio (SSMS)**
- 📂 Local access to the repo’s `datasets/` folder (needed for CSV loads)

### 🧑‍💻 Steps
1. 📦 **Clone the repository**
​
git clone https://github.com/shamymwamuye/sql-data-warehouse-project.git
cd sql-data-warehouse-project

2. 🗄️ **Initialize the database**
   - Open SSMS and connect to your SQL Server instance
   - 🧰 Run:
     - `scripts/init_database.sql`
   - ✅ This initializes the database: `DataWarehouse`

3. 🥉 **Build + load Bronze (raw layer)**
   - 🏗️ Run:
     - `scripts/bronze/ddl_bronze.sql`
   - 📥 Run:
     - `scripts/bronze/load_bronze.sql`

4. 🥈 **Build + load Silver (cleaned layer)**
   - 🏗️ Run:
     - `scripts/silver/ddl_silver.sql`
   - 🔁 Run:
     - `scripts/silver/load_silver.sql`

5. 🥇 **Build Gold (analytics layer / star schema)**
   - ⭐ Run:
     - `scripts/gold/ddl_gold.sql`

> 📝 If any load scripts reference local file paths, update them to match your machine’s absolute path to the repo’s `datasets/` folder.

---

## 🧱 Schemas & Layers

This warehouse uses separate schemas to keep each layer clean and discoverable:

- 🥉 `bronze.*`
  -  Raw ingestion tables (as received from source files)
  -  Minimal/no transformation

- 🥈 `silver.*`
  -  Cleaned + standardized + conformed tables
  -  Integrated view of ERP and CRM data

- 🥇 `gold.*`
  -  Analytics-ready dimensional model
  -  Facts & dimensions for BI/reporting use cases

---

## ✅ Data Quality Checks

🧪 Quality checks are included as SQL scripts:

- 🥈 Silver checks:
  - ✅ `tests/quality_checks_silver.sql`
- 🥇 Gold checks:
  - ✅ `tests/quality_checks_gold.sql`

Run these in SSMS after each layer load to validate cleanliness, consistency, and model integrity.

---

## 📚 Documentation

All project documentation and diagrams are located in `docs/`, including:

-  `data_architecture.png` — architecture overview
-  `data_flow.png` — pipeline flow
-  `data_integration.png` — source integration
-  `data_model.png` — dimensional model / star schema
-  `data_catalog.md` — dataset/table catalog
-  `naming_conventions.md` — naming rules used in the warehouse

---

## 📄 License

📜 This project is licensed under the **MIT License**. You are free to use, modify, and share it with proper attribution.
