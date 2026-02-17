{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'categories') }}

),

renamed as (

    select
        category_id,
        category_name

    from source

)

select * from renamed