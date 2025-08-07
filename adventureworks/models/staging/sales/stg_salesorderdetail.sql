{{ config(materialized='view') }}

-- staging model for salesorderdetail
select *
from {{ source('bronze', 'salesorderdetail') }}
