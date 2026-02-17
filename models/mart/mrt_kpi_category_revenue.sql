{{ config(materialized='table') }}

with sales as (
    select *
    from {{ ref('int_sales_enriched') }}
),

category_store_month as (
    select
        store_id,
        store_name,
        category_id,
        category_name,
        date_trunc(order_date, month) as month,
        sum(net_revenue)              as revenue_category_store_month,
        sum(quantity)                 as quantity_category_store_month,
        count(distinct order_id)      as orders_category_store_month
    from sales
    group by 1, 2, 3, 4, 5
)

select *
from category_store_month