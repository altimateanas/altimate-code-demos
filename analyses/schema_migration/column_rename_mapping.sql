-- Schema Migration: Column Rename Mapping
-- Use Case #9: Documenting all column changes for the migration

-- This analysis documents the planned schema changes from the upstream app team
-- Use this to trace lineage and find all affected models before the migration

WITH column_changes AS (
    SELECT 'raw_customers' AS table_name, 'first_name' AS old_column, 'given_name' AS new_column, 'Sprint 42 - User model refactor' AS change_reason
    UNION ALL SELECT 'raw_customers', 'last_name', 'family_name', 'Sprint 42 - User model refactor'
    UNION ALL SELECT 'raw_customers', 'created_at', 'registered_at', 'Sprint 42 - Clarify timestamp semantics'
    UNION ALL SELECT 'raw_customers', 'status', 'account_status', 'Sprint 42 - Avoid reserved word conflicts'
    UNION ALL SELECT 'raw_orders', 'customer_id', 'cust_id', 'Sprint 43 - Standardize FK naming'
    UNION ALL SELECT 'raw_orders', 'order_date', 'placed_at', 'Sprint 43 - Clarify timestamp semantics'
    UNION ALL SELECT 'raw_orders', 'amount', 'order_total', 'Sprint 43 - Clarify what amount means'
    UNION ALL SELECT 'raw_payments', 'amount', 'payment_amount', 'Sprint 44 - Disambiguate from order amount'
    UNION ALL SELECT 'raw_payments', 'tax_amount', 'tax_total', 'Sprint 44 - Consistency with payment_amount'
    UNION ALL SELECT 'raw_payments', 'created_at', 'processed_at', 'Sprint 44 - Clarify timestamp semantics'
)

SELECT
    table_name,
    old_column,
    new_column,
    change_reason,
    '-- In staging model: ' || new_column || ' AS ' || old_column AS suggested_alias
FROM column_changes
ORDER BY table_name, old_column
