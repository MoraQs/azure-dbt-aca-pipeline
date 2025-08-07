{{
    config(
        materialized='incremental',
        unique_key='salesOrderDetails',
        incremental_strategy='merge'
    )
}}

with sales_cte as (

    select
        ord.SalesOrderID as orderId,
        ord.SalesOrderDetailID as salesOrderDetails,
        ord.ProductID as productId,
        ord.UnitPrice as unitPrice,
        ord.OrderQty as orderQuantity,
        ord.UnitPriceDiscount as priceDiscount,
        case when ord.UnitPriceDiscount > 0 then 'true' else 'false' end as isDiscounted,
        cast(odd.OrderDate as date) as orderDate,
        cast(odd.DueDate as date) as dueDate,
        cast(odd.ShipDate as date) as shipDate,
        case when odd.Status = '5' then 'Delivered' else 'Pending' end as orderStatus,
        odd.CustomerID as customerId,
        odd.ShipMethod as shipmentMethod
    from 
        {{ ref('stg_salesorderdetail') }} as ord
    left join 
        {{ ref('stg_salesorderheader') }} as odd
        on ord.SalesOrderID = odd.SalesOrderID
    {% if is_incremental() %}
        where odd.OrderDate > (
            select coalesce(max(orderDate), '1900-01-01') 
            from {{ this }}
        )
    {% endif %}
)

select * 
from sales_cte
