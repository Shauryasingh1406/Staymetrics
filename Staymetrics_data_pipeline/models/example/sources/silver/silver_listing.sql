{{ config(
    materialized='incremental',
    schema='silver',
    unique_key='LISTING_ID'
) }}
select 
LISTING_ID,
PROPERTY_TYPE, 
HOST_ID,
ROOM_TYPE , 
CITY ,
COUNTRY , 
BEDROOMS , 
BATHROOMS,
PRICE_PER_NIGHT , 
{{tag('price_per_night')}} as PRICE_PER_NIGHT_TAG , 
CREATED_AT
 FROM {{ ref ('bronze_listings')}}