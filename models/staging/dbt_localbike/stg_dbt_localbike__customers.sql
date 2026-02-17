{{ config(materialized='view') }}

with source as (
    select * 
    from {{ source('dbt_localbike', 'customers') }}
),

cleaned as (
    select
        customer_id,
        -- noms
        trim(first_name) as first_name,
        trim(last_name)  as last_name,
        concat(trim(first_name), ' ', trim(last_name)) as customer_full_name,
        
        -- contact
        nullif(trim(phone), '') as phone,
        lower(trim(email))      as email,
        
        -- adresse
        trim(street) as street,
        trim(city)   as city,
        upper(trim(state)) as state,
        -- zip en string pour garder les zéros éventuels
        lpad(cast(zip_code as string), 5, '0') as zip_code,
        
        -- dérivé
        case 
            when phone is null then false 
            else true 
        end as has_phone
    from source
)

select * 
from cleaned