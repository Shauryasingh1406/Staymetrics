{{ config(
    schema='bronze'
) }}

select * from {{source('STAGING','BOOKINGS')}}