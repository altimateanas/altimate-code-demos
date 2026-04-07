-- Intermediate: products joined with latest inventory snapshot and review metrics

SELECT
    p.product_id,
    p.product_name,
    p.category,
    p.price,
    p.created_at,
    p.is_active,
    p.weight_kg,
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
    r.review_count
FROM {{ ref('stg_products') }} AS p
LEFT JOIN {{ ref('stg_inventory') }} AS i
    ON p.product_id = i.product_id
    AND i.snapshot_date = (SELECT MAX(snapshot_date) FROM {{ ref('stg_inventory') }})
LEFT JOIN (
    SELECT
        product_id,
        AVG(rating) AS avg_rating,
        COUNT(*) AS review_count
    FROM {{ ref('stg_reviews') }}
    GROUP BY product_id
) AS r
    ON p.product_id = r.product_id