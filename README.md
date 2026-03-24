# northwind-sales-analysis
End-to-end sales analysis using Python, R, and Power BI

## Overview
This project analyzes sales data from the Northwind database to uncover insights about customer behavior, product performance, and business operations.

The goal is to support data-driven decision-making through Business Intelligence and advanced analytics.

## Objectives
- Analyze sales performance across regions, products, and customers
- Identify key drivers of revenue and profitability
- Segment customers using RFM analysis
- Forecast revenue trends
- Provide actionable business recommendations

## Tools Used
- Excel + Python (Data Cleaning & Processing)
- R (Customer Segmentation & Forecasting)
- Power BI (Dashboard & Visualization)

## Dataset
- 11 tables (Orders, Customers, Products, Employees, etc.)
- 82 columns
- Sales, logistics, and customer data

## Data Processing
- Cleaned missing values and encoding issues
- Removed redundant columns
- Created new features (Revenue, Full Name)
- Built Snowflake schema in Power BI

## Analysis

### Sales Performance
- Revenue trends over time
- Profit analysis

### Customer Analysis
- Top customers
- Customer contribution to revenue

### Product Analysis
- Best-selling products
- Profit margins

### Operational Analysis
- Shipping costs
- Supplier impact

## Advanced Analytics

### Customer Segmentation
- Applied RFM (Recency, Frequency, Monetary)
- Used K-means clustering
- Identified customer groups

### Revenue Forecasting
- Built regression model in R
- Predicted future revenue trends

## Key Insights
- A small group of customers contributes the majority of revenue
- High shipping cost reduces profitability in some regions
- Discount policies significantly impact profit margins

## Recommendations
- Focus on high-value customers
- Optimize logistics costs
- Adjust discount strategies

## Dashboard Preview
### Overview
![Overview](images/dashboard_overview.png)

### Customer Analysis
![Customer](images/dashboard_customer.png)

### Country Analysis
![Country](images/dashboard_country.png)

### City Analysis
![City](images/dashboard_city.png)

### Product Analysis
![Product](images/dashboard_product.png)

### Category Analysis
![Category](images/dashboard_category.png)

### Employee Performance
![Employee](images/dashboard_employee.png)

### Supplier Analysis
![Supplier](images/dashboard_supplier.png)

### Shipper Analysis
![Shipper](images/dashboard_shipper.png)

### Time Analysis
![Time](images/dashboard_time.png)

## Project Structure
- data/
- notebooks/
- r_scripts/
- powerbi/
