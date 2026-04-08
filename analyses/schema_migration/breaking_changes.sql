-- Schema Migration: Breaking Changes Log
-- Use Case #9: "Someone Changed the Schema — What Broke?"
--
-- Scenario: The upstream app team renamed columns in the raw_customers table:
--   - first_name → given_name
--   - last_name → family_name
--   - created_at → registered_at
--   - status → account_status
--
-- And in raw_orders:
--   - customer_id → cust_id
--   - order_date → placed_at
--   - amount → order_total
--
-- This would break the following models (trace via lineage):
--
-- DIRECTLY AFFECTED (reference raw_customers columns):
--   1. stg_customers.sql - SELECT * would still work but downstream refs break
--   2. dim_customers.sql - references c.first_name, c.last_name
--   3. fct_order_summary.sql - references c.first_name, c.last_name, c.email
--   4. int_customer_sessions.sql - references c.first_name, c.last_name
--   5. rpt_customer_ltv.sql - references c.created_at in LTV calculation
--   6. rpt_monthly_sales.sql - references c.first_name, c.last_name
--
-- DIRECTLY AFFECTED (reference raw_orders columns):
--   7. stg_orders.sql - references customer_id, amount
--   8. fct_order_summary.sql - references o.customer_id, o.order_date
--   9. fct_daily_revenue.sql - references order_date, amount
--  10. dim_customers.sql - references customer_id in subquery
--  11. rpt_customer_ltv.sql - references o.customer_id, o.amount, o.order_date
--  12. rpt_monthly_sales.sql - references o.order_date, o.amount, o.customer_id
--
-- INDIRECTLY AFFECTED (depend on broken staging models):
--  13. int_orders_enriched.sql - depends on stg_orders
--  14. int_product_performance.sql - depends on stg_orders
--  15. fct_refunds.sql - depends on stg_orders via raw_orders
--  16. dim_promotions.sql - depends on stg_orders
--
-- TOTAL IMPACT: 16 models affected by 7 column renames across 2 tables
--
-- Fix strategy:
--   1. Update stg_customers to use explicit column list with aliases
--   2. Update stg_orders to use explicit column list with aliases
--   3. All downstream models remain unchanged (they reference staging aliases)
--   4. This is WHY staging layers with explicit columns matter

-- Example fix for stg_customers (what it should become):
SELECT
    id,
    given_name AS first_name,       -- renamed from first_name
    family_name AS last_name,       -- renamed from last_name
    email,
    registered_at AS created_at,    -- renamed from created_at
    account_status AS status,       -- renamed from status
    age,
    country
FROM {{ source('ecommerce', 'raw_customers') }}
WHERE account_status <> 'inactive'
