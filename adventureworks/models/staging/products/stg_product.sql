{{ config(materialized='view') }}

-- staging model for product
select *
from {{ source('bronze', 'product') }}
