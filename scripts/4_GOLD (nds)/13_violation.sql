

Create table NDS.Violation(
    violation_id INT PRIMARY KEY,  -- Unique identifier for the violation
    violation_outcome_id INT NULL,            -- Foreign key to Violation_Outcome table
    violation_detail_id INT NULL,             -- Foreign key to Violation_Detail table
    sub_agency_id INT NULL,                -- Foreign key to SubAgency table
    datetime_of_stop DATETIME2(7) NULL,         -- Date and time of the stop
    city NVARCHAR(100) NULL,                    -- City where the violation occurred
    vehicle_id int NULL,                -- Foreign key to Vehicle table
    driver_type_id int NULL,                -- Foreign key to Driver_Type table
    longitude FLOAT NULL,                     -- Longitude coordinate of the violation location
    latitude FLOAT NULL,                      -- Latitude coordinate of the violation location
    description NVARCHAR(MAX) NULL,           -- Description of the violation
    location NVARCHAR(MAX) NULL,              -- Address or location of the violation
    state NVARCHAR(50) NULL,                  -- State where the violation occurred
    violation_type NVARCHAR(50) NULL,         -- Type of violation
    arrest_type NVARCHAR(50) NULL,            -- Type of arrest made during the violation
)


select distinct top 10
v.id, 
v.datetime_of_stop, v.city,
ve.vehicle_id,d.driver_type_id, v.longitude, v.latitude, v.description, 
v.location, v.state, v.violation_type,v.arrest_type,vo.violation_outcome_id,
vd.violation_detail_id, sa.sub_agency_id
from Bronze.Violation v
left join NDS.Violation_Outcome vo on vo.violation_id = v.id
left join NDS.Violation_Detail vd on vd.violation_id= v.id
left join NDS.SubAgency sa on sa.sub_agency_name= v.sub_agency
left join NDS.Vehicle ve on v.year= ve.year and v.make= ve.make and v.model= ve.model and v.model = ve.model
left join NDS.City ci on ci.city_name= v.driver_city
left join NDS.Driver_Type d on v.race=d.race and v.gender=d.gender and ci.city_id=d.driver_city_id and v.driver_state= d.driver_state
