-- Intermediate: sessions joined with customer profile

SELECT
    s.session_id,
    s.user_id,
    s.session_start,
    s.session_end,
    s.landing_page,
    s.exit_page,
    s.page_views,
    s.device_type,
    s.browser,
    s.referrer_source,
    s.is_converted,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    c.country
FROM {{ ref('stg_sessions') }} AS s
LEFT JOIN {{ ref('stg_customers') }} AS c
    ON s.user_id = c.id