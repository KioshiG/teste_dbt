
with
    source as (
        select 
            id
            ,country_code
            ,upper(country) as country
            ,state
            ,upper(city) as city
            ,split(upper(name), '-') as name
            ,latitude
            ,longitude
            ,phone
        from {{ source('sales_car', 'company_branches') }}
    ),

    treated as (
        select distinct
            id as company_branches_id
            ,country_code
            ,country
            ,state
            ,city
            ,concat('LOJA - ',name[offset(1)]) as name
            ,latitude
            ,longitude
            ,phone
        from source
    )

    select * from treated