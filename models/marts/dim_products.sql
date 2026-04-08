-- Dimension table: product catalog with review stats

SELECT DISTINCT
    p.*,
    r.avg_rating,
    r.review_count
FROM {{ ref('stg_products') }} p
LEFT JOIN (
    SELECT
        product_id,
        SUM(rating) / COUNT(*) as avg_rating,
        COUNT(*) as review_count
    FROM {{ ref('stg_reviews') }}
    GROUP BY product_id
) r
    ON p.product_id = r.product_id
ORDER BY p.product_name
