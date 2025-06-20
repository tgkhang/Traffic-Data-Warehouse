CREATE TABLE NDS.Accident_Detail(
    accident_detail_id INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the accident details
	accident_id NVARCHAR(100) NOT NULL,  
	[amenity] [bit] NULL,
	[bump] [bit] NULL,
	[crossing] [bit] NULL,
	[give_way] [bit] NULL,
	[junction] [bit] NULL,
	[no_exit] [bit] NULL,
	[railway] [bit] NULL,
	[roundabout] [bit] NULL,
	[station] [bit] NULL,
	[stop] [bit] NULL,
	[traffic_calming] [bit] NULL,
	[traffic_signal] [bit] NULL,
	[turning_loop] [bit] NULL,
	[sunrise_sunset] [nvarchar](50) NULL,
	[civil_twilight] [nvarchar](50) NULL,
	[nautical_twilight] [nvarchar](50) NULL,
	[astronomical_twilight] [nvarchar](50) NULL
)
go



select distinct 
id as accident_id, 
amenity, bump, crossing, give_way, junction, no_exit, railway, roundabout, station, stop, traffic_calming, traffic_signal,
turning_loop, sunrise_sunset, civil_twilight, nautical_twilight, astronomical_twilight
from Bronze.Accident
