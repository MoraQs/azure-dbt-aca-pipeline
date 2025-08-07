{{ config(materialized='view') }}

-- staging model for customer
select *
from {{ source('bronze', 'customer') }}
