-- Staging model for inventory snapshots
-- Author: Jamie (Junior Data Engineer)
-- Date: 2025-03-20

SELECT
    *,
    SUM(quantity_on_hand) OVER() as total_inventory,
    quantity_on_hand - quantity_reserved as available_quantity
FROM {{ source('ecommerce', 'raw_inventory') }}
ORDER BY snapshot_date DESC
