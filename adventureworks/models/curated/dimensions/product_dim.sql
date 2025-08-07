
with

prod_cte as (

	select

		prd.ProductID as productId,
		prd.ProductModelID as productModelId,
		prd.Name as productName,
		prd.ProductNumber as productNumber,
		prd.Color as productColor,
		prd.Size as productSize,
		cat.Name as productCategory

	from

		{{ ref('stg_product') }} as prd

	left join
		{{ ref('stg_productcategory') }} as cat 
        on prd.ProductCategoryID = cat.ProductCategoryID

),

prod_model_cte as (

	select

		des.ProductModelId as productModelId,
		mod.Name as modelName,
		pde.Description as modelDesc

	from 
		{{ ref('stg_productmodelproductdescription') }} as des 

	left join 
		{{ ref('stg_productmodel') }} as mod 
        on des.ProductModelId = mod.ProductModelId

	left join 
		{{ ref('stg_productdescription') }} pde 
        on des.ProductDescriptionID = pde.ProductDescriptionID
	where des.Culture IN ('en')

),

prod_join as (

	select
	
		pd.productId,
		pd.productName,
		pd.productNumber,
		pd.productColor,
		pd.productSize,
		pd.productCategory,
		md.modelName,
		md.modelDesc
	from 
		prod_cte as pd 
	left join 
		prod_model_cte as md on pd.productModelId = md.productModelId

)

select * from prod_join