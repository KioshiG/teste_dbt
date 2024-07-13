with 
    source as (
        select
            id
            ,order_id
            ,order_type_id
            ,split(upper(item), '@~|~@') as item
            ,ARRAY_LENGTH (REGEXP_EXTRACT_ALL(item, '@~\\|~@')) as occurrences
        from {{ source('sales_car', 'order_items') }}

    ),
    treated as (
        select distinct
             id as order_item_id
            ,order_id
            ,order_type_id
            ,item[OFFSET(0)] as manufacturer
            ,item[OFFSET(1)] as model
            ,item[OFFSET(2)] as year_manufacturer
            ,item[OFFSET(3)] as color
            ,item[OFFSET(4)] as status
            ,item[OFFSET(5)] as price
        from source where occurrences = 5

    )

select * from treated
