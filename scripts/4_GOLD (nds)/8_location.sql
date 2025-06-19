CREATE TABLE NDS.Location (
    location_id INT IDENTITY(1,1) PRIMARY KEY,  
    longitude FLOAT NULL,            -- Longitude coordinate of the location
    latitude FLOAT NULL,             -- Latitude coordinate of the location
    city_id INT NULL,               -- Foreign key to City table
    address NVARCHAR(255) NULL,  -- Address of the location
);
GO


select distinct longitude, latitude, city as address, c.city_id
from Bronze.City bc
join NDS.City c on c.city_name=bc.city
where longitude is not null and latitude is not null

select distinct
location as address,latitude,longitude
from Bronze.Violation
where longitude is not null and latitude is not null



select distinct
start_lat as latitude, start_lng as longitude,
street + ', ' + city + ', ' + state AS address,
c.city_id
from Bronze.Accident a
join NDS.City c on c.city_name= a.city
where start_lat is not null and start_lng is not null

union

select distinct 
end_lat as latitude, end_lng as longitude,
street + ', ' + city + ', ' + state AS address,
c.city_id
from Bronze.Accident a
join NDS.City c on c.city_name= a.city
where end_lat is not null and end_lng is not null