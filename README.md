# 📊 E-Commerce Performance & Customer Intelligence Dashboard (Excel)

An executive-grade interactive Excel dashboard designed to analyze end-to-end e-commerce operations, covering ₹246.67 Cr in revenue across fulfillment logistics, customer acquisition, payment method risks, and product return behaviors.

---
<img width="1886" height="906" alt="E-Com_Dashboard_Preview" src="https://github.com/user-attachments/assets/ce18e205-a74a-46ee-abf6-1db45609e84d" />
---

## 📌 Executive Summary & Key KPIs
* **Net Revenue:** ₹246.67 Cr
* **Average Order Value (AOV):** ₹25,726
* **Average Unit Price:** ₹4,183
* **Overall Return Rate:** 12.08%
* **On-Time Delivery Rate:** 58.24%
* **Customer Churn Rate:** 53.46%
* **Order Failure Rate:** 2.88%
* **Order Cancellation Rate:** 8.07%
* **Customer Satisfaction Score (CSAT):** 59.55%
* **Gross Margin:** 8.05%

---

## 🎯 Key Business Questions & Strategic Insights

### 1. Revenue Drivers & Seasonality
* **MoM Revenue Trends:** Evaluated revenue trajectories segmented by customer segments (Standard, Premium, Exclusive, Budget), identifying peak Q4 purchasing cycles.
* **Customer Loyalty Value:** Gold tier customers drive ₹2.50B in cumulative spend, representing 36% of tier volume, followed by Silver (30%) and Platinum (24%).

### 2. Marketing & Acquisition Efficiency
* **Channel Performance:** Direct/App (₹1,18,341) and Referral (₹1,15,796) generate the highest average spend, followed closely by Email Marketing (₹1,09,130), while SMS and Paid Search demonstrate lower spend thresholds.

### 3. Fulfillment Logistics & Delay Analysis
* **Logistics Bottlenecks:** Analyzed delay rates across delivery tiers; Same-Day (56.40%) and Standard delivery (53.41%) show significant delivery friction compared to Next-Day fulfillment (10.50%).

### 4. Risk Mitigation & Product Returns
* **Return Drivers:** "Changed mind" (₹19M) and "Size issue" (₹18M) represent the largest refund leakages, followed by product quality and damage claims.
* **Category Risk Gap:** Identified top high-risk product categories with excess return rate gaps, with Stationery (10.43%), Grocery (10.13%), and Books (9.34%) exhibiting the highest discrepancy between expected and actual return rates.

### 5. Payment Reliability
* **Payment Failures & Cancellations:** Evaluated status rates (Delivered, Cancelled, Returned, Failed) across UPI, COD, Credit/Debit cards, and Net Banking to monitor transaction drop-offs.

---

## 🛠️ Technical Stack & Implementation Details

* *Microsoft Excel (Advanced):*
  * Multi-dimensional **Pivot Tables** and **Calculated Fields**.
  * Custom **Data Modeling** and normalization across fulfillment, orders, and customer entities.
  * **Dynamic Cross-filtering** using multi-slicer synchronization (Category, Year, Customer Segment, Gender).
* *UI/UX & Layout Architecture:*
  * Clean 4-column structured grid system designed for single-screen 1080p executive viewing.
  * Dark Charcoal (#263238) and Slate Blue-Gray corporate visual aesthetic.
  * Embedded vector typography, card frames, and doughnut KPIs.

---

## 📁 Repository Structure

```text
├── E-Com_Dashboard_Preview.png        # High-resolution dashboard preview image
├── Ecommerce_analysis.zip             # Interactive Excel dashboard workbook (compressed)
├── Indian_Ecommerce_SQL_Query.sql     # SQL queries for database analysis & KPI extraction
└── README.md                          # Comprehensive project documentation
