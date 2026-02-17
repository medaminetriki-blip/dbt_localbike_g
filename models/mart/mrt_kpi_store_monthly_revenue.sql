{{ config(materialized='table') }}

with sales as (
    select *
    from {{ ref('int_sales_enriched') }}
),

store_month as (
    select
        store_id,
        store_name,
        date_trunc(order_date, month) as month,
        sum(net_revenue)              as revenue_store_month,
        sum(quantity)                 as quantity_store_month,
        count(distinct order_id)      as orders_store_month
    from sales
    group by 1, 2, 3
)

select *
from store_month