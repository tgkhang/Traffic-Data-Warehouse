
/*
================================================================================
SCRIPT: 5_city.sql
PURPOSE: Creates and analyzes the NDS.City table for the traffic data warehouse
         This table stores city information with county relationships
AUTHOR: Traffic Data Warehouse Project
DATE: June 2025
================================================================================
*/

/*
================================================================================
TABLE CREATION: NDS.City
================================================================================
This table stores city information in the normalized data store layer.
It includes city names, county relationships, and timezone information
for geographical context in traffic data analysis.
*/
CREATE TABLE NDS.City (
    city_id INT IDENTITY(1,1) PRIMARY KEY,   -- Surrogate key for city records
    city_name NVARCHAR(100) NULL,            -- Name of the city (e.g., 'Baltimore', 'Rockville')
    county_id INT NULL,                      -- Foreign key to County table
    timezone NVARCHAR(50) NULL               -- Timezone information (e.g., 'Eastern', 'Pacific')
);
GO



select distinct city
from Bronze.City
where country= 'United States'
order by city asc


SELECT DISTINCT 
    CASE 
        WHEN driver_city IS NULL THEN 'n/a'
        WHEN LTRIM(RTRIM(driver_city)) IN ('', '.', '00', '000') THEN 'n/a'
        WHEN PATINDEX('%[^a-zA-Z0-9 ]%', driver_city) > 0 THEN 'n/a'
        WHEN ISNUMERIC(driver_city) = 1 THEN 'n/a'
        WHEN PATINDEX('[0-9]%', driver_city) = 1 THEN 'n/a'
        ELSE UPPER(LEFT(driver_city, 1)) + LOWER(SUBSTRING(driver_city, 2, LEN(driver_city)))
    END AS city
FROM Bronze.Violation

Union

select distinct city
FROM Bronze.Violation

ORDER BY city ASC


--===================   ========================
select distinct
  CASE 
        WHEN city IS NULL THEN 'n/a'
        ELSE city
    END AS city,  
  state, timezone, county_id
from Bronze.Accident a
join NDS.County c on c.county_name= a.county_name
order by city asc