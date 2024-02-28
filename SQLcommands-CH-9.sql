select distinct(dp.product_name), base_price, promo_type from fact_events as f
join dim_products dp on f.product_code=dp.product_code
where f.base_price  > 500 
and f.promo_type = 'BOGOF';

select city, count(store_id) as Num_stores from dim_stores
  group by city
  order by Num_stores desc;

select dim_campaigns.campaign_name, sum(base_price*quantity_sold_before_promo)/1000000 as Tot_Rev_Bef_promo,
 sum(base_price*quantity_sold_after_promo)/1000000  as Tot_Rev_Aft_promo from fact_events
inner join dim_campaigns on fact_events.campaign_id=dim_campaigns.campaign_id
group by dim_campaigns.campaign_name;


select category, round(((qap-qbp)/qbp)*100,2) as ISU_Percentage,
rank() over (order by ISU_Percentage desc) as ranking from (select dp.category,
 sum(quantity_sold(before_promo)) as qbp,sum(quantity_sold(after_promo)) as qap
from facts_events fe
inner join dim_products dp on fe.product_code=dp.product_code
where fe.campaign_id="CAMP_DIW_01" group by dp.category) as subq1;

select product_name, category, round(((rap-rbp)/rbp)*100,2) as IR_Percentage from 
(select dp.product_name, dp.category, sum(base_price*qty_sold-bef_promo) as rbp,
sum(base_price*quantity_sold_after_promo) as rap
from facts_events fe
inner join dim_products dp on fe.product_code=dp.product_code
group by dp.product_name,category) as subq2 order by IR_percentage desc limit 5;
