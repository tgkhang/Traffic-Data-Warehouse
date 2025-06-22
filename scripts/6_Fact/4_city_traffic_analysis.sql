-- Fact Table 2: Analysis of violations and accidents through city
-- This table provides comprehensive analysis of traffic incidents by city

CREATE TABLE Fact.City_Traffic_Analysis (
    city_traffic_key INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key
    
    -- Dimension Keys
    geography_key INT NULL,  -- Foreign key to Geography table (city-based)
    year_month_key INT NULL,  -- Format: YYYYMM for monthly aggregation
    
    -- Violation Measures
    total_violations INT NOT NULL DEFAULT 0,  -- Total violations in the city
    severe_violations INT NOT NULL DEFAULT 0,  -- High-severity violations
    minor_violations INT NOT NULL DEFAULT 0,  -- Low-severity violations
    
    -- Violation Types
    speeding_violations INT NOT NULL DEFAULT 0,
    parking_violations INT NOT NULL DEFAULT 0,
    dui_violations INT NOT NULL DEFAULT 0,  -- Driving under influence
    commercial_violations INT NOT NULL DEFAULT 0,  -- Commercial vehicle violations
    work_zone_violations INT NOT NULL DEFAULT 0,
    
    -- Accident Measures  
    total_accidents INT NOT NULL DEFAULT 0,  -- Total accidents in the city
    severe_accidents INT NOT NULL DEFAULT 0,  -- Severity 4-5 accidents
    moderate_accidents INT NOT NULL DEFAULT 0,  -- Severity 2-3 accidents
    minor_accidents INT NOT NULL DEFAULT 0,  -- Severity 1 accidents
    
    -- Accident Impact
    fatal_accidents INT NOT NULL DEFAULT 0,  -- Fatal accidents
    injury_accidents INT NOT NULL DEFAULT 0,  -- Accidents with injuries
    property_damage_accidents INT NOT NULL DEFAULT 0,  -- Property damage only
    
    -- Combined Analysis
    violations_leading_to_accidents INT NOT NULL DEFAULT 0,  -- Violations that caused accidents
    accident_violation_ratio DECIMAL(10,4) NULL,  -- Accidents per 100 violations
    
    -- Safety Metrics
    avg_accident_severity DECIMAL(4,2) NULL,  -- Average severity of accidents
    avg_accident_distance_m DECIMAL(10,2) NULL,  -- Average distance of accidents
    
    -- Geographic Context
    city_name NVARCHAR(255) NULL,
    county_name NVARCHAR(50) NULL,
    state_name NVARCHAR(100) NULL,
    
    -- Time Context
    year SMALLINT NOT NULL,
    month TINYINT NOT NULL,
    month_name NVARCHAR(20) NOT NULL,
    
    -- Performance Indicators
    incidents_per_1000_population DECIMAL(10,2) NULL,  -- Traffic incidents per 1000 residents (if population data available)
    safety_score DECIMAL(5,2) NULL,  -- Custom safety score (100 - normalized incident rate)
    
    -- Constraints
    CONSTRAINT FK_CityTraffic_Geography 
        FOREIGN KEY (geography_key) REFERENCES Dim.Geography(geography_key)
);

-- Create indexes for better performance
CREATE INDEX IX_CityTraffic_Geography ON Fact.City_Traffic_Analysis(geography_key);
CREATE INDEX IX_CityTraffic_YearMonth ON Fact.City_Traffic_Analysis(year_month_key);
CREATE INDEX IX_CityTraffic_City ON Fact.City_Traffic_Analysis(city_name);
CREATE INDEX IX_CityTraffic_State ON Fact.City_Traffic_Analysis(state_name);

GO


