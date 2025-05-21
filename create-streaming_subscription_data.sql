CREATE TABLE IF NOT EXISTS streaming_subscription_data (
"customer_id"		BIGINT NOT NULL, 
"created_date"		DATE, 
"canceled_date"		DATE, 
"subscription_cost"	NUMERIC, 
"subscription_interval"	VARCHAR(100), 
"was_subscription_paid"	VARCHAR(100)
)