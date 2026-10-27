CREATE TABLE customer_reviews
(
review_id VARCHAR(50) PRIMARY KEY,
order_id VARCHAR(50),
customer_id VARCHAR(50),
product_id VARCHAR(50),
review_date DATE,
rating INT,
review_sentiment VARCHAR(50),
verified_purchase BOOLEAN
)
CREATE TABLE customers
(
customer_id VARCHAR(50) PRIMARY KEY,
customer_signup_date DATE,
gender VARCHAR(20),
age INT,
age_group VARCHAR(20),
state VARCHAR(50),
city VARCHAR(50),
pincode_prefix INT,
customer_segment VARCHAR(30),
preferred_device VARCHAR(30),
preferred_payment_method VARCHAR(50),
acquisition_channel VARCHAR(50),
total_orders INT,
total_spend NUMERIC(12,2),
last_order_date DATE,
average_order_value NUMERIC(12,2),
customer_status VARCHAR(30),
loyalty_tier VARCHAR(20)
)
CREATE TABLE order_items
(
order_item_id VARCHAR(50) PRIMARY KEY,
order_id VARCHAR(50),
product_id VARCHAR(50),
quantity INT,
unit_price INT,
discount_percentage NUMERIC(5,2),
item_revenue NUMERIC(10,2),
item_cost NUMERIC(10,2),
profit NUMERIC(10,2)
)
CREATE TABLE orders
(
order_id VARCHAR(50) PRIMARY KEY,
customer_id VARCHAR(50),
order_date DATE,
order_time TIME,
order_status VARCHAR(30),
shipping_method VARCHAR(30),
delivery_city VARCHAR(30),
delivery_state VARCHAR(30),
coupon_code VARCHAR(30),
discount_percentage INT,
marketing_channel VARCHAR(30),
subtotal NUMERIC(12,2),
shipping_fee INT,
tax_amount NUMERIC(12,2),
final_amount NUMERIC(12,2),
campaign_id VARCHAR(20)
)
CREATE TABLE payments
(
payment_id	VARCHAR(30) PRIMARY KEY,
order_id	VARCHAR(30),
payment_date	DATE,
payment_method	VARCHAR(30),
payment_status	VARCHAR(30),
amount_paid	NUMERIC(10,2),
transaction_fee	NUMERIC(10,2),
refund_amount NUMERIC(10,2)
)
CREATE TABLE products
(
product_id	VARCHAR(30) PRIMARY KEY,
product_name	VARCHAR(150),
category	VARCHAR(30),
subcategory	VARCHAR(30),
brand	VARCHAR(30),
price	NUMERIC(10,2),
cost_price	NUMERIC(10,2),
discount_range	VARCHAR(30),
rating_average	NUMERIC(3,1),
rating_count	INT,
stock_quantity	INT,
product_launch_date	DATE,
product_type	VARCHAR(50),
return_rate_baseline NUMERIC(6,4)
)
CREATE TABLE returns
(
return_id	VARCHAR(50) PRIMARY KEY,
order_id	VARCHAR(50),
customer_id	VARCHAR(50),
product_id	VARCHAR(50),
return_date	DATE,
return_reason	VARCHAR(150),
refund_amount	NUMERIC(10,2),
return_status VARCHAR(50)
)
CREATE TABLE shipments
(
shipment_id	VARCHAR(50) PRIMARY KEY,
order_id	VARCHAR(50),
warehouse_city	VARCHAR(50),
delivery_city	VARCHAR(50),
shipping_method	VARCHAR(50),
dispatch_date	DATE,
expected_delivery_date	DATE,
actual_delivery_date	DATE,
delivery_days	INT,
delivery_status	VARCHAR(50),
delayed_flag INT
)

--**--KPI--**--

--Q1: Net Revenue

SELECT
	ROUND((SUM(o.final_amount)-SUM(COALESCE(r.refund_amount,0)))::numeric,2) AS net_revenue
FROM orders AS o
LEFT JOIN returns AS r ON o.order_id=r.order_id

--Q2: Average Order Value (AOV)

SELECT
	ROUND(SUM(final_amount)/COUNT(order_id)::numeric,2) AS AOV
FROM orders

--Q2.1 Average Unit Price (AUP)

SELECT
	ROUND(SUM(item_revenue)/SUM(quantity)::numeric,2) AS AUP
FROM order_items

--Q3: Overall Return Rate (%)

SELECT 
	ROUND(COUNT(r.return_id)*100/COUNT(o.order_id)::numeric,2) AS Overall_Return_Rate
FROM orders AS o
LEFT JOIN returns AS r ON o.order_id=r.order_id

--Q4: On-Time Delivery Rate (OTD %)

SELECT
	ROUND(
		(COUNT(CASE WHEN delayed_flag=0 THEN 1 END)*100/COUNT(shipment_id))::numeric,2
	) AS On_Time_Delivery_Rate
FROM shipments

--Q5: Customer Churn Rate (%)

SELECT
	ROUND(
		(COUNT(CASE WHEN customer_status='Churned' THEN 1 END)*100/COUNT(customer_id))::numeric,2
	) AS Customer_Churn_Rate
FROM customers

--Q6: Order Failure & Cancellation Rate (%)

SELECT
	ROUND(
		(COUNT(CASE WHEN order_status='Failed' THEN 1 END)*100/COUNT(customer_id))::numeric,2
	) AS Order_Failure_Rate,
	ROUND(
		(COUNT(CASE WHEN order_status='Cancelled' THEN 1 END)*100/COUNT(customer_id))::numeric,2
	) AS Order_Cancellation_Rate
FROM orders

--Q7: Customer Satisfaction Score (CSAT / Positive Review %)

