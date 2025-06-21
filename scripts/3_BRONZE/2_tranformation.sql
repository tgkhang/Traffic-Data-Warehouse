WITH Temp_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        temperature
    FROM (
        SELECT *
        FROM Staging_Temperature
    ) AS t
    UNPIVOT (
        temperature FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS temp_unpivot
), Humidity_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        humidity
    FROM (
        SELECT *
        FROM Staging_Humidity
    ) AS h
    UNPIVOT (
        humidity FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS humidity_unpivot
),Pressure_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        pressure
    FROM (
        SELECT *
        FROM Staging_Pressure
    ) AS p
    UNPIVOT (
        pressure FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS pressure_unpivot
),WindSpeed_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        wind_speed
    FROM (
        SELECT *
        FROM Staging_Wind_Speed
    ) AS ws
    UNPIVOT (
        wind_speed FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS wind_speed_unpivot
),WindDirection_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        wind_direction
    FROM (
        SELECT *
        FROM Staging_Wind_Direction
    ) AS wd
    UNPIVOT (
        wind_direction FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS wind_direction_unpivot
),WeatherDescription_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,
        weather_description
    FROM (
        SELECT *
        FROM Staging_Weather_Description
    ) AS wde
    UNPIVOT (
        weather_description FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )
    ) AS weather_description_unpivot
)
SELECT distinct
    t.datetime,
    t.city,
    CASE 
        WHEN t.temperature IS NOT NULL THEN t.temperature - 273.15 
        ELSE NULL 
    END AS temperature_c,
    h.humidity, 
    CASE 
        WHEN p.pressure IS NOT NULL THEN p.pressure * 100 
        ELSE NULL 
    END AS pressure_pa,
    ws.wind_speed,
    wd.wind_direction,
    UPPER(LEFT(wde.weather_description, 1)) + LOWER(SUBSTRING(wde.weather_description, 2, LEN(wde.weather_description))) AS weather_description
FROM Temp_CTE t
LEFT JOIN Humidity_CTE h ON t.datetime = h.datetime AND t.city = h.city
LEFT JOIN Pressure_CTE p ON t.datetime = p.datetime AND t.city = p.city
left join WindSpeed_CTE ws on t.datetime = ws.datetime and t.city = ws.city
left join WindDirection_CTE wd on t.datetime = wd.datetime and t.city= wd.city
left join WeatherDescription_CTE wde on t.datetime= wde.datetime and t.city = wde.city
where t.datetime is not null
order by t.datetime



-- transfor mation for violation
select distinct top 100
    CAST(date_of_stop AS DATETIME) + CAST(time_of_stop AS DATETIME) AS datetime_of_stop,
    -- Format description: NULL -> 'n/a', and capitalize
    CASE 
        WHEN description IS NULL THEN 'n/a' 
        ELSE CONCAT(UPPER(LEFT(LOWER(description), 1)), LOWER(SUBSTRING(description, 2, LEN(description)))) 
    END AS description,
    CASE 
        WHEN location IS NULL THEN 'n/a' 
        ELSE CONCAT(UPPER(LEFT(LOWER(location), 1)), LOWER(SUBSTRING(location, 2, LEN(location)))) 
    END AS location,

    agency, sub_agency, 
    latitude, longitude,

    CASE WHEN accident = 'Yes' THEN 1 ELSE 0 END AS accident,
    belts,
    personal_injury,
    property_damage,
    CASE WHEN fatal = 'Yes' THEN 1 ELSE 0 END AS fatal,
    commercial_license,
    CASE WHEN hazmat = 'Yes' THEN 1 ELSE 0 END AS hazmat,
    commercial_vehicle,
    CASE WHEN alcohol = 'Yes' THEN 1 ELSE 0 END AS alcohol,
    CASE WHEN work_zone = 'Yes' THEN 1 ELSE 0 END AS work_zone,
    ISNULL(state, 'n/a') AS state,
    vehicle_type, year,
    UPPER(LEFT(make, 1)) + LOWER(SUBSTRING(make, 2, LEN(make))) AS make,
    UPPER(LEFT(model, 1)) + LOWER(SUBSTRING(model, 2, LEN(model))) AS model,
    UPPER(LEFT(color, 1)) + LOWER(SUBSTRING(color, 2, LEN(color))) AS color,
    UPPER(LEFT(race, 1)) + LOWER(SUBSTRING(race, 2, LEN(race))) AS race,
    
    violation_type, contributed_to_accident, 
    
    CAST(
        CASE 
            WHEN UPPER(LTRIM(RTRIM(gender))) = 'M' THEN 'Male'
            WHEN UPPER(LTRIM(RTRIM(gender))) = 'F' THEN 'Female'
            ELSE 'n/a'
        END AS NVARCHAR(50)
    ) AS gender,

    CASE 
       WHEN driver_city IS NULL THEN 'n/a'
       WHEN LTRIM(RTRIM(driver_city)) IN ('', '.', '00', '000') THEN 'n/a'
       WHEN PATINDEX('%[^a-zA-Z0-9 ]%', driver_city) > 0 THEN 'n/a'
       WHEN ISNUMERIC(driver_city) = 1 THEN 'n/a'
       WHEN PATINDEX('[0-9]%', driver_city) = 1 THEN 'n/a'
       ELSE (
           SELECT STRING_AGG(
               UPPER(LEFT(s.value, 1)) + LOWER(SUBSTRING(s.value, 2, LEN(s.value))),
               ' '
           )
           FROM STRING_SPLIT(driver_city, ' ') AS s
           WHERE s.value <> ''
       )
   END AS driver_city,
