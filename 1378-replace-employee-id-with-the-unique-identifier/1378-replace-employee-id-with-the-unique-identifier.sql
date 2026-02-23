# Write your MySQL query statement below
select b.unique_id,a.name 
from Employees a left outer join  EmployeeUNI b
on a.id=b.id