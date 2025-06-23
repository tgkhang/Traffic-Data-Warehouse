-- Fact Table 1: Analysis of violations by type of car in one month
-- This table aggregates violation data by vehicle type and month for analysis

CREATE TABLE Fact.Violation_By_Vehicle_Type_Monthly (
    violation_vehicle_monthly_key INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    
    -- Dimension Keys
    vehicle_key INT NULL,  -- Foreign key to Vehicle table
    year_month_key INT NULL,  -- Format: YYYYMM for monthly aggregation
    geography_key INT NULL,  -- Foreign key to Geography table (for location context)
    
    -- Measures/Facts
    total_violations INT NOT NULL DEFAULT 0,  -- Total number of violations
    speeding_violations INT NOT NULL DEFAULT 0,  -- Count of speeding violations
    parking_violations INT NOT NULL DEFAULT 0,  -- Count of parking violations
    traffic_violations INT NOT NULL DEFAULT 0,  -- Count of traffic violations
    other_violations INT NOT NULL DEFAULT 0,  -- Count of other violation types
    
    -- Accident-related measures
    violations_with_accidents INT NOT NULL DEFAULT 0,  -- Violations that resulted in accidents
    violations_with_injury INT NOT NULL DEFAULT 0,  -- Violations with personal injury
    violations_with_property_damage INT NOT NULL DEFAULT 0,  -- Violations with property damage
    fatal_violations INT NOT NULL DEFAULT 0,  -- Fatal violations
    
    -- Special circumstances
    commercial_vehicle_violations INT NOT NULL DEFAULT 0,  -- Violations involving commercial vehicles
    alcohol_related_violations INT NOT NULL DEFAULT 0,  -- Alcohol-related violations
    work_zone_violations INT NOT NULL DEFAULT 0,  -- Work zone violations
    
    -- Average measures
    avg_violations_per_day DECIMAL(10,2) NULL,  -- Average violations per day in the month
    
    -- Date attributes for easier querying
    year SMALLINT NOT NULL,
    month TINYINT NOT NULL,
    month_name NVARCHAR(20) NOT NULL,
    
    -- Constraints
    CONSTRAINT FK_ViolationMonthly_Vehicle 
        FOREIGN KEY (vehicle_key) REFERENCES Dim.Vehicle(vehicle_key),
    CONSTRAINT FK_ViolationMonthly_Geography 
        FOREIGN KEY (geography_key) REFERENCES Dim.Geography(geography_key)
);
go
-- Create indexes for better performance
CREATE INDEX IX_ViolationMonthly_YearMonth ON Fact.Violation_By_Vehicle_Type_Monthly(year_month_key);
CREATE INDEX IX_ViolationMonthly_Vehicle ON Fact.Violation_By_Vehicle_Type_Monthly(vehicle_key);
CREATE INDEX IX_ViolationMonthly_Geography ON Fact.Violation_By_Vehicle_Type_Monthly(geography_key);

GO


SELECT top 1000
    div.vehicle_key,
    CAST(FORMAT(v.datetime_of_stop, 'yyyyMM') AS INT) AS year_month_key,
    dig.geography_key,
    
    -- Count measures
    COUNT(*) AS total_violations,
    SUM(CASE WHEN LOWER(v.description) LIKE '%speed%' THEN 1 ELSE 0 END) AS speeding_violations,
    SUM(CASE WHEN LOWER(v.description) LIKE '%park%' THEN 1 ELSE 0 END) AS parking_violations,
    SUM(CASE WHEN LOWER(v.description) LIKE '%traffic%' THEN 1 ELSE 0 END) AS traffic_violations,
    SUM(CASE WHEN LOWER(v.description) NOT LIKE '%speed%' 
                  AND LOWER(v.description) NOT LIKE '%park%' 
                  AND LOWER(v.description) NOT LIKE '%traffic%' THEN 1 ELSE 0 END) AS other_violations,
    
    -- Accident-related measures
    SUM(CASE WHEN vo.accident = 1 THEN 1 ELSE 0 END) AS violations_with_accidents,
    SUM(CASE WHEN vo.personal_injury = 1 THEN 1 ELSE 0 END) AS violations_with_injury,
    SUM(CASE WHEN vo.property_damage = 1 THEN 1 ELSE 0 END) AS violations_with_property_damage,
    SUM(CASE WHEN vo.fatal = 1 THEN 1 ELSE 0 END) AS fatal_violations,
    
    -- Special circumstances
    SUM(CASE WHEN vd.commercial_vehicle = 1 THEN 1 ELSE 0 END) AS commercial_vehicle_violations,
    SUM(CASE WHEN vd.alcohol = 1 THEN 1 ELSE 0 END) AS alcohol_related_violations,
    SUM(CASE WHEN vd.work_zone = 1 THEN 1 ELSE 0 END) AS work_zone_violations,
    
    -- Average violations per day
    CAST(COUNT(*) AS DECIMAL(10,2)) / DAY(EOMONTH(v.datetime_of_stop)) AS avg_violations_per_day,
    
    -- Date attributes
    YEAR(v.datetime_of_stop) AS year,
    MONTH(v.datetime_of_stop) AS month,
    DATENAME(MONTH, v.datetime_of_stop) AS month_name

FROM NDS.Violation v
LEFT JOIN NDS.Violation_Outcome vo ON vo.violation_id = v.violation_id
LEFT JOIN NDS.Violation_Detail vd ON vd.violation_id = v.violation_id
LEFT JOIN Dim.Vehicle div ON div.vehicle_id = v.vehicle_id
LEFT JOIN Dim.Geography dig ON dig.city_id = v.city_id
    AND ROUND(dig.longitude, 7) = ROUND(v.longitude, 7)
    AND ROUND(dig.latitude, 7) = ROUND(v.latitude, 7)
WHERE v.datetime_of_stop IS NOT NULL
GROUP BY 
    div.vehicle_key,
    CAST(FORMAT(v.datetime_of_stop, 'yyyyMM') AS INT),
    dig.geography_key,
    YEAR(v.datetime_of_stop),
    MONTH(v.datetime_of_stop),
    DATENAME(MONTH, v.datetime_of_stop),
    DAY(EOMONTH(v.datetime_of_stop));
