-- Intermediate: customer sessions with profile data

SELECT
    s.*,
    c.first_name || ' ' || c.last_name as full_name,
    c.country
FROM (
    SELECT * FROM {{ ref('stg_sessions') }} WHERE device_type = 'desktop'
) s
LEFT JOIN {{ ref('stg_customers') }} c
    ON s.user_id = c.id

UNION

SELECT
    s.*,
    c.first_name || ' ' || c.last_name as full_name,
    c.country
FROM (
    SELECT * FROM {{ ref('stg_sessions') }} WHERE device_type != 'desktop'
) s
LEFT JOIN {{ ref('stg_customers') }} c
    ON s.user_id = c.id

ORDER BY session_start