WITH ViolationData AS (
    SELECT 
        dig.geography_key,
        dig.city_name,
        dig.county_name,
        dig.state_name,
        CAST(FORMAT(v.datetime_of_stop, 'yyyyMM') AS INT) AS year_month_key,
        YEAR(v.datetime_of_stop) AS year,
        MONTH(v.datetime_of_stop) AS month,
        DATENAME(MONTH, v.datetime_of_stop) AS month_name,
        
        -- Violation counts
        COUNT(*) AS total_violations,
        SUM(CASE WHEN vo.fatal = 1 OR vo.personal_injury = 1 THEN 1 ELSE 0 END) AS severe_violations,
        SUM(CASE WHEN vo.fatal = 0 AND vo.personal_injury = 0 THEN 1 ELSE 0 END) AS minor_violations,
        
        -- Violation types
        SUM(CASE WHEN LOWER(v.description) LIKE '%speed%' THEN 1 ELSE 0 END) AS speeding_violations,
        SUM(CASE WHEN LOWER(v.description) LIKE '%park%' THEN 1 ELSE 0 END) AS parking_violations,
        SUM(CASE WHEN vd.alcohol = 1 THEN 1 ELSE 0 END) AS dui_violations,
        SUM(CASE WHEN vd.commercial_vehicle = 1 THEN 1 ELSE 0 END) AS commercial_violations,
        SUM(CASE WHEN vd.work_zone = 1 THEN 1 ELSE 0 END) AS work_zone_violations,
        
        -- Violations leading to accidents
        SUM(CASE WHEN vo.accident = 1 THEN 1 ELSE 0 END) AS violations_leading_to_accidents
        
    FROM NDS.Violation v
    LEFT JOIN NDS.Violation_Outcome vo ON vo.violation_id = v.violation_id
    LEFT JOIN NDS.Violation_Detail vd ON vd.violation_id = v.violation_id
    LEFT JOIN Dim.Geography dig ON dig.city_id = v.city_id
        AND ROUND(dig.longitude, 7) = ROUND(v.longitude, 7)
        AND ROUND(dig.latitude, 7) = ROUND(v.latitude, 7)
    WHERE v.datetime_of_stop IS NOT NULL
        AND dig.geography_key IS NOT NULL
    GROUP BY 
        dig.geography_key, dig.city_name, dig.county_name, dig.state_name,
        CAST(FORMAT(v.datetime_of_stop, 'yyyyMM') AS INT),
        YEAR(v.datetime_of_stop), MONTH(v.datetime_of_stop),
        DATENAME(MONTH, v.datetime_of_stop)
),
AccidentData AS (
    SELECT 
        dig.geography_key,
        dig.city_name,
        dig.county_name,
        dig.state_name,
        CAST(FORMAT(a.start_time, 'yyyyMM') AS INT) AS year_month_key,
        YEAR(a.start_time) AS year,
        MONTH(a.start_time) AS month,
        DATENAME(MONTH, a.start_time) AS month_name,
        
        -- Accident counts
        COUNT(*) AS total_accidents,
        SUM(CASE WHEN a.severity >= 4 THEN 1 ELSE 0 END) AS severe_accidents,
        SUM(CASE WHEN a.severity BETWEEN 2 AND 3 THEN 1 ELSE 0 END) AS moderate_accidents,
        SUM(CASE WHEN a.severity = 1 THEN 1 ELSE 0 END) AS minor_accidents,
        
        -- Safety metrics
        AVG(CAST(a.severity AS DECIMAL(4,2))) AS avg_accident_severity,
        AVG(a.distance_m) AS avg_accident_distance_m
        
    FROM NDS.Accident a
    LEFT JOIN NDS.Accident_Detail ad ON ad.accident_id = a.accident_id
    LEFT JOIN Dim.Geography dig ON dig.city_id = a.city_id
        AND ROUND(dig.longitude, 4) = ROUND(a.start_lng, 7)
        AND ROUND(dig.latitude, 4) = ROUND(a.start_lat, 7)
    WHERE a.start_time IS NOT NULL
        AND dig.geography_key IS NOT NULL
    GROUP BY 
        dig.geography_key, dig.city_name, dig.county_name, dig.state_name,
        CAST(FORMAT(a.start_time, 'yyyyMM') AS INT),
        YEAR(a.start_time), MONTH(a.start_time),
        DATENAME(MONTH, a.start_time)
)
SELECT top 1000
    COALESCE(v.geography_key, a.geography_key) AS geography_key,
    COALESCE(v.year_month_key, a.year_month_key) AS year_month_key,
    
    -- Violation measures
    COALESCE(v.total_violations, 0) AS total_violations,
    COALESCE(v.severe_violations, 0) AS severe_violations,
    COALESCE(v.minor_violations, 0) AS minor_violations,
    COALESCE(v.speeding_violations, 0) AS speeding_violations,
    COALESCE(v.parking_violations, 0) AS parking_violations,
    COALESCE(v.dui_violations, 0) AS dui_violations,
    COALESCE(v.commercial_violations, 0) AS commercial_violations,
    COALESCE(v.work_zone_violations, 0) AS work_zone_violations,
    
    -- Accident measures
    COALESCE(a.total_accidents, 0) AS total_accidents,
    COALESCE(a.severe_accidents, 0) AS severe_accidents,
    COALESCE(a.moderate_accidents, 0) AS moderate_accidents,
    COALESCE(a.minor_accidents, 0) AS minor_accidents,
    
    -- Combined analysis
    COALESCE(v.violations_leading_to_accidents, 0) AS violations_leading_to_accidents,
    CASE 
        WHEN COALESCE(v.total_violations, 0) > 0 
        THEN CAST(COALESCE(a.total_accidents, 0) * 100.0 / v.total_violations AS DECIMAL(10,4))
        ELSE NULL 
    END AS accident_violation_ratio,
    
    -- Safety metrics
    a.avg_accident_severity,
    a.avg_accident_distance_m,
    
    -- Geographic context
    COALESCE(v.city_name, a.city_name) AS city_name,
    COALESCE(v.county_name, a.county_name) AS county_name,
    COALESCE(v.state_name, a.state_name) AS state_name,
    
    -- Time context
    COALESCE(v.year, a.year) AS year,
    COALESCE(v.month, a.month) AS month,
    COALESCE(v.month_name, a.month_name) AS month_name,
    
    -- Safety score (100 - normalized incident rate)
    CASE 
        WHEN (COALESCE(v.total_violations, 0) + COALESCE(a.total_accidents, 0)) > 0
        THEN 100.0 - LEAST(100.0, (COALESCE(v.total_violations, 0) + COALESCE(a.total_accidents, 0)) * 0.1)
        ELSE 100.0
    END AS safety_score

FROM ViolationData v
FULL OUTER JOIN AccidentData a ON v.geography_key = a.geography_key 
    AND v.year_month_key = a.year_month_key
WHERE COALESCE(v.geography_key, a.geography_key) IS NOT NULL;
