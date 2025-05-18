{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    unique_key='event_id',
    event_time='event_timestamp',
    begin='2025-01-01T00:08:20-08:00',
    batch_size='hour'
) }}

with source as (
    select * from {{ ref('example_source_for_incremental') }}
)

select *
from source