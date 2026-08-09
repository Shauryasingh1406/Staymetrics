{{ config(
    schema='bronze'
) }}

select * from {{source('STAGING','HOSTS')}}