# 🏆 Data Catalog: Gold Layer

## Overview
The **Gold Layer** represents the refined, business-level data tier. It is structured using a **Star Schema** (Dimensions and Facts) to support high-performance analytics, BI reporting, and self-service discovery.



---

## 🏗️ Data Models

### 1. `gold.dim_customers`
**Purpose:** Acts as the primary source of truth for customer information, enriched with demographic and geographic attributes for segmentation.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **customer_key** | `INT` | **Primary Key.** Surrogate key uniquely identifying each customer record. |
| **customer_id** | `INT` | Unique numerical identifier from the source system. |
| **customer_number**| `NVARCHAR(50)`| Alphanumeric identifier used for tracking and business referencing. |
| **first_name** | `NVARCHAR(50)`| The customer's first name. |
| **last_name** | `NVARCHAR(50)`| The customer's last name or family name. |
| **country** | `NVARCHAR(50)`| Country of residence (e.g., 'Australia'). |
| **marital_status** | `NVARCHAR(50)`| Marital status (e.g., 'Married', 'Single'). |
| **gender** | `NVARCHAR(50)`| Customer gender (e.g., 'Male', 'Female', 'n/a'). |
| **birthdate** | `DATE` | Date of birth (YYYY-MM-DD). |
| **create_date** | `DATE` | Timestamp when the record was first created in the system. |

---

### 2. `gold.dim_products`
**Purpose:** Provides a comprehensive view of the product catalog, including hierarchy (Category/Subcategory) and pricing metadata.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **product_key** | `INT` | **Primary Key.** Surrogate key for the product dimension. |
| **product_id** | `INT` | Unique internal identifier for tracking. |
| **product_number** | `NVARCHAR(50)`| Structured alphanumeric code (SKU) for inventory. |
| **product_name** | `NVARCHAR(50)`| Descriptive name including type, color, and size. |
| **category_id** | `NVARCHAR(50)`| Unique identifier for high-level classification. |
| **category** | `NVARCHAR(50)`| Broad classification (e.g., Bikes, Components). |
| **subcategory** | `NVARCHAR(50)`| Detailed classification (e.g., Mountain Bikes, Road Bikes). |
| **maintenance_required**| `NVARCHAR(50)`| Flag indicating if the product needs servicing ('Yes'/'No'). |
| **cost** | `INT` | Base cost price in monetary units. |
| **product_line** | `NVARCHAR(50)`| Specific series (e.g., Road, Mountain, Touring). |
| **start_date** | `DATE` | The date the product became available for sale. |

---

### 3. `gold.fact_sales`
**Purpose:** The central fact table containing transactional metrics. Designed to be joined with dimension tables for granular analysis.

| Column Name | Data Type | Description |
| :--- | :--- | :--- |
| **order_number** | `NVARCHAR(50)`| Unique identifier for the sales order (e.g., 'SO54496'). |
| **product_key** | `INT` | **Foreign Key.** Links to `gold.dim_products`. |
| **customer_key** | `INT` | **Foreign Key.** Links to `gold.dim_customers`. |
| **order_date** | `DATE` | The date the order was placed. |
| **shipping_date** | `DATE` | The date the order was shipped. |
| **due_date** | `DATE` | The date payment was due. |
| **sales_amount** | `INT` | Total monetary value for the line item. |
| **quantity** | `INT` | Number of units ordered. |
| **price** | `INT` | Price per unit for the line item. |

> [!TIP]
> **Join Logic:** To calculate total sales by country, join `fact_sales` to `dim_customers` on `customer_key`.
