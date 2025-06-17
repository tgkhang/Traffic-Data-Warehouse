
/*
================================================================================
SCRIPT: 3_vehicle.sql
PURPOSE: Creates the NDS.Vehicle table and performs data quality analysis
         for vehicle data from staging to normalized data store (NDS)
AUTHOR: Traffic Data Warehouse Project
DATE: June 2025
================================================================================
*/

-- Switch to the Data Warehouse database
USE DWTraffic
GO

/*
================================================================================
TABLE CREATION: NDS.Vehicle
================================================================================
This table stores normalized vehicle information in the NDS layer.
Each vehicle record contains basic vehicle attributes and references
the Vehicle_Type lookup table.
*/

CREATE TABLE NDS.Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),    -- Surrogate key for vehicle records
    vehicle_type_id INT NOT NULL,                -- Foreign key to Vehicle_Type lookup
    [year] SMALLINT NULL,                        -- Manufacturing year of the vehicle
    [make] NVARCHAR(50) NULL,                    -- Vehicle manufacturer (e.g., Ford, Toyota)
    [model] NVARCHAR(50) NULL,                   -- Vehicle model (e.g., Camry, F-150)
    [color] NVARCHAR(50) NULL,                   -- Vehicle color
    [commercial_vehicle] BIT NULL,               -- Flag indicating if vehicle is commercial
    CONSTRAINT FK_Vehicle_VehicleType FOREIGN KEY (vehicle_type_id)
        REFERENCES NDS.Vehicle_Type(vehicle_type_id)
);
GO

/*
================================================================================
DATA QUALITY ANALYSIS SECTION
================================================================================
The following queries analyze the quality of vehicle data in the staging layer
and determine appropriate data cleansing strategies before loading into NDS.
*/

-- Switch to staging database for analysis
USE StagingDB
GO

/*
--------------------------------------------------------------------------------
INITIAL DATA EXPLORATION
--------------------------------------------------------------------------------
Sample the vehicle-related data to understand structure and content
*/
SELECT TOP 100 vehicle_type, commercial_vehicle, year, make, color, model
FROM Staging_Violation

/*
--------------------------------------------------------------------------------
COMMERCIAL VEHICLE ANALYSIS
--------------------------------------------------------------------------------
Check for null values in commercial_vehicle field
*/
SELECT DISTINCT commercial_vehicle
FROM Staging_Violation
WHERE commercial_vehicle IS NULL
-- RESULT: Commercial vehicle field does not have null values

/*
--------------------------------------------------------------------------------
YEAR FIELD ANALYSIS
--------------------------------------------------------------------------------
Analyze year field for data quality issues
*/
-- Check for null values in year field
SELECT year, COUNT(*)
FROM Staging_Violation
WHERE year IS NULL
GROUP BY year;
-- RESULT: Year has 6,424 null values

-- Strategy: Replace null year values with default value of 1900
SELECT 
  CASE 
    WHEN [year] IS NULL THEN 1900
    ELSE [year]
  END AS [year],
  COUNT(*) AS count
FROM Staging_Violation
GROUP BY 
  CASE 
    WHEN [year] IS NULL THEN 1900
    ELSE [year]
  END;

-- Final year transformation logic
SELECT 
  CASE 
    WHEN [year] IS NULL THEN 1900
    ELSE [year]
  END AS [year]
FROM Staging_Violation


/*
--------------------------------------------------------------------------------
MAKE FIELD ANALYSIS
--------------------------------------------------------------------------------
Analyze vehicle make field for data quality issues
*/
-- Check for null values in make field
SELECT make, COUNT(*)
FROM Staging_Violation
WHERE make IS NULL
GROUP BY make;
-- RESULT: 1 record with null make

-- Strategy: Replace null make values with 'n/a'
SELECT 
  CASE 
    WHEN [make] IS NULL THEN 'n/a'
    ELSE [make]
  END AS [make]
FROM Staging_Violation
WHERE make IS NULL

/*
--------------------------------------------------------------------------------
COLOR FIELD ANALYSIS
--------------------------------------------------------------------------------
Analyze vehicle color field for data quality issues
*/
-- Check for null values in color field
SELECT DISTINCT color, COUNT(*)
FROM Staging_Violation
WHERE color IS NULL
GROUP BY color
-- RESULT: 1,746 rows with null color

-- Strategy: Replace null color values with 'n/a'
SELECT DISTINCT
  CASE 
    WHEN [color] IS NULL THEN 'n/a'
    ELSE [color]
  END AS [color]
FROM Staging_Violation

