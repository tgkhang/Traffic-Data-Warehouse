use DWTraffic
go


CREATE TABLE NDS.Vehicle_Type (
    vehicle_type_id INT PRIMARY KEY,
    type_name NVARCHAR(50)
);
go

select vehicle_type from Staging_Violation where vehicle_type is null

SELECT DISTINCT
    CAST(SUBSTRING(vehicle_type, 1, CHARINDEX('-', vehicle_type) - 1) AS INT) AS vehicle_type_id,
    LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS type_name
FROM Staging_Violation
order by vehicle_type_id


----
SELECT 
    ROW_NUMBER() OVER (ORDER BY cleaned_type) AS vehicle_type_id,
    cleaned_type AS type_name
FROM (
    SELECT DISTINCT
        LTRIM(
            CASE 
                WHEN CHARINDEX('(', raw_type) > 0 
                    THEN LEFT(raw_type, CHARINDEX('(', raw_type) - 1)
                ELSE raw_type
            END
        ) AS cleaned_type
    FROM (
        SELECT distinct
            LTRIM(SUBSTRING(vehicle_type, CHARINDEX('-', vehicle_type) + 1, LEN(vehicle_type))) AS raw_type
        FROM Staging_Violation
    ) AS base
) AS final
ORDER BY vehicle_type_id;
