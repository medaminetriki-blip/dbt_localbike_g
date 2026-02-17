{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'brands') }}

),

renamed as (

    select
        brand_id,
        brand_name

    from source

)

select * from renamed