create table Dim.Weather_Snapshot(
    weather_snapshot_key INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the weather snapshot
    weather_snapshot_id INT NOT NULL,  -- Foreign key to Weather_Snapshot table
    city_id INT NOT NULL,  -- Foreign key to City table
    city_name NVARCHAR(255) NULL,  -- Name of the city where the weather
    county_id INT NULL,  -- Foreign key to County table
    county_name NVARCHAR(255) NULL,  -- Name of the county where the weather
    state_code NVARCHAR(50) NULL,  -- State code where the weather snapshot was taken
    state_name NVARCHAR(255) NULL,  -- Name of the state where the weather
    country NVARCHAR(255) NULL,  -- Country where the weather snapshot was taken
    datetime DATETIME2(7) NULL,  -- Date and time of the weather snapshot
    humidity FLOAT NULL,  -- Humidity percentage
    pressure_pa FLOAT NULL,  -- Atmospheric pressure in pascals
    temperature_c FLOAT NULL,  -- Temperature in degrees Celsius
    temperature_f FLOAT NULL,  -- Temperature in degrees Fahrenheit
    wind_speed_mps FLOAT NULL,  -- Wind speed in meters per second
    wind_speed_mph FLOAT NULL,  -- Wind speed in miles per hour
    wind_direction_deg FLOAT NULL,  -- Wind direction in degrees (0-360)
    visibility_m FLOAT NULL,  -- Visibility in meters
    visibility_miles FLOAT NULL,  -- Visibility in miles
    weather_description NVARCHAR(255) NULL,  -- Description of the weather conditions
);


SELECT TOP 10 
    ws.weather_snapshot_id,
    ws.city_id,
    c.city_name,
    c.county_id,
    co.county_name,
    s.state_code,
    s.state_name,
    s.country,
    ws.datetime,
    ws.humidity,
    ws.pressure_pa,
    ws.temperature_c,
    (ws.temperature_c * 9.0/5.0) + 32 AS temperature_f,  -- Convert Celsius to Fahrenheit
    ws.wind_speed_mps,
    ws.wind_speed_mps * 2.237 AS wind_speed_mph,  -- Convert m/s to mph
    ws.wind_direction_deg,
    ws.visibility_m,
    ws.visibility_m * 0.000621371 AS visibility_miles,  -- Convert meters to miles
    ws.weather_description
FROM NDS.Weather_Snapshot ws
JOIN NDS.City c ON c.city_id = ws.city_id
JOIN NDS.County co ON co.county_id = c.county_id
JOIN NDS.State s ON s.state_code = co.state_code;

