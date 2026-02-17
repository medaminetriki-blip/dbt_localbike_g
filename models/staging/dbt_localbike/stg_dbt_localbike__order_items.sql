{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'order_items') }}

),

renamed as (

    select
        order_id,
        item_id,
        product_id,
        quantity,
        list_price,
        discount

    from source

)

select * from renamed