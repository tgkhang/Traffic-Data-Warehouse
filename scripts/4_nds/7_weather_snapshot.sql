/*
================================================================================
SCRIPT: 7_weather_snapshot.sql
PURPOSE: Creates and populates the NDS.Weather_Snapshot table with weather data
         from multiple staging sources for the traffic data warehouse
AUTHOR: Traffic Data Warehouse Project
DATE: June 2025
================================================================================
*/

/*
================================================================================
TABLE CREATION: NDS.Weather_Snapshot
================================================================================
This table stores normalized weather information from multiple data sources.
It combines weather metrics from dedicated weather staging tables and
accident data to provide comprehensive weather context for traffic analysis.
*/
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



SELECT datetime, city, temperature
FROM (
    SELECT datetime, vancouver, portland, san_francisco, seattle, los_angeles, 
           san_diego, phoenix, jerusalem
    FROM Staging_Temperature
) t
UNPIVOT (
    temperature FOR city IN (
        vancouver, portland, san_francisco, seattle, los_angeles, 
        san_diego, phoenix, jerusalem
    )
) AS unpvt_temp;




------------
select top 10000 weather_timestamp,femperature_f, wind_chill_f, humidity, pressure_in,visibility_mi,wind_direction, wind_speed_mph, precipitation_in,
UPPER(LEFT(weather_condition, 1)) + LOWER(SUBSTRING(weather_condition, 2, LEN(weather_condition))) AS weather_description
from Staging_Accident



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
        )    ) AS wind_direction_unpivot
),
/*
--------------------------------------------------------------------------------
WEATHER DESCRIPTION CTE (SOURCE 1)
--------------------------------------------------------------------------------
Extract and normalize weather descriptions from the dedicated weather staging table.
This CTE unpivots weather description data from city columns to rows.
*/
WeatherDescription_CTE AS (
    SELECT 
        datetime,
        REPLACE(city, '_', ' ') AS city,        -- Standardize city names (replace underscores with spaces)
        weather_description                     -- Weather condition from dedicated staging table
    FROM (
        SELECT *
        FROM Staging_Weather_Description        -- Dedicated weather description staging table
    ) AS wde
    UNPIVOT (
        weather_description FOR city IN (
            vancouver, portland, san_francisco, seattle, los_angeles, san_diego,
            las_vegas, phoenix, albuquerque, denver, san_antonio, dallas, houston,
            kansas_city, minneapolis, saint_louis, chicago, nashville, indianapolis,
            atlanta, detroit, jacksonville, charlotte, miami, pittsburgh, toronto,
            philadelphia, new_york, montreal, boston, beersheba, tel_aviv_district,
            eilat, haifa, nahariyya, jerusalem
        )    ) AS weather_description_unpivot
)
/*
--------------------------------------------------------------------------------
FINAL WEATHER DATA INTEGRATION QUERY (SOURCE 1)
--------------------------------------------------------------------------------
Combine all weather metrics with standardized weather descriptions from
the dedicated weather staging tables.
*/
SELECT DISTINCT TOP 100
    t.datetime,
    t.city,
    -- Temperature conversion: Kelvin to Celsius
    CASE 
        WHEN t.temperature IS NOT NULL THEN t.temperature - 273.15 
        ELSE NULL 
    END AS temperature_c,
    h.humidity, 
    -- Pressure conversion: multiply by 100 to get Pascals
    CASE 
        WHEN p.pressure IS NOT NULL THEN p.pressure * 100 
        ELSE NULL 
    END AS pressure_pa,
    ws.wind_speed,
    wd.wind_direction,
    -- WEATHER DESCRIPTION FORMATTING (SOURCE 1):
    -- Apply title case to weather descriptions from Staging_Weather_Description
    -- Format: First letter uppercase + remaining letters lowercase
    -- Example: 'partly cloudy' → 'Partly cloudy'
    UPPER(LEFT(wde.weather_description, 1)) + LOWER(SUBSTRING(wde.weather_description, 2, LEN(wde.weather_description))) AS weather_description
