{{ config(materialized='incremental' )}}

SELECT * FROM {{ source('airbnb','BOOKINGS')}}

{% if is_incremental() %}
    where CREATED_AT > (SELECT
    COALESCE(MAX(CREATED_AT), '1900-01-01') FROM {{ this }})
{% endif %}