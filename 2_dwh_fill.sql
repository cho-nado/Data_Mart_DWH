------------------------------------------------------------------------------
-- loading d_craftsmans
------------------------------------------------------------------------------
INSERT INTO dwh.d_craftsmans (
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    load_dttm
)
OVERRIDING SYSTEM VALUE
SELECT
    final_data.craftsman_id,
    final_data.craftsman_name,
    final_data.craftsman_address,
    final_data.craftsman_birthday,
    final_data.craftsman_email,
    final_data.load_dttm
FROM (
    SELECT DISTINCT ON (md.craftsman_id)
        md.craftsman_id,
        md.craftsman_name,
        md.craftsman_address,
        md.craftsman_birthday,
        md.craftsman_email,
        md.load_dttm
    FROM (
        SELECT
            s1.craftsman_id,
            s1.craftsman_name,
            s1.craftsman_address,
            s1.craftsman_birthday,
            s1.craftsman_email,
            NOW() AS load_dttm,
            1 AS priority_marker
        FROM source1.craft_market_wide s1

        UNION ALL

        SELECT
            s2.craftsman_id,
            s2.craftsman_name,
            s2.craftsman_address,
            s2.craftsman_birthday,
            s2.craftsman_email,
            NOW() AS load_dttm,
            2 AS priority_marker
        FROM source2.craft_market_masters_products s2

        UNION ALL

        SELECT
            s3.craftsman_id,
            s3.craftsman_name,
            s3.craftsman_address,
            s3.craftsman_birthday,
            s3.craftsman_email,
            NOW() AS load_dttm,
            3 AS priority_marker
        FROM source3.craft_market_craftsmans s3
    ) AS md
    ORDER BY
        md.craftsman_id,
        md.priority_marker
) AS final_data
ON CONFLICT (craftsman_id)
DO UPDATE
SET
    craftsman_name     = EXCLUDED.craftsman_name,
    craftsman_address  = EXCLUDED.craftsman_address,
    craftsman_birthday = EXCLUDED.craftsman_birthday,
    craftsman_email    = EXCLUDED.craftsman_email,
    load_dttm          = EXCLUDED.load_dttm;


------------------------------------------------------------------------------
-- loading d_customers
------------------------------------------------------------------------------
INSERT INTO dwh.d_customers (
    customer_id,
    customer_name,
    customer_address,
    customer_birthday,
    customer_email,
    load_dttm
)
OVERRIDING SYSTEM VALUE
SELECT
    final_data.customer_id,
    final_data.customer_name,
    final_data.customer_address,
    final_data.customer_birthday,
    final_data.customer_email,
    final_data.load_dttm
FROM (
    SELECT DISTINCT ON (md.customer_id)
        md.customer_id,
        md.customer_name,
        md.customer_address,
        md.customer_birthday,
        md.customer_email,
        md.load_dttm
    FROM (
        SELECT
            w.customer_id,
            w.customer_name,
            w.customer_address,
            w.customer_birthday,
            w.customer_email,
            NOW() AS load_dttm,
            1 AS priority_marker
        FROM source1.craft_market_wide w

        UNION ALL

        SELECT
            c2.customer_id,
            c2.customer_name,
            c2.customer_address,
            c2.customer_birthday,
            c2.customer_email,
            NOW() AS load_dttm,
            2 AS priority_marker
        FROM source2.craft_market_orders_customers c2

        UNION ALL

        SELECT
            c3.customer_id,
            c3.customer_name,
            c3.customer_address,
            c3.customer_birthday,
            c3.customer_email,
            NOW() AS load_dttm,
            3 AS priority_marker
        FROM source3.craft_market_customers c3
    ) AS md
    ORDER BY
        md.customer_id,
        md.priority_marker
) AS final_data
ON CONFLICT (customer_id)
DO UPDATE
SET
    customer_name     = EXCLUDED.customer_name,
    customer_address  = EXCLUDED.customer_address,
    customer_birthday = EXCLUDED.customer_birthday,
    customer_email    = EXCLUDED.customer_email,
    load_dttm         = EXCLUDED.load_dttm;


