create table Fact.Accident (
    accident_id INT PRIMARY KEY,
    weather_snapshot_key INT NULL,  -- Foreign key to Weather_Snapshot table
    start_datetime_key BIGINT NULL,  -- Foreign key to Datetime table for start time
    end_datetime_key BIGINT NULL,  -- Foreign key to Datetime table for end time
    start_location_key INT NULL,  -- Foreign key to Geography table for start location
    end_location_key INT NULL,  -- Foreign key to Geography table for end location

    start_lat FLOAT NULL,  -- Starting latitude
    start_lng FLOAT NULL,  -- Starting longitude
    end_lat FLOAT NULL,  -- Ending latitude
    end_lng FLOAT NULL,  -- Ending longitude
    severity TINYINT NULL,  -- Severity of the accident (1-5 scale)
    distance_m FLOAT NULL,  -- Distance of the accident in meters
    description NVARCHAR(MAX) NULL,  -- Description of the accident
    street NVARCHAR(MAX) NULL,  -- Street where the accident occurred

    CONSTRAINT FK_Accident_Weather_Snapshot 
        FOREIGN KEY (weather_snapshot_key) REFERENCES Dim.Weather_Snapshot(weather_snapshot_key),
    CONSTRAINT FK_Accident_Start_Datetime 
        FOREIGN KEY (start_datetime_key) REFERENCES Dim.Datetime(datetime_key),
    CONSTRAINT FK_Accident_End_Datetime 
        FOREIGN KEY (end_datetime_key) REFERENCES Dim.Datetime(datetime_key),
    CONSTRAINT FK_Accident_Start_Location 
        FOREIGN KEY (start_location_key) REFERENCES Dim.Geography(geography_key),
    CONSTRAINT FK_Accident_End_Location 
        FOREIGN KEY (end_location_key) REFERENCES Dim.Geography(geography_key)
)





select
diw.weather_snapshot_key,
didt.datetime_key as start_datetime_key,
didt1.datetime_key as end_datetime_key,
dig.geography_key as start_location_key,
dig1.geography_key as end_location_key,

a.accident_id, 
a.start_lat, a.start_lng, a.end_lat, a.end_lng,
a.street,
a.severity,
a.distance_m, a.description
from NDS.Accident a
join NDS.Accident_Detail ad on ad.accident_id= a.accident_id
join Dim.Weather_Snapshot diw on diw.weather_snapshot_id= a.weather_snapshot_id
left join Dim.Datetime didt on didt.datetime_key = CONVERT(BIGINT, FORMAT(a.start_time, 'yyyyMMddHHmmss'))
left join Dim.Datetime didt1 on didt1.datetime_key = CONVERT(BIGINT, FORMAT(a.end_time, 'yyyyMMddHHmmss'))
left JOIN Dim.Geography dig
  ON dig.city_id = a.city_id
	 AND ROUND(dig.longitude, 4) = ROUND(a.start_lng, 7)
	 AND ROUND(dig.latitude, 4) = ROUND(a.start_lat, 7)
left JOIN Dim.Geography dig1
  ON dig1.city_id = a.city_id
	 AND ROUND(dig1.longitude, 4) = ROUND(a.end_lng, 7)
	 AND ROUND(dig1.latitude, 4) = ROUND(a.end_lat, 7)