USE DWTraffic
GO




CREATE TABLE NDS.Vehicle_Type_Map (
    vehicle_id INT,
    type_name NVARCHAR(100),
    old_type_name NVARCHAR(100)
);




WITH RawData AS (
    SELECT DISTINCT
        vehicle_type
    FROM Bronze.Violation
    WHERE vehicle_type IS NOT NULL AND CHARINDEX('-', vehicle_type) > 0
),
Parsed AS (
    SELECT
        LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS raw_type,
        vehicle_type AS old_type_name
    FROM RawData
),
DistinctTypes AS (
    SELECT DISTINCT
        LTRIM(
            CASE 
                WHEN CHARINDEX('(', raw_type) > 0 
                    THEN LEFT(raw_type, CHARINDEX('(', raw_type) - 1)
                ELSE raw_type
            END
        ) AS type_name,
        old_type_name
    FROM Parsed
),
TypeWithID AS (
    SELECT 
        type_name,
        ROW_NUMBER() OVER (ORDER BY type_name) AS vehicle_id
    FROM (
        SELECT DISTINCT type_name FROM DistinctTypes
    ) AS unique_types
)
SELECT 
    t.vehicle_id,
    d.type_name,
    d.old_type_name
FROM DistinctTypes d
JOIN TypeWithID t ON d.type_name = t.type_name
ORDER BY t.vehicle_id, d.old_type_name;
