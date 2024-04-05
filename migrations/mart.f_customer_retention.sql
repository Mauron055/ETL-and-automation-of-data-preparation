CREATE TABLE IF NOT EXISTS mart.f_customer_retention (
    new_customers_count INT,
    returning_customers_count INT,
    refunded_customer_count INT,
    period_name VARCHAR(10),
    period_id INT,
    item_id INT,
    new_customers_revenue DECIMAL(10, 2),
    returning_customers_revenue DECIMAL(10, 2),
    customers_refunded INT,
    PRIMARY KEY (period_id, item_id)
);

INSERT INTO mart.f_customer_retention (new_customers_count, returning_customers_count, refunded_customer_count, period_name, period_id, item_id, new_customers_revenue, returning_customers_revenue, customers_refunded)
SELECT
    new_customers.new_count,
    returning_customers.returning_count,
    refunded_customers.refunded_count,
    'weekly' as period_name,  -- Указываем значение 'weekly' для period_name
    EXTRACT(week FROM uol.date_time) as period_id,  -- Пример вычисления номера недели, можно изменить под вашу логику
    uol.item_id,
    new_revenue.new_revenue,
    returning_revenue.returning_revenue,
    refunded_revenue.refunded_revenue
FROM
    (SELECT COUNT(DISTINCT customer_id) as new_count, item_id, SUM(payment_amount) as new_revenue
     FROM stage.user_order_log
     GROUP BY item_id
     HAVING COUNT(DISTINCT customer_id) = 1) as new_customers
JOIN
    (SELECT COUNT(DISTINCT customer_id) as returning_count, item_id, SUM(payment_amount) as returning_revenue
     FROM stage.user_order_log
     GROUP BY item_id
     HAVING COUNT(DISTINCT customer_id) > 1) as returning_customers
     ON new_customers.item_id = returning_customers.item_id
JOIN
    (SELECT COUNT(DISTINCT customer_id) as refunded_count, item_id, SUM(payment_amount) as refunded_revenue
     FROM stage.user_order_log
     WHERE action_id = 'refunded'  -- Предположим, что есть поле для обозначения возврата
     GROUP BY item_id) as refunded_customers
     ON returning_customers.item_id = refunded_customers.item_id