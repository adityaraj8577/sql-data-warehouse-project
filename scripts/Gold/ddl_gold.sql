--------------------------------------------------------------------------
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS

SELECT 
ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
ci.cst_id AS customer_id,
ci.cst_key AS customer_number,
ci.cst_firstname AS first_name,
ci.cst_lastname AS last_name,
la.cntry AS country,
ci.cst_marital_status AS marital_status,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is master for gender Info
	 ELSE COALESCE(ca.gen, 'n/a') -- it is known as data integration
END AS gender,
ca.bdate AS birthday,
ci.cst_create_date AS create_date
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid -- It is dimension table bcz 
--------------------------------------------------------------


--SELECT * FROM silver.crm_cust_info
--SELECT * FROM silver.erp_cust_az12
--SELECT * FROM silver.erp_loc_a101

-- Surrogate keys are the system generated unique identifier assigned to each record in a table and we will use windwo function to generate
---------------------------------------------------------------------------

-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS

SELECT 
ROW_NUMBER() OVER(ORDER BY prd_start_dt) AS product_key,
pn.prd_id AS product_id,
pn.prd_key AS product_number,
pn.prd_nm AS product_name,
pn.cat_id AS category_id,
pc.cat as category,
pc.subcat AS subcategory,
pc.maintenance AS maintenance,
pn.prd_cost AS cost,
pn.prd_line AS product_line,
pn.prd_start_dt AS start_date

FROM silver.crm_prd_info AS pn-- here if end data is NULL then it is the current info the product

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filters out all historical data 


---------------------------------------------------------

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO
CREATE VIEW gold.fact_sales AS

SELECT
    sd.sls_ord_num  AS order_number,
    pr.product_key  AS product_key, -- 1
    cu.customer_key AS customer_key, --2 these 1 and 2 are the dimension keys
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt  AS shipping_date,
    sd.sls_due_dt   AS due_date,
    sd.sls_sales    AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price    AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
GO
-- first 3 columns are dimensions next 3 are dates next three are measures
