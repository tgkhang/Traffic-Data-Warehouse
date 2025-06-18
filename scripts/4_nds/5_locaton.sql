select latitude, longitude, city as 'address'
from Staging_City

------
select distinct 
top 100 
latitude, longitude 
from Staging_Violation


select distinct 
top 100 
*
from Staging_Violation

-----
select top 100 
start_lat as latitude , start_lng as longitude
from Staging_Accident

select top 100 
end_lat as latitude , end_lng as longitude
from Staging_Accident

