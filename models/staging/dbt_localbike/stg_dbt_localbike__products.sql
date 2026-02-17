{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'products') }}

),

renamed as (

    select
        product_id,
        product_name,
        brand_id,
        category_id,
        model_year,
        list_price

    from source

)

select * from renamed