CREATE TABLE NDS.Weather_Snapshot (
    weather_snapshot_id INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    datetime DATETIME NOT NULL,                         -- Timestamp of weather observation
    humidity FLOAT NULL,                                -- Humidity percentage (0-100%)       
    pressure_pa FLOAT NULL,                            -- Atmospheric pressure in Pascals
    temperature_c FLOAT NULL,                          -- Temperature in Celsius
    weather_description NVARCHAR(255) NULL,            -- Standardized weather condition description
    wind_speed_mps FLOAT NULL,                         -- Wind speed in meters per second
    wind_direction_deg FLOAT NULL,                     -- Wind direction in degrees (0-360)
    visibility_m FLOAT NULL,                           -- Visibility distance in meters
    city_id NVARCHAR(50) NULL,
);
GO

select distinct 
cw.*, city_id
from Bronze.City_Weather cw
join NDS.City c on c.city_name= cw.city
where cw.datetime is not null


select distinct
    a.weather_timestamp,
    a.temperature_c,humidity,a.visibility_m,
    a.pressure_pa, a.wind_speed_mps, a.wind_direction_deg,
    a.weather_description,
    c.city_id
FROM Bronze.Accident a
    join NDS.City c on a.city = c.city_name
where weather_timestamp is not null
order by weather_timestamp

