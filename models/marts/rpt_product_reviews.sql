-- Report: product review summary
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-26

SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(*) as review_count,
    AVG(r.rating) as avg_rating,
    SUM(r.helpful_votes) as total_helpful_votes,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) as rating_rank,
    CASE
        WHEN AVG(r.rating) >= 4.5 THEN 'excellent'
        WHEN AVG(r.rating) >= 3.5 THEN 'good'
        WHEN AVG(r.rating) >= 2.5 THEN 'average'
        ELSE 'poor'
    END as rating_category
FROM {{ source('ecommerce', 'raw_products') }} p
LEFT JOIN {{ ref('stg_reviews') }} r
    ON p.product_id = r.product_id
WHERE r.rating IS NOT NULL
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY avg_rating DESC