/*
--------------------------------------------------------------------------------
MODEL FIELD ANALYSIS
--------------------------------------------------------------------------------
Analyze vehicle model field for data quality issues
*/
-- Check for null values in model field
SELECT DISTINCT model, COUNT(*)
FROM Staging_Violation
WHERE model IS NULL
GROUP BY model
-- RESULT: 32 records with null model

-- Strategy: Replace null model values with 'n/a'
SELECT DISTINCT 
    CASE
        WHEN model IS NULL THEN 'n/a'
        ELSE model
    END AS model
FROM Staging_Violation

/*
================================================================================
FINAL DATA TRANSFORMATION QUERY
================================================================================
This query applies all data cleansing rules to prepare vehicle data for NDS
*/
-- Combined transformation query with all cleansing rules applied
SELECT 
    vehicle_type,                            -- Will be mapped to vehicle_type_id via lookup
    commercial_vehicle,                      -- Already confirmed no NULLs
    CASE 
        WHEN [year] IS NULL THEN 1900
        ELSE [year]
    END AS [year],                          -- Default null years to 1900
    CASE 
        WHEN [make] IS NULL THEN 'n/a'
        ELSE [make]
    END AS [make],                          -- Default null makes to 'n/a'
    CASE 
        WHEN [color] IS NULL THEN 'n/a'
        ELSE [color]
    END AS [color],                         -- Default null colors to 'n/a'
    CASE 
        WHEN [model] IS NULL THEN 'n/a'
        ELSE [model]
    END AS [model]                          -- Default null models to 'n/a'
FROM Staging_Violation;

/*
================================================================================
VEHICLE TYPE LOOKUP TABLE PREPARATION
================================================================================
Creates a lookup table for vehicle types by cleaning and standardizing
the vehicle_type field from staging data
*/
-- Generate vehicle type lookup with cleaned type names
SELECT 
    ROW_NUMBER() OVER (ORDER BY cleaned_type) AS vehicle_type_id,
    cleaned_type AS type_name,
    old_type_name 
FROM (
    SELECT DISTINCT
        -- Remove text within parentheses and trim whitespace
        LTRIM(
            CASE 
                WHEN CHARINDEX('(', raw_type) > 0 
                    THEN LEFT(raw_type, CHARINDEX('(', raw_type) - 1)
                ELSE raw_type
            END
        ) AS cleaned_type,
        raw_type AS old_type_name
    FROM (
        -- Extract type portion after the dash character
        SELECT DISTINCT
            LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS raw_type
        FROM Staging_Violation
    ) AS base
) AS final
ORDER BY vehicle_type_id;

/*
================================================================================
FINAL ETL QUERY WITH VEHICLE TYPE MAPPING
================================================================================
This query joins staging data with the vehicle type lookup to produce
the final dataset ready for loading into NDS.Vehicle table
*/
-- Complete ETL query with vehicle type lookup join
WITH VehicleType_CTE AS (
    -- Create vehicle type lookup as CTE
    SELECT 
        ROW_NUMBER() OVER (ORDER BY cleaned_type) AS vehicle_type_id,
        cleaned_type AS type_name,
        old_type_name 
    FROM (
        SELECT DISTINCT
            LTRIM(
                CASE 
                    WHEN CHARINDEX('(', raw_type) > 0 
                        THEN LEFT(raw_type, CHARINDEX('(', raw_type) - 1)
                    ELSE raw_type
                END
            ) AS cleaned_type,
            raw_type AS old_type_name
        FROM (
            SELECT DISTINCT
                LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS raw_type
            FROM Staging_Violation
        ) AS base
    ) AS final
)
-- Main ETL query with all transformations and type mapping
SELECT 
    vt.vehicle_type_id,                     -- Mapped vehicle type ID
    sv.commercial_vehicle,                  -- Commercial vehicle flag (no nulls)
    CASE 
        WHEN sv.[year] IS NULL THEN 1900
        ELSE sv.[year]
    END AS [year],                          -- Year with null handling
    CASE 
        WHEN sv.[make] IS NULL THEN 'n/a'
        ELSE sv.[make]
    END AS [make],                          -- Make with null handling
    CASE 
        WHEN sv.[color] IS NULL THEN 'n/a'
        ELSE sv.[color]
    END AS [color],                         -- Color with null handling
    CASE 
        WHEN sv.[model] IS NULL THEN 'n/a'
        ELSE sv.[model]
    END AS [model]                          -- Model with null handling
FROM Staging_Violation sv
JOIN VehicleType_CTE vt
    -- Join on cleaned vehicle type name
    ON LTRIM(SUBSTRING(sv.vehicle_type, CHARINDEX('-', sv.vehicle_type) + 1, LEN(sv.vehicle_type))) = vt.old_type_name

