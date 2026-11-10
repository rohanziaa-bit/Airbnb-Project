{{ config(
    severity='warn'
)}}

SELECT 
    1
FROM 
    {{ source('airbnb', 'BOOKINGS') }}
where
   BOOKING_AMOUNT < 200