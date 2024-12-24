-------------------------------------------------------------------------------
-- updating data mart craftsman_report_datamart
-------------------------------------------------------------------------------
INSERT INTO dwh.craftsman_report_datamart (
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    craftsman_money,
    platform_money,
    count_order,
    avg_price_order,
    avg_age_customer,
    median_time_order_completed,
    top_product_category,
    count_order_created,
    count_order_in_progress,
    count_order_delivery,
    count_order_done,
    count_order_not_done,
    report_period
)
SELECT
    cm.craftsman_id,
    cm.craftsman_name,
    cm.craftsman_address,
    cm.craftsman_birthday,
    cm.craftsman_email,
    SUM(pd.product_price * 0.9)        AS craftsman_money,
    SUM(pd.product_price * 0.1)        AS platform_money,
    COUNT(fo.order_id)                 AS count_order,
    AVG(pd.product_price)              AS avg_price_order,
    AVG(DATE_PART('year', AGE(cu.customer_birthday))) AS avg_age_customer,
    PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY (fo.order_completion_date - fo.order_created_date))
        AS median_time_order_completed,
    (
        SELECT pr.product_type
        FROM dwh.d_products pr
        JOIN dwh.f_orders ordr ON pr.product_id = ordr.product_id
        WHERE ordr.craftsman_id = cm.craftsman_id
        GROUP BY pr.product_type
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS top_product_category,
    COUNT(CASE WHEN fo.order_status = 'created'     THEN 1 END) AS count_order_created,
    COUNT(CASE WHEN fo.order_status = 'in progress' THEN 1 END) AS count_order_in_progress,
    COUNT(CASE WHEN fo.order_status = 'delivery'    THEN 1 END) AS count_order_delivery,
    COUNT(CASE WHEN fo.order_status = 'done'        THEN 1 END) AS count_order_done,
    COUNT(CASE WHEN fo.order_status = 'not_done'    THEN 1 END) AS count_order_not_done,
    TO_CHAR(
        DATE_TRUNC('month', MIN(fo.order_created_date)), 
        'YYYY-MM'
    ) AS report_period
FROM dwh.d_craftsmans cm
INNER JOIN dwh.f_orders fo
        ON cm.craftsman_id = fo.craftsman_id
INNER JOIN dwh.d_customers cu
        ON fo.customer_id = cu.customer_id
INNER JOIN dwh.d_products pd
        ON fo.product_id = pd.product_id
GROUP BY
    cm.craftsman_id,
    cm.craftsman_name,
    cm.craftsman_address,
    cm.craftsman_birthday,
    cm.craftsman_email

ON CONFLICT (craftsman_id, report_period)
DO UPDATE
SET
    craftsman_name               = EXCLUDED.craftsman_name,
    craftsman_address            = EXCLUDED.craftsman_address,
    craftsman_birthday           = EXCLUDED.craftsman_birthday,
    craftsman_email              = EXCLUDED.craftsman_email,
    craftsman_money              = EXCLUDED.craftsman_money,
    platform_money               = EXCLUDED.platform_money,
    count_order                  = EXCLUDED.count_order,
    avg_price_order              = EXCLUDED.avg_price_order,
    avg_age_customer             = EXCLUDED.avg_age_customer,
    median_time_order_completed  = EXCLUDED.median_time_order_completed,
    top_product_category         = EXCLUDED.top_product_category,
    count_order_created          = EXCLUDED.count_order_created,
    count_order_in_progress      = EXCLUDED.count_order_in_progress,
    count_order_delivery         = EXCLUDED.count_order_delivery,
    count_order_done             = EXCLUDED.count_order_done,
    count_order_not_done         = EXCLUDED.count_order_not_done,
    report_period                = EXCLUDED.report_period
;


-------------------------------------------------------------------------------
-- writing of update time of datamart
-------------------------------------------------------------------------------
INSERT INTO dwh.load_dates_craftsman_report_datamart (load_dttm)
VALUES (CURRENT_TIMESTAMP);
