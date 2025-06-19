
USE DWTraffic;
GO

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Bronze')
    EXEC('CREATE SCHEMA Bronze');
GO
IF OBJECT_ID('Bronze.City', 'U') IS NOT NULL
	DROP TABLE Bronze.City;

CREATE TABLE Bronze.City (
    city NVARCHAR(100),
    country NVARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    source_system_code INT,
    create_time_stamp DATETIME,
    update_time_stamp DATETIME
);

go
IF OBJECT_ID('Bronze.City_Weather', 'U') IS NOT NULL
	DROP TABLE Bronze.City_Weather;

CREATE TABLE Bronze.City_Weather (
    datetime DATETIME NOT NULL,                         -- Timestamp of weather observation
    city NVARCHAR(200) NOT NULL,                        -- Standardized city name (e.g., 'San Francisco')
    temperature_c FLOAT NULL,                           -- Temperature in Celsius
    humidity FLOAT NULL,                                -- Humidity in percentage (0-100%)
    pressure_pa FLOAT NULL,                             -- Pressure in Pascals
    wind_speed_mps FLOAT NULL,                              -- Wind speed in m/s
    wind_direction_deg FLOAT NULL,                          -- Wind direction in degrees (0-360)
    weather_description NVARCHAR(255) NULL              -- Weather description (e.g., "Sky is clear")
);
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE Bronze.Violation(
	[datetime_of_stop] datetime2(7) NULL,
	[agency] [nvarchar](50) NOT NULL,
	[sub_agency] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NULL,
	[location] [nvarchar](max) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[accident] [bit] NULL,
	[belts] [bit] NULL,
	[personal_injury] [bit] NULL,
	[property_damage] [bit] NULL,
	[fatal] [bit] NULL,
	[commercial_license] [bit] NULL,
	[hazmat] [bit] NULL,
	[commercial_vehicle] [bit] NULL,
	[alcohol] [bit] NULL,
	[work_zone] [bit] NULL,
	[state] [nvarchar](50) NULL,
	[vehicle_type] [nvarchar](50) NULL,
	[year] [smallint] NULL,
	[make] [nvarchar](50) NULL,
	[model] [nvarchar](50) NULL,
	[color] [nvarchar](50) NULL,
	[violation_type] [nvarchar](50) NULL,
	[contributed_to_accident] [bit] NULL,
	[race] [nvarchar](50) NULL,
	[gender] [nvarchar](50) NULL,
	[driver_city] [nvarchar](50) NULL,
	[driver_state] [nvarchar](50) NULL,
	[dl_state] [nvarchar](50) NULL,
	[arrest_type] [nvarchar](50) NULL,
	[id] [int] NULL,
) ON [PRIMARY]
GO



CREATE TABLE Bronze.Accident(
	[id] [nvarchar](50) NOT NULL,
	[severity] [tinyint] NULL,
	start_time datetime2(7) NULL,
	[end_time] [datetime2](7) NULL,
	[start_lat] [float] NULL,
	[start_lng] [float] NULL,
	[end_lat] [float] NULL,
	[end_lng] [float] NULL,
	distance_m FLOAT NULL,   
    pressure_pa FLOAT NULL, 

	[description] [nvarchar](max) NULL,
	[street] [nvarchar](max) NULL,
	[city] [nvarchar](50) NULL,
	[county_name] [nvarchar](50) NULL,
	[state] [nvarchar](70) NULL,
    [weather_description] [nvarchar](max) NULL,

	[timezone] [nvarchar](50) NULL,

	[weather_timestamp] [datetime2](7) NULL,
	temperature_c FLOAT NULL,   
	[humidity] [float] NULL,
	
	visibility_m FLOAT NULL,  
	wind_direction_deg FLOAT NULL,   
	wind_speed_mps FLOAT NULL,   
	
	[amenity] [bit] NULL,
	[bump] [bit] NULL,
	[crossing] [bit] NULL,
	[give_way] [bit] NULL,
	[junction] [bit] NULL,
	[no_exit] [bit] NULL,
	[railway] [bit] NULL,
	[roundabout] [bit] NULL,
	[station] [bit] NULL,
	[stop] [bit] NULL,
	[traffic_calming] [bit] NULL,
	[traffic_signal] [bit] NULL,
	[turning_loop] [bit] NULL,
	[sunrise_sunset] [nvarchar](50) NULL,
	[civil_twilight] [nvarchar](50) NULL,
	[nautical_twilight] [nvarchar](50) NULL,
	[astronomical_twilight] [nvarchar](50) NULL,
) 
GO
