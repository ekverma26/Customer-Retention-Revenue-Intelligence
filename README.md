# Customer Retention & Revenue Intelligence

## Project Overview
An end-to-end customer churn analysis project using Python, PostgreSQL, and Tableau. The objective is to identify churn drivers, understand revenue exposure, and recommend data-driven customer retention strategies.

## Business Problem
Customer churn impacts recurring revenue. This project analyzes customer demographics, contracts, tenure, payment methods, and subscribed services to identify patterns associated with churn.

## Tools & Technologies
- Python: data cleaning, exploratory data analysis, validation
- PostgreSQL: SQL-based business analysis
- Tableau: interactive dashboard and KPI visualization

## Key Performance Indicators
- Total Customers: 7,043
- Churned Customers: 1,869
- Churn Rate: 26.54%
- Monthly Charges Associated with Churn: 139,130.85

## Key Findings
- Month-to-month contracts have a 42.71% churn rate.
- Customers with 0–6 months of tenure have a 52.94% churn rate.
- Electronic check users have a 45.29% churn rate.
- Fiber optic customers have a 41.89% churn rate.
- Customers without online security and tech support show higher churn rates than customers with those services.

## Dashboard
![Customer Churn Dashboard]()

## Recommendations
- Investigate retention offers for month-to-month customers.
- Improve early customer onboarding and engagement.
- Review the payment experience for electronic check users.
- Evaluate service bundles and support options for customers at risk.

## Project Structure
- `python/` — data cleaning and exploratory analysis
- `sql/` — SQL business questions and queries
- `tableau/` — Tableau workbook
- `images/` — dashboard screenshots
- `data/` — dataset documentation and source information

## Data Source
IBM Telco Customer Churn dataset. See the original dataset source and usage terms before redistributing the data.

## Disclaimer
Revenue exposure estimates are based on monthly charges associated with churned customers; they are not guaranteed recoverable revenue.
