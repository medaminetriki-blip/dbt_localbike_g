{{ config(materialized='view') }}
with 

source as (

    select * from {{ source('dbt_localbike', 'staffs') }}

),

renamed as (

    select
        staff_id,
        first_name,
        last_name,
        email,
        phone,
        active,
        store_id,
        manager_id

    from source

)

select * from renamed