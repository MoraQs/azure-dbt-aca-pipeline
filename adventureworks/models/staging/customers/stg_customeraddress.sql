{{ config(materialized='view') }}

-- staging model for customeraddress
select *
from {{ source('bronze', 'customeraddress') }}
