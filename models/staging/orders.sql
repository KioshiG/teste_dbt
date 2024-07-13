with
    source as (
        select 
            id as order_id
            ,safe_cast(customer_id as INT64) as customer_id
            ,employee_id
            ,order_type_id
            ,order_date
            ,split(return_date, ' ') [OFFSET(0)] as return_date
            ,split(return_date, ' ') [OFFSET(0)] as return_hour_string
        from {{ source ('sales_car', 'orders')}}
    ),
    treated as (
        select
            order_id
            ,customer_id
            ,employee_id
            ,order_type_id
            ,order_date
            ,safe_cast(return_date as DATE) as return_date
            ,return_hour_string
            ,cast(SPLIT(return_date, '-') [OFFSET(0)] as INT64) as return_year
            ,cast(SPLIT(return_date, '-') [OFFSET(1)] as INT64) as return_month
       from source
       where customer_id is not null
    -- are found two nulls ids customers
    ),

    treated_dates as (
        select distinct
             order_id
            ,customer_id
            ,employee_id
            ,order_type_id
            ,order_date
            ,return_hour_string
            ,case 
                when return_date is null then last_day(DATE(return_year, return_month, 1), MONTH)
                else return_date
            end as return_date
        from treated
    ),

final as (
        select distinct
             order_id
            ,customer_id
            ,employee_id
            ,order_type_id
            ,cast(order_date as datetime) as order_date
            ,datetime(
                timestamp(
                    concat(cast(return_date as string), ' ', return_hour_string)
                )
            ) as return_date
            ,DATE_DIFF(
                 return_date,
                cast(order_date as DATE),
                DAY
            ) as days_diff
        from treated_dates
    )   

select * from final