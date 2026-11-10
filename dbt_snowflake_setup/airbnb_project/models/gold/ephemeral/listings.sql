{{ 
    config(
        materialized = 'ephemeral'
    )
}}

WITH listings as (
    SELECT 
         LISTING_ID,
         PROPERTY_TYPE,
         ROOM_TYPE,
         CITY,
         COUNTRY,
         PRICE_PER_NIGHT_TAG,
         LISTING_CREATED
     FROM 
          {{ ref('obt')}}

    
)
SELECT * FROM listings