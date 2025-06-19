
use DWTraffic
go


CREATE TABLE NDS.County (
    county_id INT PRIMARY KEY IDENTITY(1,1),    
    [county_name] [nvarchar](50) NULL,
	[state_code] [nvarchar](70) NULL,
);
GO


/*
================================================================================
COUNTY DATA EXTRACTION WITH NULL HANDLING
================================================================================
This query extracts distinct county and state combinations from the staging
accident data, applying data cleansing rules to handle null values.

Purpose: Generate clean county data for the NDS.County lookup table
Data Source: Staging_Accident table
Cleansing Rules:
- Replace null state_code values with 'n/a'
- Replace null county_name values with 'n/a'
- Remove duplicates using DISTINCT
- Sort alphabetically by county name for easy review
*/
SELECT DISTINCT 
    CASE 
        WHEN state IS NULL THEN 'n/a'
        ELSE state
    END AS state_code,                      
    CASE 
        WHEN county_name IS NULL THEN 'n/a'
        ELSE county_name
    END AS county_name                      
FROM Bronze.Accident
ORDER BY county_name ASC