with

address_cte as (

	select 
  
		c.CustomerID,
		c.AddressType,
		a.AddressLine1 as Address,
		a.City,
		a.CountryRegion as Country,
		a.StateProvince,
		a.PostalCode

	from 
        {{ ref('stg_customeraddress') }} as c  
	left join 
        {{ ref('stg_address') }} as a
		on c.AddressID = a.AddressID

),

customer_cte as(

	select

		customerID,
		concat_ws(' ', FirstName, MiddleName, LastName) as customerName,
		EmailAddress,
		Phone as PhoneNumber,
		CompanyName,
		SalesPerson

	from 
        {{ ref('stg_customer') }}

),

join_cte as (

	select

		cus.customerID as customerId,
		cus.customerName,
		cus.EmailAddress as emailAddress,
		cus.PhoneNumber as phoneNumber,
		cus.CompanyName as companyName,
		cus.SalesPerson as salesPerson,
		adr.Address,
		adr.AddressType as addressType,
		adr.City,
		adr.Country,
		adr.StateProvince as stateProvince,
		adr.PostalCode as postalCode

	from 
		customer_cte as cus
	left join 
		address_cte as adr on cus.CustomerID = adr.CustomerID

)

select * from join_cte