
USE DWTraffic
GO



CREATE TABLE NDS.Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),    -- Surrogate key for vehicle records
    vehicle_type_id INT NOT NULL,                -- Foreign key to Vehicle_Type lookup
    [year] SMALLINT NULL,                        -- Manufacturing year of the vehicle
    [make] NVARCHAR(50) NULL,                    -- Vehicle manufacturer (e.g., Ford, Toyota)
    [model] NVARCHAR(50) NULL,                   -- Vehicle model (e.g., Camry, F-150)
    [color] NVARCHAR(50) NULL,                   -- Vehicle color
    [commercial_vehicle] BIT NULL,               -- Flag indicating if vehicle is commercial
    -- CONSTRAINT FK_Vehicle_VehicleType FOREIGN KEY (vehicle_type_id)
    --     REFERENCES NDS.Vehicle_Type(vehicle_type_id)
);
GO



select 
	m.vehicle_id as vehicle_type_id,
	v.commercial_vehicle,
	CASE 
        WHEN v.year IS NULL THEN 1900
        ELSE v.year
    END AS [year],                          -- Year with null handling
    CASE 
        WHEN v.[make] IS NULL THEN 'n/a'
        ELSE v.[make]
    END AS [make],                          -- Make with null handling
    CASE 
        WHEN v.[color] IS NULL THEN 'n/a'
        ELSE v.[color]
    END AS [color],                         -- Color with null handling
    CASE 
        WHEN v.[model] IS NULL THEN 'n/a'
        ELSE v.[model]
    END AS [model] 
from Bronze.Violation v
join NDS.Vehicle_Type_Map m on m.old_type_name = v.vehicle_type