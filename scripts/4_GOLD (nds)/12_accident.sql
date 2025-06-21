Create table NDS.Accident (
    accident_id INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the accident
    weather_snapshot_id INT NULL,  -- Foreign key to Weather_Snapshot table
    accident_detail_id INT NULL,  -- Foreign key to Accident_Detail table
    city_id INT NULL,  -- Foreign key to City table
    severity TINYINT NULL,                      -- Severity of the accident
    start_time DATETIME2(7) NULL,              -- Start time of the accident
    end_time DATETIME2(7) NULL,                -- End time of the accident
    start_lat FLOAT NULL,                       -- Starting latitude of the accident location
    start_lng FLOAT NULL,                       -- Starting longitude of the accident location
    end_lat FLOAT NULL,                         -- Ending latitude of the accident location
    end_lng FLOAT NULL,                         -- Ending longitude of the accident location
    distance_m FLOAT NULL,                      -- Distance in meters related to the accident
    description NVARCHAR(MAX) NULL,             -- Description of the accident
    street NVARCHAR(MAX) NULL,                  -- Street where the accident occurred
    
);


select distinct
	acd.accident_detail_id,
	ws.weather_snapshot_id,
	ci.city_id,
	acc.severity,
	acc.start_time,
	acc.end_time,
	start_lat, 
	start_lng,
	end_lat,
	end_lng,
	distance_m, 
	street,
	description	
from Bronze.Accident acc
left join NDS.City ci on ci.city_name= acc.city
left join NDS.Weather_Snapshot ws on ws.city_id = ci.city_id and ws.datetime= acc.weather_timestamp
left join NDS.Accident_Detail acd on acd.accident_id= acc.id