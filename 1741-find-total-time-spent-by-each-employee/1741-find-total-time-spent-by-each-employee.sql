# Write your MySQL query statement below
select
event_day as day,
sum(out_time-in_time)as total_time,
emp_id
from Employees
group by emp_id,event_day;