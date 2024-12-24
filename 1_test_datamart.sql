------------------------------------------------------------------------------
-- insert a new entry into source3.craft_market_orders
------------------------------------------------------------------------------
INSERT INTO source3.craft_market_orders (
    craftsman_id,
    customer_id,
    order_created_date,
    order_completion_date,
    order_status,
    product_name,
    product_description,
    product_type,
    product_price
)
VALUES (
    700,               
    700,               
    DATE '2023-12-14', 
    DATE '2023-12-25', 
    'done',            
    'underpants',       
    'elephant shaped panties',
    'clothes',         
    50                 
);


------------------------------------------------------------------------------
--CHECKING
------------------------------------------------------------------------------
/*
SELECT *
FROM dwh.d_craftsmans
WHERE craftsman_id = 700;

SELECT *
FROM dwh.f_orders
WHERE craftsman_id = 700;

SELECT *
FROM dwh.craftsman_report_datamart
WHERE craftsman_id = 700*/
