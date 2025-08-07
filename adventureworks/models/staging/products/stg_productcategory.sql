{{ config(materialized='view') }}

-- staging model for productcategory
select *
from {{ source('bronze', 'productcategory') }}
