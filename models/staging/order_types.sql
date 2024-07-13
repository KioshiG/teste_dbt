with 
    source as (
        select
            id as order_types_id
            ,case
                when type = 'sales' then 'VENDAS'
                when type = 'technical_review' then 'REVISAO TECNICA'
                when type = 'preventive_maintenance' then 'MANUTENCAO PREVENTIVA'
                when type = 'body_shop' then 'LOJA'
                else 'OUTROS'
                end as type

        from {{source('sales_car', 'order_types')}}
    )

select * from source