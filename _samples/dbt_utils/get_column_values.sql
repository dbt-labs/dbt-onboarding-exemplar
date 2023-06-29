{# https://github.com/dbt-labs/dbt-utils/tree/1.1.0/#get_column_values-source #}

{%- set payment_methods = dbt_utils.get_column_values(table=ref('stg_stripe__payments'), column='payment_method') -%}

select 
    order_id,
    {% for payment_method in payment_methods %}
        sum(case when payment_method = '{{ payment_method }}' then amount else 0 end) as {{ payment_method }}_amount 
        {%- if not loop.last -%},{%- endif -%}
    {% endfor %}

from {{ ref('stg_stripe__payments') }}

group by 1