with subscription_dates AS (
	SELECT DISTINCT
		DATE(DATE_TRUNC('month',created_date)) AS month_date
	FROM streaming_subscription_data
), 
subscription_customer AS (
	SELECT 
		customer_id,
		MIN( DATE(DATE_TRUNC('month',created_date)) ) AS min_month_date,
		MAX( CASE WHEN DATE(DATE_TRUNC('month',canceled_date)) is NULL THEN DATE('2025-01-01') ELSE DATE(DATE_TRUNC('month',canceled_date)) END ) AS max_month_date
	FROM streaming_subscription_data
	GROUP BY 1
),
monthly_customer AS (
	SELECT
		a.month_date,
		b.customer_id
	FROM subscription_dates a 
	CROSS JOIN subscription_customer b 
	WHERE a.month_date >= b.min_month_date
	AND a.month_date <= b.max_month_date
),
monthly_subscription_data AS (
	SELECT 
		a.month_date,
		a.customer_id,
		b.subscription_cost,
		b.created_date,
		b.canceled_date
	FROM monthly_customer a 
	LEFT JOIN (
		SELECT
		FROM streaming_subscription_data
	) b 
	ON a.customer_id = b.customer_id
	AND a.month_date >= DATE(DATE_TRUNC('month',b.created_date))
	AND ( a.month_date <= DATE(DATE_TRUNC('month',b.canceled_date)) OR b.canceled_date is NULL )
)


SELECT 
	month_date,
	SUM( subscription_cost ) AS total_revenue,
	SUM( next_month_subscription_cost ) AS next_month_total_revenue,
	ROUND( ( SUM( CAST( next_month_subscription_cost as numeric) )/SUM( subscription_cost ) ) * 100 ,2) AS pct_revenue_retention,
	SUM( CASE WHEN new_acquisition = 1 THEN subscription_cost ELSE 0 END ) AS new_customer_revenue,
	COUNT(*) AS customer_cnt,
	SUM(customer_churn) AS customer_churn,
	SUM(new_acquisition) AS new_customer_cnt,
	SUM(new_acquisition_churn) AS new_customer_churn,
	ROUND( SUM( subscription_cost ) / COUNT(*),2) AS arpu,
	ROUND(( 1 - ( SUM(CAST(customer_churn as numeric))/COUNT(*) ) ) * 100,2 ) AS customer_retention
FROM(
	SELECT
		LEAD(subscription_cost,1) OVER( PARTITION BY customer_id, created_date ORDER BY month_date )  AS next_month_subscription_cost,
		CASE WHEN month_date = DATE(DATE_TRUNC('month',created_date)) THEN 1 ELSE 0 END AS new_acquisition,
		CASE WHEN LEAD(customer_id,1) OVER( PARTITION BY customer_id, created_date ORDER BY month_date ) is NULL THEN 1 ELSE 0 END AS customer_churn,
		CASE WHEN DATE(DATE_TRUNC('month',canceled_date)) = DATE(DATE_TRUNC('month',created_date)) THEN 1 ELSE 0 END AS new_acquisition_churn,
		*
	FROM monthly_subscription_data
	WHERE created_date is NOT NULL
) AS z 
GROUP BY 1
ORDER BY month_date