------------------------------------------------------------------------------
-- loading d_products
------------------------------------------------------------------------------
INSERT INTO dwh.d_products (
    product_id,
    product_name,
    product_description,
    product_type,
    product_price,
    load_dttm
)
OVERRIDING SYSTEM VALUE
SELECT
    final_data.product_id,
    final_data.product_name,
    final_data.product_description,
    final_data.product_type,
    final_data.product_price,
    final_data.load_dttm
FROM (
    SELECT DISTINCT ON (md.product_id)
        md.product_id,
        md.product_name,
        md.product_description,
        md.product_type,
        md.product_price,
        md.load_dttm
    FROM (
        SELECT
            w.product_id,
            w.product_name,
            w.product_description,
            w.product_type,
            w.product_price,
            NOW() AS load_dttm,
            1 AS priority_marker
        FROM source1.craft_market_wide w

        UNION ALL

        SELECT
            mp.product_id,
            mp.product_name,
            mp.product_description,
            mp.product_type,
            mp.product_price,
            NOW() AS load_dttm,
            2 AS priority_marker
        FROM source2.craft_market_masters_products mp

        UNION ALL

        SELECT
            o.product_id,
            o.product_name,
            o.product_description,
            o.product_type,
            o.product_price,
            NOW() AS load_dttm,
            3 AS priority_marker
        FROM source3.craft_market_orders o
    ) AS md
    ORDER BY
        md.product_id,
        md.priority_marker
) AS final_data
ON CONFLICT (product_id)
DO UPDATE
SET
    product_name        = EXCLUDED.product_name,
    product_description = EXCLUDED.product_description,
    product_type        = EXCLUDED.product_type,
    product_price       = EXCLUDED.product_price,
    load_dttm           = EXCLUDED.load_dttm;


------------------------------------------------------------------------------
-- loading f_orders
------------------------------------------------------------------------------
INSERT INTO dwh.f_orders (
    order_id,
    product_id,
    craftsman_id,
    customer_id,
    order_created_date,
    order_completion_date,
    order_status,
    load_dttm
)
OVERRIDING SYSTEM VALUE
SELECT
    final_data.order_id,
    final_data.product_id,
    final_data.craftsman_id,
    final_data.customer_id,
    final_data.order_created_date,
    final_data.order_completion_date,
    final_data.order_status,
    final_data.load_dttm
FROM (
    SELECT DISTINCT ON (md.order_id)
        md.order_id,
        md.product_id,
        md.craftsman_id,
        md.customer_id,
        md.order_created_date,
        md.order_completion_date,
        md.order_status,
        md.load_dttm
    FROM (
        SELECT
            w.order_id,
            w.product_id,
            w.craftsman_id,
            w.customer_id,
            w.order_created_date,
            w.order_completion_date,
            w.order_status,
            NOW() AS load_dttm,
            1 AS priority_marker
        FROM source1.craft_market_wide w

        UNION ALL

        SELECT
            o2.order_id,
            o2.product_id,
            o2.craftsman_id,
            o2.customer_id,
            o2.order_created_date,
            o2.order_completion_date,
            o2.order_status,
            NOW() AS load_dttm,
            2 AS priority_marker
        FROM source2.craft_market_orders_customers o2

        UNION ALL

        SELECT
            o3.order_id,
            o3.product_id,
            o3.craftsman_id,
            o3.customer_id,
            o3.order_created_date,
            o3.order_completion_date,
            o3.order_status,
            NOW() AS load_dttm,
            3 AS priority_marker
        FROM source3.craft_market_orders o3
    ) AS md
    ORDER BY
        md.order_id,
        md.priority_marker
) AS final_data
ON CONFLICT (order_id)
DO UPDATE
SET
    order_created_date    = EXCLUDED.order_created_date,
    order_completion_date = EXCLUDED.order_completion_date,
    order_status          = EXCLUDED.order_status,
    load_dttm             = EXCLUDED.load_dttm;
