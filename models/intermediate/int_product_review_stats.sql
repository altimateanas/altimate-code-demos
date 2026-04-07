-- Intermediate: product-level review aggregation

SELECT
    product_id,
    AVG(rating) AS avg_rating,
    COUNT(*) AS review_count
FROM {{ ref('stg_reviews') }}
GROUP BY product_id