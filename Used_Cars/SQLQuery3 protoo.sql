use [used car]
select  * from used_car


select 
sum(CASE when Engine_Size is null then 1 else 0 end )as missing_engine,
sum(case when price_sar =0 then 1 else 0 end ) as zero_price,
sum(case when mileage_km is null then 1 else 0 end) as missingmeleage 
from used_car;

select count(*) as dublicateRows from ( select ROW_NUMBER()
over( partition by make, model,year,mileage_km,region,
gear_type,engine_size, fuel_type, origin, options,negotiable, price_sar
order by (select null))as rn
from used_car) g where rn>1 ;

select count(*) as makeWithSpaces 
from used_car
where make<> ltrim(rtrim(make));

select make, model,year,mileage_km,region,
gear_type,engine_size, fuel_type, origin, options,negotiable, 
nullif(price_sar,0) as PriceSar
into UsedCarCLean
from (
select *,row_number () over(
partition by make, model,year,mileage_km,region,
gear_type,engine_size, fuel_type, origin, options,negotiable, price_sar
order by (select null))as rn from used_car) g where rn=1

select count(*) as tt ,
sum(case when pricesar is null then 1 else 0 end )as zz from UsedCarCLean ;

SELECT mileage_band,
       COUNT(*) AS cars,
       AVG(PriceSar) AS avg_price
FROM (
  SELECT PriceSar,
    CASE
      WHEN Mileage_km < 50000  THEN ' أقل من 50 ألف'
      WHEN Mileage_km < 100000 THEN ' من 50 إلى 100 ألف'
      WHEN Mileage_km < 150000 THEN ' من 100 إلى 150 ألف'
      WHEN Mileage_km < 200000 THEN ' من 150 إلى 200 ألف'
      ELSE ' أكثر من 200 ألف'
    END AS mileage_band
  FROM UsedCarClean
  WHERE PriceSar IS NOT NULL
    AND Mileage_km IS NOT NULL
) t
GROUP BY mileage_band
ORDER BY mileage_band;

select make, 
avg(case when year>= 2020 then pricesar end)as avgNew,
avg(case when year between 2010 and 2014 then pricesar end )as avgOld,
round(100.0 * 
avg(case when year between 2010 and 2014 then pricesar end )/
avg(case when year>= 2020 then pricesar end),1)as retainedPcT
from UsedCarCLean 
where pricesar is not null
group by make
order by retainedPcT asc;

select region,
count(*) as cars ,
avg(pricesar) as avgpricee
from usedcarclean
where pricesar is not null
group by region 
order by avgpricee desc;

select Gear_Type,
count(*) as cars ,
avg(pricesar) as avgpriceee
from usedcarclean
where pricesar is not null
group by Gear_Type 
order by avgpriceee desc;

