{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    unique_key='event_id', 
    event_time='event_timestamp',
    begin='2023-01-01',
    batch_size='day'
) }}
    
with source as (
    select * from {{ ref('example_source_for_incremental') }}
)

select *
from source