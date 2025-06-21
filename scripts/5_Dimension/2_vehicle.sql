CREATE TABLE Dim.Vehicle (
    vehicle_key INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    vehicle_id  int NOT NULL,          -- Original vehicle ID from source
    vehicle_type NVARCHAR(255) NOT NULL,  -- Type of vehicle (e.g., car, truck)
    year SMALLINT NULL,                -- Manufacturing year of the vehicle
    make NVARCHAR(255) NULL,            -- Vehicle manufacturer (e.g., Ford, Toyota)
    model NVARCHAR(255) NULL,           -- Vehicle model (e.g., Camry, F-150)
    color NVARCHAR(255) NULL,            -- Vehicle color
    commercial_vehicle BIT NULL,        -- Flag indicating if vehicle is commercial
)


select 
v.vehicle_id, v.year, v.make, v.model, v.color,v.commercial_vehicle, t.type_name
from NDS.Vehicle v
join NDS.Vehicle_Type_Map t on t.vehicle_id= v.vehicle_type_id