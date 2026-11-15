# Power BI – Sales Performance Dashboard

## Project Overview

This project extends the SQL Server Data Warehouse by developing an interactive Power BI dashboard using data from the Gold layer.

The dashboard provides business insights into sales performance, customer distribution, product categories, and sales trends over time.

## Dashboard Preview

![Sales Performance Dashboard](screenshots/sales_dashboard.png)

## Key Performance Indicators (KPIs)

The dashboard presents four key business metrics:

- **Total Sales:** Overall revenue generated.
- **Total Orders:** Total number of orders processed.
- **Total Customers:** Number of customers.
- **Average Order Value:** Average revenue generated per order.

## Dashboard Features

### 1. Sales by Country
Geographical analysis of sales distribution across different countries.

### 2. Customers by Gender
Analysis of customer distribution by gender.

### 3. Sales by Year and Month
Time-series analysis showing monthly sales trends and changes in revenue over time.

### 4. Sales by Category
Comparison of sales performance across product categories, including Bikes, Accessories, and Clothing.

### 5. Interactive Filters
- Year slicer for filtering the reporting period.
- Product Line slicer for analysing specific product lines.

## Tools and Technologies

- Microsoft SQL Server
- Power BI Desktop
- Power Query
- DAX (Data Analysis Expressions)
- Data Warehouse – Bronze, Silver and Gold architecture

## Data Source

The dashboard uses analytics-ready data from the Gold layer of the SQL Server Data Warehouse developed in this repository.

## Project Objective

To transform structured data warehouse information into interactive visual reports that support business performance monitoring, sales analysis, and data-driven decision-making.

## Project Files

- `Sales_Performance_Dashboard.pbix` – Power BI report file.
- `screenshots/sales_dashboard.png` – Dashboard preview.
- `README.md` – Power BI project documentation.
