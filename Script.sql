select * from interactions i ;

select * from products p ;

SELECT 
    r.user_id, 
    r.product_id, 
    r.purchase_id AS missing_purchase_id, 
    pur.purchase_id AS found_purchase_id,
    pur.order_date
FROM 
    reviews r 
LEFT JOIN 
    purchases pur 
    ON r.user_id = pur.user_id 
    AND r.product_id = pur.product_id  
WHERE 
    r.purchase_id = '' OR r.purchase_id IS NULL;
    
 SELECT 
    review_id,
    user_id,
    product_id,
    rating,
    review_text,
    -- Membuat kolom baru untuk menandai status verifikasi
    CASE 
        WHEN purchase_id = '' OR purchase_id IS NULL THEN 'Unverified'
        ELSE 'Verified'
    END AS review_status
FROM 
    reviews;
 
 alter table reviews 
 add column status_review varchar(20);
 
update reviews 
set status_review = CASE 
	WHEN purchase_id = '' OR purchase_id IS NULL THEN 'Unverified'
    ELSE 'Verified'
END;

SELECT review_id, purchase_id, status_review
FROM reviews
LIMIT 20;

select COUNT(*)
from interactions i   ;

select i.interaction_type, s.is_converted 
from interactions i
left join sessions s on i.session_id = s.session_id 
; 

select 
	p.purchase_id, i.interaction_id , s.is_converted
from purchases p 
left join interactions i 
	on p.interaction_id =i.interaction_id 
left join sessions s 
	on i.session_id = s.session_id; 

select pro.product_id, p.purchase_id, pro.product_name ,pro.rating_avg, p.total_amount     
from products pro
left join purchases p on pro.product_id =p.product_id 
where pro.rating_avg is null;

CREATE OR REPLACE VIEW view_product_status AS
SELECT 
    pro.product_id,
    pro.product_name,
    pro.category,
    pro.rating_avg,
    COUNT(p.purchase_id) AS total_orders,
    SUM(p.total_amount) AS total_revenue,
    CASE 
        WHEN COUNT(p.purchase_id) = 0 THEN 'Unsold'
        WHEN COUNT(p.purchase_id) > 0 AND pro.rating_avg IS NULL THEN 'Sold - Unrated'
        ELSE 'Rated'
    END AS product_status
FROM 
    products pro
LEFT JOIN 
    purchases p ON pro.product_id = p.product_id
GROUP BY 
    pro.product_id, 
    pro.product_name, 
    pro.category,
    pro.rating_avg;

select p.purchase_id, i.interaction_type 
from purchases p 
left join interactions i 
	on p.interaction_id =i.interaction_id 
;


select count(*) from products;