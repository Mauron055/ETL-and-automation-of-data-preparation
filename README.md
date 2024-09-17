На данных из витрины mart.f_sales BI-аналитики построили графики total revenue для различных срезов.

Система магазина продолжает развиваться: команда разработки добавила функционал отмены заказов и возврата средств (refunded). Значит, процессы в пайплайне нужно обновить.

## Задача:

### Адаптировать пайплайн для текущей задачи:
- Учесть в витрине mart.f_sales статусы shipped и refunded. Все данные в витрине следует считать shipped.
- Обновить пайплайн с учётом статусов и backward compatibility.
- На основе пайплайна наполнить витрину mart.f_customer_retention данными по «возвращаемости клиентов» в разрезе недель.
