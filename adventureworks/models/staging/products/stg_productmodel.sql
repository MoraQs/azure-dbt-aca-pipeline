{{ config(materialized='view') }}

-- staging model for productmodel
select *
from {{ source('bronze', 'productmodel') }}