FROM Temp_CTE t
LEFT JOIN Humidity_CTE h ON t.datetime = h.datetime AND t.city = h.city
LEFT JOIN Pressure_CTE p ON t.datetime = p.datetime AND t.city = p.city
LEFT JOIN WindSpeed_CTE ws ON t.datetime = ws.datetime AND t.city = ws.city
LEFT JOIN WindDirection_CTE wd ON t.datetime = wd.datetime AND t.city = wd.city
LEFT JOIN WeatherDescription_CTE wde ON t.datetime = wde.datetime AND t.city = wde.city
where t.datetime is not null
ORDER BY t.datetime







SELECT datetime, city, temperature
FROM (
    SELECT datetime, vancouver, portland, san_francisco, seattle, los_angeles, 
           san_diego, phoenix, jerusalem
    FROM Staging_Temperature
) t
UNPIVOT (
    temperature FOR city IN (
        vancouver, portland, san_francisco, seattle, los_angeles, 
        san_diego, phoenix, jerusalem
    )
) AS unpvt_temp;




------------
select top 10000 weather_timestamp,femperature_f, wind_chill_f, humidity, pressure_in,visibility_mi,wind_direction, wind_speed_mph, precipitation_in,
UPPER(LEFT(weather_condition, 1)) + LOWER(SUBSTRING(weather_condition, 2, LEN(weather_condition))) AS weather_description
from Staging_Accident



/*
================================================================================
COMPREHENSIVE WEATHER DATA FROM ACCIDENT REPORTS (SOURCE 2)
================================================================================
Extract and standardize weather data from accident staging table with
complete unit conversions and weather description formatting.

This query provides weather context at the exact time and location of
traffic incidents, making it valuable for accident analysis.
*/
SELECT DISTINCT 
    weather_timestamp,
    -- Temperature conversion: Fahrenheit to Celsius
    CASE 
        WHEN femperature_f IS NOT NULL THEN (femperature_f - 32) * 5.0 / 9.0 
        ELSE NULL 
    END AS temperature_c,  
    -- Humidity (already in percentage, no conversion needed)
    CASE 
        WHEN humidity IS NOT NULL THEN humidity
        ELSE NULL 
    END AS humidity,
    -- Visibility conversion: Miles to meters
    CASE 
        WHEN visibility_mi IS NOT NULL THEN visibility_mi * 1609.34 
        ELSE NULL 
    END AS visibility_m,
    -- Pressure conversion: Inches to Pascals
    CASE 
        WHEN pressure_in IS NOT NULL THEN pressure_in * 3386.39 
        ELSE NULL 
    END AS pressure_pa,
    -- Wind speed conversion: Miles per hour to meters per second
    CASE 
        WHEN wind_speed_mph IS NOT NULL THEN wind_speed_mph * 0.44704 
        ELSE NULL 
    END AS wind_speed_mps,
    -- Wind direction conversion: Compass directions to degrees (0-360)
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
    city,
    county AS county_name,
    -- WEATHER DESCRIPTION FORMATTING (SOURCE 2):
    -- Apply title case to weather_condition from accident data
    -- Handles inconsistent capitalization from accident reports
    -- Example: 'CLEAR' → 'Clear', 'partly cloudy' → 'Partly cloudy'
    UPPER(LEFT(weather_condition, 1)) + LOWER(SUBSTRING(weather_condition, 2, LEN(weather_condition))) AS weather_description
FROM Staging_Accident
where weather_timestamp is not null
ORDER BY weather_timestamp

