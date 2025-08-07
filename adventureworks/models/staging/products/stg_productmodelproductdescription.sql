{{ config(materialized='view') }}

-- staging model for productmodelproductdescription
select *
from {{ source('bronze', 'productmodelproductdescription') }}
