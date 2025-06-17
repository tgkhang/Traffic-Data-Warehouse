/*
================================================================================
SCRIPT: 2_vehicle_type.sql
PURPOSE: Creates and populates the NDS.Vehicle_Type lookup table
         This table standardizes vehicle type information from staging data
AUTHOR: Traffic Data Warehouse Project
DATE: June 2025
================================================================================
*/

-- Switch to the Data Warehouse database
USE DWTraffic
GO

/*
================================================================================
TABLE CREATION: NDS.Vehicle_Type
================================================================================
This lookup table stores standardized vehicle type information.
It serves as a reference table for the Vehicle table to normalize
vehicle type data and ensure data consistency.
*/
CREATE TABLE NDS.Vehicle_Type (
    vehicle_type_id INT PRIMARY KEY,        -- Unique identifier for vehicle type
    type_name NVARCHAR(50)                  -- Standardized vehicle type name
);
GO

/*
================================================================================
DATA QUALITY ANALYSIS FOR VEHICLE TYPES
================================================================================
Analyze the vehicle_type field in staging data to understand structure
and prepare for standardization
*/

-- Check for null values in vehicle_type field
SELECT vehicle_type 
FROM Staging_Violation 
WHERE vehicle_type IS NULL
-- This query helps identify any missing vehicle type data

/*
--------------------------------------------------------------------------------
INITIAL VEHICLE TYPE EXTRACTION (APPROACH 1)
--------------------------------------------------------------------------------
Extract vehicle type ID and name using the original format parsing.
This assumes vehicle_type format is: "ID-TypeName"
*/
SELECT DISTINCT
    CAST(SUBSTRING(vehicle_type, 1, CHARINDEX('-', vehicle_type) - 1) AS INT) AS vehicle_type_id,
    LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS type_name
FROM Staging_Violation
ORDER BY vehicle_type_id


/*
--------------------------------------------------------------------------------
ENHANCED VEHICLE TYPE EXTRACTION (APPROACH 2)
--------------------------------------------------------------------------------
This approach provides better data cleaning by:
1. Extracting type names after the dash character
2. Removing parenthetical information for cleaner type names
3. Generating sequential IDs using ROW_NUMBER()
4. Preserving original type names for reference

This method is preferred for data standardization as it handles
inconsistent formatting and provides cleaner lookup values.
*/
SELECT 
    ROW_NUMBER() OVER (ORDER BY cleaned_type) AS vehicle_type_id,  -- Sequential ID generation
    cleaned_type AS type_name,                                    -- Cleaned type name for lookup
    old_type_name                                                 -- Original type name for reference
FROM (
    SELECT DISTINCT
        -- Remove text within parentheses and trim whitespace for clean type names
        LTRIM(
            CASE 
                WHEN CHARINDEX('(', raw_type) > 0 
                    THEN LEFT(raw_type, CHARINDEX('(', raw_type) - 1)  -- Remove parenthetical text
                ELSE raw_type                                          -- Keep as-is if no parentheses
            END
        ) AS cleaned_type,
        raw_type AS old_type_name
    FROM (
        -- Extract the type portion after the dash character from vehicle_type field
        SELECT DISTINCT
            LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS raw_type
        FROM Staging_Violation
    ) AS base
) AS final
ORDER BY vehicle_type_id;