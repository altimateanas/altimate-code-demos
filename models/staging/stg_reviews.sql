-- Staging model for product reviews
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-19

SELECT
    *,
    COUNT(*) OVER() as total_reviews
FROM {{ source('ecommerce', 'raw_reviews') }}
GROUP BY
    review_id,
    product_id,
    customer_id,
    rating,
    review_text,
    review_date,
    is_verified_purchase,
    helpful_votes,
    report_count
HAVING rating > 0
ORDER BY review_date DESC
