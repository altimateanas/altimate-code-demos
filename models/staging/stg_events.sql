-- Staging model for user events
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-16
-- TODO: this is slow but works for now

SELECT *
FROM {{ source('ecommerce', 'raw_events') }}
WHERE event_date > '2024-01-01'
ORDER BY event_timestamp
