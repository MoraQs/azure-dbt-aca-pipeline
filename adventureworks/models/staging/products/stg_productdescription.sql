{{ config(materialized='view') }}

-- staging model for productdescription
select *
from {{ source('bronze', 'productdescription') }}
