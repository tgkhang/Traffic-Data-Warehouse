
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


/*
================================================================================
DATA QUALITY ANALYSIS FOR CITY DATA
================================================================================
Analyze city data from multiple staging sources to understand data quality
and prepare for standardization in the NDS layer.
*/

/*
--------------------------------------------------------------------------------
CITY DATA QUALITY CHECK - STAGING_CITY TABLE
--------------------------------------------------------------------------------
Check for null city values in the Staging_City table for US records.
This helps identify data completeness in the primary city data source.
*/
-- Verify data quality in Staging_City for US cities
SELECT * 
FROM Staging_City
WHERE country = 'United States'
  AND city IS NULL
ORDER BY city ASC
-- RESULT: No null values found in city field

/*
--------------------------------------------------------------------------------
CITY DATA QUALITY CHECK - STAGING_ACCIDENT TABLE
--------------------------------------------------------------------------------
Check for null city values in accident data and apply data cleansing rules.
This is important since accident data may have missing city information.
*/
-- Handle null city values in accident data (sample of top 100)
SELECT DISTINCT TOP 100 
    CASE 
        WHEN city IS NULL THEN 'n/a'
        ELSE city
    END AS city,  
    county
FROM Staging_Accident
WHERE city IS NULL
ORDER BY city ASC


/*
--------------------------------------------------------------------------------
COMPREHENSIVE CITY DATA EXTRACTION
--------------------------------------------------------------------------------
Extract complete city information from accident data including geographic
and timezone context for the data warehouse.
*/
-- Extract city data with all geographic attributes from accident staging
SELECT DISTINCT
    CASE 
        WHEN city IS NULL THEN 'n/a'
        ELSE city
    END AS city,                            -- City name with null handling
    county,                                 -- County name for geographic relationship
    state,                                  -- State code for geographic context
    timezone                                -- Timezone information for temporal analysis
FROM Staging_Accident
ORDER BY city ASC

/*
--------------------------------------------------------------------------------
REFERENCE CITY DATA FROM CITY STAGING TABLE
--------------------------------------------------------------------------------
Extract distinct cities from the dedicated city staging table for comparison
and validation against accident data.
*/
-- Get all US cities from the dedicated city staging table
SELECT DISTINCT city 
FROM Staging_City
WHERE country = 'United States'
ORDER BY city ASC


SELECT DISTINCT 
    CASE 
        WHEN driver_city IS NULL THEN 'n/a'
        WHEN LTRIM(RTRIM(driver_city)) IN ('', '.', '00', '000') THEN 'n/a'
        WHEN PATINDEX('%[^a-zA-Z0-9 ]%', driver_city) > 0 THEN 'n/a'
        WHEN ISNUMERIC(driver_city) = 1 THEN 'n/a'
        WHEN PATINDEX('[0-9]%', driver_city) = 1 THEN 'n/a'
        ELSE UPPER(LEFT(driver_city, 1)) + LOWER(SUBSTRING(driver_city, 2, LEN(driver_city)))
    END AS city
FROM Staging_Violation
ORDER BY city ASC;



/*
--------------------------------------------------------------------------------
COUNTY REFERENCE DATA EXTRACTION
--------------------------------------------------------------------------------
Extract county and state combinations for establishing geographic relationships.
This data supports the county_id foreign key relationship in the City table.
*/
-- Extract county reference data for geographic hierarchy
SELECT DISTINCT 
    state AS state_code,                    -- State abbreviation
    county AS county_name                   -- County name
FROM Staging_Accident
ORDER BY county_name ASC