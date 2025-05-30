# Subscription Cohort Retention Analysis
This project contains an SQL script designed to analyze customer retention, churn, and revenue metrics for a subscription-based streaming service. The core objective is to generate monthly cohort-level metrics that inform business performance and lifecycle dynamics across the customer base.

# Objective
The main SQL script, streaming_subscription_data_report.sql, processes raw subscription event data and produces a monthly cohort retention report. Specifically, the query computes:
- Monthly total revenue
- Next-month revenue retention (% revenue retained from the same cohort)
- New customer revenue and count
- Churn rates (overall and new customer-specific)
- Average Revenue Per User (ARPU)
- Customer retention rates

The analysis leverages several layered Common Table Expressions (CTEs) to:
- Normalize dates into a monthly cohort format.
- Track each customer’s active lifecycle using their subscription start and end dates.
- Generate a panel of customer-month combinations to compute retention, churn, and acquisition patterns over time.

# Metrics Tracked
| Metric  | Description |
| ------------- | ------------- |
| total_revenue  | Sum of all subscription fees collected in a given month  |
| pct_revenue_retention  | % of revenue retained from previous month customers  |
| new_customer_revenue  | Revenue generated by newly acquired customers that month  |
| customer_retention  | % of active customers who remain subscribed the following month  |
| customer_churn  | Count of newly acquired customers  |
| arpu  | Average revenue per user that month  |

# Data Sources
The SQL logic assumes access to a single flat table called streaming_subscription_data, which contains the following relevant fields:
- customer_id
- created_date – first subscription date
- canceled_date – last active date (nullable)
- subscription_cost – recurring fee per subscription
Refer to the Subscription Cohort Analysis Data Dictionary for full field-level definitions.

# Future Improvement Plans
Here are enhancements planned for future iterations:
1. Add Customer Segmentation Dimensions
  - Incorporate demographic or behavioral segmentation (e.g., plan type, device used, region) to evaluate retention across key customer cohorts.
2. LTV (Lifetime Value) and CAC (Customer Acquisition Cost) Tracking
  - Integrate marketing spend data to calculate ROI and LTV:CAC ratios by cohort.
3. Churn Reason Attribution
Enrich the dataset with cancellation reasons or customer service flags to understand drivers of churn.
4. Visualization Layer
  - Develop a self-service dashboard (e.g., in Tableau, Power BI, or Streamlit) to allow stakeholders to explore trends interactively.
5. Dynamic Period Tracking
  - Expand beyond monthly cohorts to support weekly or quarterly cohort tracking by parameterizing time granularity.
6. Retention Curve Modeling
  - Generate retention curves and survival analysis for each cohort using Python or R.