/*
================================================================================
WEATHER DESCRIPTION SOURCES SUMMARY
================================================================================

This script processes weather descriptions from TWO main sources:

SOURCE 1: DEDICATED WEATHER STAGING TABLES
- Table: Staging_Weather_Description  
- Structure: City columns with weather condition values
- Processing: UNPIVOT operation to normalize data structure
- Text Formatting: Title case (UPPER first letter + LOWER remainder)
- Use Case: Systematic weather monitoring data by city
- Example Output: 'Partly cloudy', 'Clear', 'Rain'

SOURCE 2: ACCIDENT STAGING TABLE  
- Table: Staging_Accident
- Field: weather_condition
- Structure: One record per accident with weather at incident time/location
- Processing: Direct field extraction with formatting
- Text Formatting: Title case (UPPER first letter + LOWER remainder)  
- Use Case: Weather conditions during specific traffic incidents
- Example Output: 'Clear' (from 'CLEAR'), 'Rain' (from 'RAIN')

INTEGRATION STRATEGY:
- Source 1: Use for general weather trends and city-wide analysis
- Source 2: Use for incident-specific weather correlation analysis
- Both sources apply consistent title case formatting for standardization
- Weather descriptions can be used interchangeably in downstream fact tables

BUSINESS VALUE:
- Enables weather impact analysis on traffic patterns
- Supports accident investigation with weather context
- Provides comprehensive weather coverage from multiple data sources
================================================================================
*/

/*
================================================================================
WEATHER DATA SOURCE 1: DEDICATED WEATHER STAGING TABLES
================================================================================
This section processes weather data from dedicated staging tables that contain
weather metrics by city columns. Data is unpivoted to normalize the structure.
*/

/*
--------------------------------------------------------------------------------
SAMPLE TEMPERATURE DATA EXTRACTION
--------------------------------------------------------------------------------
Basic example of unpivoting temperature data from city columns to rows.
This demonstrates the transformation pattern used for all weather metrics.
*/
-- Sample query showing temperature data transformation from columns to rows
SELECT datetime, city, temperature
FROM (
    SELECT datetime, vancouver, portland, san_francisco, seattle, los_angeles, 
           san_diego, phoenix, jerusalem
    FROM Staging_Temperature
) t
UNPIVOT (
    temperature FOR city IN (
        vancouver, portland, san_francisco, seattle, los_angeles, 
        san_diego, phoenix, jerusalem
    )
) AS unpvt_temp;



/*
================================================================================
WEATHER DATA SOURCE 2: ACCIDENT STAGING TABLE
================================================================================
Extract weather information directly from accident reports. This provides
weather conditions at the time and location of traffic incidents.

WEATHER DESCRIPTION SOURCE 2: Staging_Accident.weather_condition field
- Contains weather descriptions from accident reports
- Raw data may have inconsistent capitalization
- Text formatting applied: Title case standardization
- Examples: 'clear', 'RAIN', 'Partly Cloudy' → 'Clear', 'Rain', 'Partly cloudy'
*/
-- Extract weather data from accident reports (sample of 10,000 records)
select top 10000 weather_timestamp,femperature_f, wind_chill_f, humidity, pressure_in,visibility_mi,wind_direction, wind_speed_mph, precipitation_in,
UPPER(LEFT(weather_condition, 1)) + LOWER(SUBSTRING(weather_condition, 2, LEN(weather_condition))) AS weather_description
from Staging_Accident;



/*
================================================================================
COMPREHENSIVE WEATHER DATA INTEGRATION - SOURCE 1
================================================================================
This query combines all weather metrics from dedicated staging tables using
Common Table Expressions (CTEs) to create a unified weather dataset.

DATA SOURCES:
- Staging_Temperature: Temperature readings by city
- Staging_Humidity: Humidity percentages by city  
- Staging_Pressure: Atmospheric pressure by city
- Staging_Wind_Speed: Wind speed measurements by city
- Staging_Wind_Direction: Wind direction by city
- Staging_Weather_Description: Weather condition descriptions by city

WEATHER DESCRIPTION PROCESSING (SOURCE 1):
- Source: Staging_Weather_Description table
- Contains standardized weather descriptions for multiple cities
- Data is unpivoted from city columns to normalized rows
- Text formatting: UPPER(LEFT()) + LOWER(SUBSTRING()) for title case
- Applied in WeatherDescription_CTE and final SELECT
*/

