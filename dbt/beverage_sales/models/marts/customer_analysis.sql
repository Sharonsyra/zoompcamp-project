{{
    config(
        materialized='table'
    )
}}

WITH first_order AS (
    SELECT Customer_ID, MIN(Order_Date) AS first_order_date
    FROM {{ ref('fact_sales') }}
    GROUP BY Customer_ID
)

SELECT
    s.Customer_ID,
    s.Order_Date,
    CASE
        WHEN s.Order_Date = f.first_order_date THEN 'New Customer'
        ELSE 'Returning Customer'
    END AS customer_type,
    SUM(s.Total_Price) AS total_spent
FROM {{ ref('fact_sales') }} s
JOIN first_order f ON s.Customer_ID = f.Customer_ID
GROUP BY 1, 2, 3
