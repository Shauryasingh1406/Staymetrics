{{ config(
    materialized='incremental',
    schema='bronze',
    incremental_strategy='merge'
) }}

SELECT *
FROM {{ source('STAGING', 'BOOKINGS') }}

{% if is_incremental() %}
    WHERE CREATED_AT > (
        SELECT COALESCE(
            MAX(CREATED_AT),
            '1900-01-01'
        )
        FROM {{ this }}
    )
{% endif %}