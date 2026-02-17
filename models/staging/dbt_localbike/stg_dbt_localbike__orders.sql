{{ config(materialized='view') }}

with source as (
    select * 
    from {{ source('dbt_localbike', 'orders') }}
),

typed as (
    select
        order_id,
        customer_id,
        order_status,
        cast(order_date    as date) as order_date,
        cast(required_date as date) as required_date,
        cast(shipped_date  as date) as shipped_date,
        store_id,
        staff_id
    from source
),

enriched as (
    select
        order_id,
        customer_id,
        order_status,
        case order_status
            when 1 then 'new'
            when 2 then 'in_progress'
            when 3 then 'cancelled'
            when 4 then 'completed'
            else 'unknown'
        end as order_status_label,
        order_date,
        required_date,
        shipped_date,
        store_id,
        staff_id,
        -- flags pratiques pour les analyses
        order_status = 4 as is_completed,
        order_status in (1,2) as is_open,
        order_status = 3 as is_cancelled
    from typed
)

select * 
from enriched