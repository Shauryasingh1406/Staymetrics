{{ config(
    materialized='incremental',
    schema='gold',
) }}



{% set configs = [
    {
        "model": "silver_bookings",
        "columns": "silver_bookings.*",
        "alias": "silver_bookings"
    },
    {
        "model": "silver_listing",
        "columns": "silver_listing.HOST_ID, silver_listing.PROPERTY_TYPE, silver_listing.ROOM_TYPE, silver_listing.CITY, silver_listing.COUNTRY, silver_listing.BEDROOMS, silver_listing.BATHROOMS, silver_listing.PRICE_PER_NIGHT, silver_listing.PRICE_PER_NIGHT_TAG, silver_listing.CREATED_AT AS LISTING_CREATED_AT",
        "alias": "silver_listing",
        "join_condition": "silver_bookings.LISTING_ID = silver_listing.LISTING_ID"
    },
    {
        "model": "silver_hosts",
        "columns": "silver_hosts.HOST_NAME, silver_hosts.HOST_SINCE, silver_hosts.IS_SUPERHOST, silver_hosts.RESPONSE_RATE, silver_hosts.RESPONSE_RATE_QUALITY, silver_hosts.CREATED_AT AS HOST_CREATED_AT",
        "alias": "silver_hosts",
        "join_condition": "silver_listing.HOST_ID = silver_hosts.HOST_ID"
    }
] %}


SELECT
    {% for config in configs %}
        {{ config['columns'] }}{% if not loop.last %},{% endif %}
    {% endfor %}

FROM
    {% for config in configs %}
        {% if loop.first %}
            {{ ref(config['model']) }} AS {{ config['alias'] }}
        {% else %}
            LEFT JOIN {{ ref(config['model']) }} AS {{ config['alias'] }}
                ON {{ config['join_condition'] }}
        {% endif %}
    {% endfor %}


