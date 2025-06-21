IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Dim')
    EXEC('CREATE SCHEMA Dim');
GO


CREATE TABLE DIM.Date (
    date_key INT PRIMARY KEY,              -- Format: YYYYMMDD
    full_date DATE NOT NULL,
    year SMALLINT NOT NULL,
    quarter TINYINT NOT NULL,
    month TINYINT NOT NULL,
    month_name NVARCHAR(20) NOT NULL,
    day_of_month TINYINT NOT NULL,
    week_of_year TINYINT NOT NULL,
    day_of_week TINYINT NOT NULL,          -- 1 = Monday, 7 = Sunday
    day_of_week_name NVARCHAR(20) NOT NULL,
    is_weekend BIT NOT NULL
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

WITH AllDates AS (
    SELECT CAST([datetime] AS DATE) AS full_date FROM NDS.Weather_Snapshot
    UNION
    SELECT CAST([start_time] AS DATE) FROM NDS.Accident
    UNION
    SELECT CAST([end_time] AS DATE) FROM NDS.Accident
    UNION
    SELECT CAST([datetime_of_stop] AS DATE) FROM NDS.Violation
)
SELECT 
    CONVERT(INT, FORMAT(full_date, 'yyyyMMdd')) AS date_key,
    full_date,
    DATEPART(YEAR, full_date) AS year,
    DATEPART(QUARTER, full_date) AS quarter,
    DATEPART(MONTH, full_date) AS month,
    DATENAME(MONTH, full_date) AS month_name,
    DATEPART(DAY, full_date) AS day_of_month,
    DATEPART(WEEK, full_date) AS week_of_year,
    DATEPART(WEEKDAY, full_date) AS day_of_week,
    DATENAME(WEEKDAY, full_date) AS day_of_week_name,
    CASE 
        WHEN DATEPART(WEEKDAY, full_date) IN (1, 7) THEN 1  -- Sunday or Saturday
        ELSE 0
    END AS is_weekend
FROM (
    SELECT DISTINCT full_date
    FROM AllDates
    WHERE full_date IS NOT NULL
) AS DistinctDates;



