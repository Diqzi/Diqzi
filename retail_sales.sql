select * from retail_store_sales
where discount_applied is null or discount_applied  = '';

-- rename column
ALTER TABLE retail_store_sales 
    RENAME COLUMN `Transaction ID` TO transaction_id,
    RENAME COLUMN `Customer ID` TO customer_id,
    RENAME COLUMN `Category` TO category,
    RENAME COLUMN `Item` TO item,
    RENAME COLUMN `Price Per Unit` TO price_per_unit,
    RENAME COLUMN `Quantity` TO quantity,
    RENAME COLUMN `Total Spent` TO total_spent,
    RENAME COLUMN `Payment Method` TO payment_method,
    RENAME COLUMN `Location` TO location,
    RENAME COLUMN `Transaction Date` TO transaction_date,
    RENAME COLUMN `Discount Applied` TO discount_applied;


-- handling missing values
select price_per_unit, quantity, total_spent
from retail_store_sales
where price_per_unit is null or price_per_unit = 0;
	
	-- quantity and total spent
select price_per_unit, quantity, total_spent
from retail_store_sales
where total_spent is null or quantity is null;

delete from retail_store_sales 
where quantity is null and total_spent is null;

	-- price per unit
select price_per_unit, quantity, total_spent, total_spent/quantity as ppu
from retail_store_sales 
where price_per_unit is null or price_per_unit = 0;

update retail_store_sales 
set price_per_unit = total_spent/NULLIF(quantity,0)
where price_per_unit is null;

	-- item
select item, price_per_unit 
from retail_store_sales
where item is null or item = '';

select category, price_per_unit, count(distinct item) as jml_item
from retail_store_sales
where item is not null and item != ''
group by category, price_per_unit 
having jml_item >1;

select r1.item, r2.item 
from retail_store_sales r1
join retail_store_sales r2 
	on r1.category = r2.category 
	and r1.price_per_unit =r2.price_per_unit 
where r1.item ='' and r2.item != '';

update retail_store_sales r1
join retail_store_sales r2 
	on r1.category = r2.category 
	and r1.price_per_unit =r2.price_per_unit 
set r1.item = r2.item
where r1.item ='' and r2.item != '';

	-- discount
update retail_store_sales 
set discount_applied = 'FALSE'
where discount_applied is null or discount_applied = '';


-- data formatting
UPDATE retail_store_sales 
SET transaction_date = DATE_FORMAT(STR_TO_DATE(transaction_date, '%c/%e/%Y'), '%Y-%m-%d')
WHERE transaction_date IS NOT NULL AND transaction_date != '';

alter table retail_store_sales 
modify column transaction_date date;

-- explore data
select customer_id, 
	count(transaction_id) as jml_transaksi, 
	sum(total_spent) as jml_pengeluaran, 
	avg(total_spent) as rata_rata_per_transaksi 
from retail_store_sales  
group by customer_id;

select DATE_FORMAT(transaction_date, '%Y-%m') as bulan,
	sum(total_spent) as total_penjualan,
	count(transaction_id) as jumlah_transaksi
from retail_store_sales
group by bulan
order by bulan;

SELECT 
    location,
    payment_method,
    SUM(total_spent) AS total_penjualan,
    COUNT(transaction_id) AS jumlah_transaksi
FROM retail_store_sales
GROUP BY location, payment_method
ORDER BY location, total_penjualan DESC;