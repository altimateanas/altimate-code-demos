-- Dimension table: product catalog with inventory and reviews
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-24
-- getting everything about products in one place

SELECT DISTINCT
    p.*,
    i.snapshot_id,
    i.warehouse_location,
    i.quantity_on_hand,
    i.quantity_reserved,
    i.reorder_point,
    i.snapshot_date,
    i.unit_cost,
    i.supplier_id,
    i.total_inventory,
    i.available_quantity,
    r.avg_rating,
    r.review_count,
    latest.latest_snapshot
FROM {{ source('ecommerce', 'raw_products') }} p
LEFT JOIN {{ ref('stg_inventory') }} i
    ON p.product_id = i.product_id
LEFT JOIN (
    SELECT
        product_id,
        AVG(rating) as avg_rating,
        COUNT(*) as review_count
    FROM {{ ref('stg_reviews') }}
    GROUP BY product_id
) r
    ON p.product_id = r.product_id
CROSS JOIN (
    SELECT MAX(snapshot_date) as latest_snapshot
    FROM {{ ref('stg_inventory') }}
) latest
WHERE i.snapshot_date = latest.latest_snapshot
ORDER BY p.product_name