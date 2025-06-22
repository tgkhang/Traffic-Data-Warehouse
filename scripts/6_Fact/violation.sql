IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'Fact')
    EXEC('CREATE SCHEMA Fact');
GO


create table Fact.Violation(
    violation_id INT PRIMARY KEY,  

    vehicle_key INT NULL,  -- Foreign key to Vehicle table
    geography_key INT NULL,  -- Foreign key to Geography table
    driver_type_key INT NULL,  -- Foreign key to DriverType table
    datetime_key BIGINT NULL,  -- Foreign key to Date table
    agency_key INT NULL,  -- Foreign key to Agency table

    description NVARCHAR(max) NULL,  -- Description of the violation
    detail_location NVARCHAR(max) NULL,  -- Detailed location of the violation
    violation_type NVARCHAR(100) NULL,  -- Type of violation (e.g., speeding, parking)
    arrest_type NVARCHAR(100) NULL,  -- Type of arrest (if applicable)

    is_accident BIT NULL,  -- Indicates if the violation is related to an accident
    personal_injury BIT NULL,  -- Indicates if there was a personal injury
    property_damage BIT NULL,  -- Indicates if there was property damage
    fatal BIT NULL,  -- Indicates if the violation resulted in a fatality
    contributed_to_accident BIT NULL,  -- Indicates if the violation contributed to an accident

    belts BIT NULL,  -- Indicates if seat belts were used
    hazmat BIT NULL,  -- Indicates if hazardous materials were involved
    commercial_vehicle BIT NULL,  -- Indicates if a commercial vehicle was involved
    commercial_license BIT NULL,  -- Indicates if a commercial license was required
    alcohol_involved BIT NULL,  -- Indicates if alcohol was involved
    work_zone BIT NULL,  -- Indicates if the violation occurred in a work zone


    CONSTRAINT FK_Violation_Vehicle 
        FOREIGN KEY (vehicle_key) REFERENCES Dim.Vehicle(vehicle_key),
    CONSTRAINT FK_Violation_Geography 
        FOREIGN KEY (geography_key) REFERENCES Dim.Geography(geography_key),
    CONSTRAINT FK_Violation_DriverType 
        FOREIGN KEY (driver_type_key) REFERENCES Dim.Driver_Type(driver_type_key),
    CONSTRAINT FK_Violation_Date 
        FOREIGN KEY (datetime_key) REFERENCES Dim.Datetime(datetime_key),
    CONSTRAINT FK_Violation_Agency 
        FOREIGN KEY (agency_key) REFERENCES Dim.Agency(agency_key)
)
go



select top 10 
*
from NDS.Violation v
join NDS.Violation_Outcome vo on vo.violation_id= v.violation_id
join NDS.Violation_Detail vd on vd.violation_id= v.violation_id



select top 10 
    v.violation_id,
	div.vehicle_key,
	didt.datetime_key,
	diag.agency_key,
	dig.geography_key,
	didr.driver_type_key,

	--v.driver_type_id,
	v.description, v.location, v.violation_type, v.arrest_type, 

	--v.longitude, v.latitude,

	vo.accident,vo.personal_injury,vo.property_damage, vo.fatal,vo.contributed_to_accident,

	vd.belts, vd.commercial_license, vd.hazmat, vd.commercial_vehicle, vd.alcohol, vd.work_zone
from NDS.Violation v
left join NDS.Violation_Outcome vo on vo.violation_id= v.violation_id
left join NDS.Violation_Detail vd on vd.violation_id= v.violation_id
left join Dim.Vehicle div on div.vehicle_id= v.vehicle_id
left join Dim.Datetime didt on didt.datetime_key = CONVERT(BIGINT, FORMAT(v.datetime_of_stop, 'yyyyMMddHHmmss'))
left join Dim.Driver_Type didr on didr.driver_type_id = v.driver_type_id
left join Dim.Agency diag on diag.sub_agency_id = v.sub_agency_id
left JOIN Dim.Geography dig
  ON dig.city_id = v.city_id
	 AND ROUND(dig.longitude, 4) = ROUND(v.longitude, 4)
	 AND ROUND(dig.latitude, 4) = ROUND(v.latitude, 4)
