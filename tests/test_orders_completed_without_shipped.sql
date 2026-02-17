select *
from {{ ref('stg_dbt_localbike__orders') }}
where order_status = 4
  and shipped_date is null