driver_state, dl_state, arrest_type, id
from Staging_Violation
order by id




  
-- tranformation for accident



SELECT 
    id,
    severity,
    start_time,
    end_time,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    
    -- Convert distance from miles to meters
    CASE 
        WHEN distance_mi IS NOT NULL THEN distance_mi * 1609.34
        ELSE NULL
    END AS distance_m,
    CASE 
        WHEN pressure_in IS NOT NULL THEN pressure_in * 3386.39 
        ELSE NULL 
    END AS pressure_pa,
    description,
    street,
    
    -- Replace NULL city with 'n/a'
    ISNULL(city, 'n/a') AS city,

    county as county_name,
    state,
    timezone,
 

    -- Capitalize weather_condition
    UPPER(LEFT(weather_condition, 1)) + LOWER(SUBSTRING(weather_condition, 2, LEN(weather_condition))) AS weather_description,

    weather_timestamp,
    CASE 
        WHEN femperature_f IS NOT NULL THEN (femperature_f - 32) * 5.0 / 9.0 
        ELSE NULL 
    END AS temperature_c,
    humidity,
    CASE 
        WHEN visibility_mi IS NOT NULL THEN visibility_mi * 1609.34 
        ELSE NULL 
    END AS visibility_m,
    CASE 
        WHEN wind_direction IN ('N', 'North') THEN 0
        WHEN wind_direction = 'NNE' THEN 22.5
        WHEN wind_direction IN ('NE') THEN 45
        WHEN wind_direction = 'ENE' THEN 67.5
        WHEN wind_direction IN ('E', 'East') THEN 90
        WHEN wind_direction = 'ESE' THEN 112.5
        WHEN wind_direction = 'SE' THEN 135
        WHEN wind_direction = 'SSE' THEN 157.5
        WHEN wind_direction IN ('S', 'South') THEN 180
        WHEN wind_direction = 'SSW' THEN 202.5
        WHEN wind_direction = 'SW' THEN 225
        WHEN wind_direction = 'WSW' THEN 247.5
        WHEN wind_direction IN ('W', 'West') THEN 270
        WHEN wind_direction = 'WNW' THEN 292.5
        WHEN wind_direction = 'NW' THEN 315
        WHEN wind_direction = 'NNW' THEN 337.5
        WHEN wind_direction IN ('Variable', 'VAR', 'Calm') THEN NULL
        ELSE NULL
    END AS wind_direction_deg,
    CASE 
        WHEN wind_speed_mph IS NOT NULL THEN wind_speed_mph * 0.44704 
        ELSE NULL 
    END AS wind_speed_mps,
    amenity,
    crossing,junction,railway,station,stop,

    case when give_way='True' then 1 else 0 end as give_way,
    case when bump = 'True' then 1 else 0 end as bump,
    CASE WHEN no_exit = 'True' THEN 1 ELSE 0 END AS no_exit,
    CASE WHEN roundabout = 'True' THEN 1 ELSE 0 END AS roundabout,
    CASE WHEN traffic_calming = 'True' THEN 1 ELSE 0 END AS traffic_calming,
    traffic_signal,
    CASE WHEN turning_loop = 'True' THEN 1 ELSE 0 END AS turning_loop,

    sunrise_sunset,
    civil_twilight,
    nautical_twilight,
    astronomical_twilight
FROM Staging_Accident
WHERE id IS NOT NULL and country = 'US'
ORDER BY id
