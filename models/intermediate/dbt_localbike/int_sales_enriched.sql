{{ config(materialized='view') }}

with orders as (
    select *
    from {{ ref('stg_dbt_localbike__orders') }}
    where is_completed -- status = 4, commandes livrées
),

items as (
    select
        order_id,
        item_id as order_item_id,
        product_id,
        quantity,
        list_price,
        discount,
        -- revenu net ligne : prix * qty * (1 - remise)
        list_price * quantity * (1 - discount) as net_revenue
    from {{ ref('stg_dbt_localbike__order_items') }}
),

products as (
    select
        p.product_id,
        p.product_name,
        p.category_id,
        c.category_name,
        p.brand_id
    from {{ ref('stg_dbt_localbike__products') }} p
    left join {{ ref('stg_dbt_localbike__categories') }} c
      on p.category_id = c.category_id
),

stores as (
    select
        store_id,
        store_name
    from {{ ref('stg_dbt_localbike__stores') }}
),

staffs as (
    select
        staff_id,
        first_name,
        last_name
    from {{ ref('stg_dbt_localbike__staffs') }}
),

joined as (
    select
        i.order_item_id,
        o.order_id,
        o.order_date,
        o.store_id,
        s.store_name,
        o.staff_id,
        st.first_name as staff_first_name,
        st.last_name  as staff_last_name,
        i.product_id,
        p.product_name,
        p.category_id,
        p.category_name,
        i.quantity,
        i.list_price,
        i.discount,
        i.net_revenue
    from items i
    join orders o on i.order_id = o.order_id
    join stores s on o.store_id = s.store_id
    left join staffs st on o.staff_id = st.staff_id
    left join products p on i.product_id = p.product_id
)

select *
from joined