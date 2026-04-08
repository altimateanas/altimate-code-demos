-- Staging model for web sessions
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-20

WITH filtered AS (
    SELECT *
    FROM {{ source('ecommerce', 'raw_sessions') }}
)

SELECT *
FROM {{ source('ecommerce', 'raw_sessions') }}
WHERE session_end IS NOT NULL
ORDER BY session_start
