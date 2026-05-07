# Write your MySQL query statement below
select round(sum(a.tiv_2016),2) as tiv_2016
from insurance a
where a.tiv_2015 in (
select tiv_2015
from insurance
group by tiv_2015
having count(tiv_2015)>1

)
and (a.lat,a.lon) not in (
select lat,lon
from insurance
group by lat,lon
having count(*)>1
)