SELECT
	ROUND(
		(COUNT(CASE WHEN review_sentiment='Positive' THEN 1 END)*100/COUNT(review_id))::numeric,2
	) AS positive_review
FROM customer_reviews

--Q8: Gross Margin Percentage (%)

SELECT
	ROUND((SUM(profit)*100/SUM(item_revenue))::numeric,2) AS Gross_Margin_Percentage
FROM order_items

--**-- 8 Analytical Questions (for Excel Pivot Tables & SQL) --**--

--Q1: Which acquisition channel delivers the highest customer lifetime value and Average Order Value (AOV)?

SELECT
	acquisition_channel,
	ROUND(AVG(total_spend)::numeric,2) AS customer_lifetime_value,
	ROUND(AVG(average_order_value)::numeric,2) AS average_order_value
FROM customers
GROUP BY 1
ORDER BY 2 DESC

--Q2: What are the primary root causes for product returns, and what is the total refund value tied to each reason?

SELECT
	return_reason,
	COUNT(customer_id) AS total_returns,
	SUM(refund_amount) AS total_refund
FROM returns
GROUP BY 1
ORDER BY 2 DESC

--Q3: Which shipping methods and warehouse-to-city delivery routes have the highest rate of delayed deliveries?

SELECT
	shipping_method,
	warehouse_city,
	delivery_city,
	COUNT(*) AS total_shipments,
	COUNT(CASE WHEN delayed_flag=1 THEN 1 END) AS delayed_orders,
	ROUND((COUNT(CASE WHEN delayed_flag=1 THEN 1 END)*100.0/COUNT(*))::numeric,2) AS delay_percentage
FROM shipments
GROUP BY 1,2,3
ORDER BY 5 DESC

--Q4: How does customer order fulfillment status (Delivered vs. Cancelled/Failed) vary across different payment methods?

SELECT
	p.payment_method,
	COUNT(o.order_id) AS total_orders, 
	COUNT(CASE WHEN o.order_status='Delivered' THEN 1 END) AS Delivered_count,
	COUNT(CASE WHEN o.order_status='Cancelled' THEN 1 END) AS cancel_count,
	COUNT(CASE WHEN o.order_status='Failed' THEN 1 END) AS failed_count,
	ROUND((COUNT(CASE WHEN o.order_status='Delivered' THEN 1 END)*100.0/COUNT(o.order_id))::numeric,2) AS Delivery_percent,
	ROUND((COUNT(CASE WHEN o.order_status='Cancelled' THEN 1 END)*100.0/COUNT(o.order_id))::numeric,2) AS cancel_percent,
	ROUND((COUNT(CASE WHEN o.order_status='Failed' THEN 1 END)*100.0/COUNT(o.order_id))::numeric,2) AS failed_percent
FROM orders AS o
JOIN payments AS p ON o.order_id=p.order_id
GROUP BY 1
ORDER BY 2 DESC

--Q5: How is total customer spend distributed across customer loyalty tiers and market segments?

SELECT
	loyalty_tier,
	customer_segment,
	COUNT(customer_id) AS total_customer,
	ROUND(SUM(total_spend)::numeric,2) AS total_spend,
	ROUND(AVG(total_spend)::numeric,2) AS avg_spend_per_customer
FROM customers
GROUP BY 1,2
ORDER BY 1,4 DESC

--Q6: Is there a measurable difference in average review ratings between verified purchasers and unverified buyers?

SELECT
	verified_purchase,
	ROUND(AVG(rating)::numeric,2) AS avg_rating
FROM customer_reviews
GROUP BY 1

--Q7: What is the month-over-month trend in sales volume and revenue across different product tiers?

WITH cte AS (
SELECT
	p.product_type,
	DATE_TRUNC('month',o.order_date) AS month,
	TO_CHAR(o.order_date,'MON-YY') AS month_name,
	SUM(oi.quantity) AS sales_volume,
	SUM(oi.item_revenue) AS total_revenue
FROM products AS p
JOIN order_items AS oi ON p.product_id=oi.product_id
JOIN orders AS o ON oi.order_id=o.order_id
GROUP BY 1,2,3
),
prev AS(
SELECT
	*,
	LAG(sales_volume) OVER(PARTITION BY product_type ORDER BY month) AS prev_volume,
	LAG(total_revenue) OVER(PARTITION BY product_type ORDER BY month) AS prev_revenue
FROM cte
)
SELECT 
	product_type,
	month_name,
	sales_volume,
	prev_volume,
	ROUND(((sales_volume-prev_volume)*100/NULLIF(prev_volume,0))::numeric,2) AS volume_growth_pct,
	total_revenue,
	prev_revenue,
	ROUND(((total_revenue-prev_revenue)*100/NULLIF(prev_revenue,0))::numeric,2) AS revenue_growth_pct
FROM prev
ORDER BY 1, month

--Q8: Which product categories show the highest gap between baseline return rates and actual return volumes?

WITH category_return AS(
SELECT
	p.category,
	COUNT(DISTINCT oi.order_item_id) AS total_sold,
	COUNT(DISTINCT r.return_id) AS total_return,
	ROUND((AVG(p.return_rate_baseline)*100)::numeric,2) AS baseline_return_rate,
	ROUND((COUNT(r.return_id)*100/NULLIF(COUNT(oi.order_id),0))::numeric,2) AS actual_return_rate
FROM products AS p
JOIN order_items AS oi ON p.product_id=oi.product_id
LEFT JOIN (SELECT DISTINCT order_id,return_id FROM returns) AS r ON oi.order_id=r.order_id
GROUP BY 1
)
SELECT
	category,
	total_sold,
	total_return,
	baseline_return_rate,
	actual_return_rate,
	ROUND((actual_return_rate-baseline_return_rate)::numeric,2) AS return_gap
FROM category_return
ORDER BY 6 DESC





























