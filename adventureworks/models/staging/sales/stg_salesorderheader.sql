{{ config(materialized='view') }}

-- staging model for salesorderheader
select *
from {{ source('bronze', 'salesorderheader') }}
