select * from orders;

SHOW COLUMNS FROM reviews;

SET SQL_SAFE_UPDATES = 0;
update ignore orders
set delivered_date = str_to_date(delivered_date, '%d-%m-%Y');

ALTER TABLE orders
MODIFY COLUMN delivered_date DATE;

select payment_method, avg(final_amount)
from orders
group by payment_method;

select customer_id, count(customer_id)
from orders
group by customer_id
having count(customer_id) > 1;

select p.product_name, count(ors.order_id) as jumlah_terjual
from orders as ors
left join order_items o on ors.order_id = o.order_id
left join products p on o.product_id = p.product_id
group by p.product_name
order by jumlah_terjual desc
;

SELECT 
    p.product_name, 
    COUNT(ors.order_id) as jumlah_terjual, 
    p.stock_qty as stok_awal,
    (p.stock_qty - COUNT(ors.order_id)) as sisa_stok
FROM orders as ors
LEFT JOIN order_items o ON ors.order_id = o.order_id
LEFT JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name, p.stock_qty 
ORDER BY jumlah_terjual DESC;

select order_id, timestampdiff(day, order_date, delivered_date) as lama_waktu
from orders
where timestampdiff(day, order_date, delivered_date) is not null;

select avg(timestampdiff(day, order_date, delivered_date)) as rata_rata
from orders
where timestampdiff(day, order_date, delivered_date) is not null;

select product_id, row_number() over(partition by product_id) as jumlah
from products
;

select p.product_name, count(r.return_id)
from products p
left join returns r on p.product_id = r.product_id
group by p.product_name
order by count(r.return_id) desc;

select year(order_date), count(order_id)
from orders
group by year(order_date);