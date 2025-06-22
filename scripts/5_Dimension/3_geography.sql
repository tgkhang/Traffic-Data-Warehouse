CREATE TABLE Dim.Geography (
    geography_key INT IDENTITY(1,1) PRIMARY KEY,
    city_name NVARCHAR(255) NULL,
    county_name NVARCHAR(50) NULL,
    state_code NVARCHAR(10) NULL,
    state_name NVARCHAR(100) NULL,
    city_id INT NULL,  -- Foreign key to City table
    country NVARCHAR(50) NULL,
    longitude FLOAT NULL,
    latitude FLOAT NULL
);


select c.city_name, co.county_name, s.state_code,
s.state_name, s.country, c.latitude,c.longitude, c.city_id
from NDS.City c
join NDS.County co on co.county_id= c.county_id
join NDS.State s on s.state_code= co.state_code

union

select
c.city_name, co.county_name, s.state_code, 
s.state_name, s.country, start_lat as latitude, start_lng as longitude, c.city_id
from NDS.Accident a
join NDS.City c on a.city_id= c.city_id
join NDS.County co on co.county_id= c.county_id
join NDS.State s on s.state_code= co.state_code

union

select
c.city_name, co.county_name, s.state_code, 
s.state_name, s.country,end_lat as latitude, end_lng as longitude, c.city_id
from NDS.Accident a
join NDS.City c on a.city_id= c.city_id
join NDS.County co on co.county_id= c.county_id
join NDS.State s on s.state_code= co.state_code

union 

select
c.city_name, co.county_name, s.state_code,
s.state_name, s.country, v.latitude, v.longitude, c.city_id
from NDS.Violation v
join NDS.City c on c.city_id= v.city_id
join NDS.County co on co.county_id = c.county_id
join NDS.State s on s.state_code= v.state