insert into mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount)
select dc.date_id, item_id, customer_id, city_id, quantity, payment_amount from staging.user_order_log uol
left join mart.d_calendar as dc on uol.date_time::Date = dc.date_actual
where uol.date_time::Date = '{{ds}}';

UPDATE mart.f_sales
SET payment_amount = CASE
                        WHEN status = 'refunded' THEN payment_amount * -1
                        ELSE payment_amount
                     END,
    status = 'shipped'
WHERE status IN ('shipped', 'refunded');

INSERT INTO mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status)
SELECT
    dc.date_id, item_id, customer_id, city_id, quantity,
    CASE
        WHEN status = 'refunded' THEN payment_amount * -1
        ELSE payment_amount
    END as payment_amount,
    'shipped' as status
FROM staging.user_order_log uol
LEFT JOIN mart.d_calendar dc ON uol.date_time::DATE = dc.date_actual
WHERE uol.date_time::DATE = '{{ds}}';

UPDATE mart.f_sales
SET status = 'shipped'
WHERE status IS NULL;
