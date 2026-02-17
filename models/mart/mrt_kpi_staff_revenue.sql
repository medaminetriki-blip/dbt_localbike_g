{{ config(materialized='table') }}

with sales as (
    select *
    from {{ ref('int_sales_enriched') }}
),

staff_store_month as (
    select
        staff_id,
        staff_first_name,
        staff_last_name,
        store_id,
        store_name,
        date_trunc(order_date, month) as month,
        sum(net_revenue)              as revenue_staff_store_month,
        sum(quantity)                 as quantity_staff_store_month,
        count(distinct order_id)      as orders_staff_store_month
    from sales
    group by 1, 2, 3, 4, 5, 6
)

select *
from staff_store_month