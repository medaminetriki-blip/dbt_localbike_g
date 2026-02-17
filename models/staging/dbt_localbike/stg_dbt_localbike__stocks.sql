{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'stocks') }}

),

renamed as (

    select
        store_id,
        product_id,
        quantity

    from source

)

select * from renamed