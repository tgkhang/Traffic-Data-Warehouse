
create table NDS.Violation_Outcome (
    violation_outcome_id INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the violation outcome
    violation_id INT NOT NULL,                           -- Foreign key to Violation table
    accident BIT NULL,                     -- Indicates if the violation is related to an accident
    personal_injury BIT NULL,  -- Indicates if there was personal injury
    property_damage BIT NULL,  -- Indicates if there was property damage
    fatal BIT NULL,            -- Indicates if the violation resulted in a fatality
    contributed_to_accident BIT NULL,  -- Indicates if the violation contributed to an accident
);
go

select distinct 
id, accident,personal_injury, property_damage, fatal, contributed_to_accident
from Bronze.Violation


create table NDS.Violation_Detail (
    violation_detail_id INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the violation detail
    violation_id INT NOT NULL,                           -- Foreign key to Violation table
   
    belts BIT NULL,                                      -- Indicates if seat belts were used
    commercial_license BIT NULL,                         -- Indicates if a commercial license was involved
    hazmat BIT NULL,                                     -- Indicates if hazardous materials were involved
    commercial_vehicle BIT NULL,                         -- Indicates if a commercial vehicle was involved
    alcohol BIT NULL,                                    -- Indicates if alcohol was involved
    work_zone BIT NULL,                                  -- Indicates if the violation occurred in a work zone
);



select distinct 
id as violation_id, belts, commercial_license, commercial_vehicle, hazmat,alcohol, work_zone
from Bronze.Violation