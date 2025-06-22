IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Dim')
    EXEC('CREATE SCHEMA Dim');
GO


CREATE TABLE DIM.Datetime (
    datetime_key BIGINT PRIMARY KEY,       -- Format: YYYYMMDDHHMISS
    full_datetime DATETIME2 NOT NULL,      -- Combined date and time
    full_date DATE NOT NULL,
    full_time TIME NOT NULL,
    year SMALLINT NOT NULL,
    quarter TINYINT NOT NULL,
    month TINYINT NOT NULL,
    month_name NVARCHAR(20) NOT NULL,
    day_of_month TINYINT NOT NULL,
    week_of_year TINYINT NOT NULL,
    day_of_week TINYINT NOT NULL,          -- 1 = Monday, 7 = Sunday
    day_of_week_name NVARCHAR(20) NOT NULL,
    is_weekend BIT NOT NULL,
    hour TINYINT NOT NULL,                 -- 0-23
    minute TINYINT NOT NULL,               -- 0-59
    second TINYINT NOT NULL,               -- 0-59
    hour_12 TINYINT NOT NULL,              -- 1-12
    am_pm CHAR(2) NOT NULL,                -- AM or PM
    time_of_day_description NVARCHAR(20) NOT NULL  -- Morning, Afternoon, Evening, Night
)

----


select top 100 
datetime
from NDS.Weather_Snapshot


select top 100
start_time, end_time
from NDS.Accident


select top 100
datetime_of_stop
from NDS.Violation


-----

WITH AllDateTimes AS (
    SELECT [datetime] AS full_datetime FROM NDS.Weather_Snapshot WHERE [datetime] IS NOT NULL
    UNION
    SELECT [start_time] FROM NDS.Accident WHERE [start_time] IS NOT NULL
    UNION
    SELECT [end_time] FROM NDS.Accident WHERE [end_time] IS NOT NULL
    UNION
    SELECT [datetime_of_stop] FROM NDS.Violation WHERE [datetime_of_stop] IS NOT NULL
)
SELECT 
    CONVERT(BIGINT, FORMAT(full_datetime, 'yyyyMMddHHmmss')) AS datetime_key,
    full_datetime,
    CAST(full_datetime AS DATE) AS full_date,
    CAST(full_datetime AS TIME) AS full_time,
    DATEPART(YEAR, full_datetime) AS year,
    DATEPART(QUARTER, full_datetime) AS quarter,
    DATEPART(MONTH, full_datetime) AS month,
    DATENAME(MONTH, full_datetime) AS month_name,
    DATEPART(DAY, full_datetime) AS day_of_month,
    DATEPART(WEEK, full_datetime) AS week_of_year,
    DATEPART(WEEKDAY, full_datetime) AS day_of_week,
    DATENAME(WEEKDAY, full_datetime) AS day_of_week_name,
    CASE 
        WHEN DATEPART(WEEKDAY, full_datetime) IN (1, 7) THEN 1  -- Sunday or Saturday
        ELSE 0
    END AS is_weekend,
    DATEPART(HOUR, full_datetime) AS hour,
    DATEPART(MINUTE, full_datetime) AS minute,
    DATEPART(SECOND, full_datetime) AS second,
    CASE 
        WHEN DATEPART(HOUR, full_datetime) = 0 THEN 12
        WHEN DATEPART(HOUR, full_datetime) > 12 THEN DATEPART(HOUR, full_datetime) - 12
        ELSE DATEPART(HOUR, full_datetime)
    END AS hour_12,
    CASE 
        WHEN DATEPART(HOUR, full_datetime) < 12 THEN 'AM'
        ELSE 'PM'
    END AS am_pm,
    CASE 
        WHEN DATEPART(HOUR, full_datetime) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, full_datetime) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN DATEPART(HOUR, full_datetime) BETWEEN 18 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day_description
FROM (
    SELECT DISTINCT full_datetime
    FROM AllDateTimes
    WHERE full_datetime IS NOT NULL
) AS DistinctDateTimes;



