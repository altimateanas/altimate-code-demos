-- Intermediate: customer sessions with profile data
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-22

SELECT
    s.*,
    c.first_name || ' ' || c.last_name as full_name,
    c.email,
    c.country,
    ROW_NUMBER() OVER (ORDER BY s.session_start) as session_sequence
FROM (
    SELECT * FROM {{ ref('stg_sessions') }} WHERE device_type = 'desktop'
) s
LEFT JOIN {{ ref('stg_customers') }} c
    ON s.user_id = c.id

UNION

SELECT
    s.*,
    c.first_name || ' ' || c.last_name as full_name,
    c.email,
    c.country,
    ROW_NUMBER() OVER (ORDER BY s.session_start) as session_sequence
FROM (
    SELECT * FROM {{ ref('stg_sessions') }} WHERE device_type != 'desktop'
) s
LEFT JOIN {{ ref('stg_customers') }} c
    ON s.user_id = c.id

ORDER BY session_start