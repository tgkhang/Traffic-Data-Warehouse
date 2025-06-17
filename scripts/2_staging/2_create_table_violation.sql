use StagingDB
go

/****** Object:  Table [dbo].[Violation]    Script Date: 6/14/2025 12:16:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Staging_Violation](
	[date_of_stop] [date] NOT NULL,
	[time_of_stop] [time](7) NOT NULL,
	[agency] [nvarchar](50) NOT NULL,
	[sub_agency] [nvarchar](50) NOT NULL,
	[description] [nvarchar](150) NULL,
	[location] [nvarchar](50) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL,
	[accident] [nvarchar](50) NOT NULL,
	[belts] [bit] NULL,
	[personal_injury] [bit] NULL,
	[property_damage] [bit] NULL,
	[fatal] [nvarchar](50) NULL,
	[commercial_license] [bit] NULL,
	[hazmat] [nvarchar](50) NULL,
	[commercial_vehicle] [bit] NULL,
	[alcohol] [nvarchar](50) NULL,
	[work_zone] [nvarchar](50) NULL,
	[state] [nvarchar](50) NULL,
	[vehicle_type] [nvarchar](50) NULL,
	[year] [smallint] NULL,
	[make] [nvarchar](50) NULL,
	[model] [nvarchar](50) NULL,
	[color] [nvarchar](50) NULL,
	[violation_type] [nvarchar](50) NULL,
	[charge] [nvarchar](50) NULL,
	[article] [nvarchar](50) NULL,
	[contributed_to_accident] [bit] NULL,
	[race] [nvarchar](50) NULL,
	[gender] [nvarchar](50) NULL,
	[driver_city] [nvarchar](50) NULL,
	[driver_state] [nvarchar](50) NULL,
	[dl_state] [nvarchar](50) NULL,
	[arrest_type] [nvarchar](50) NULL,
	[geolocation] [nvarchar](50) NULL,
	[id] [int] NULL,
    source_system_code INT,
    create_time_stamp DATETIME,
    update_time_stamp DATETIME
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[Staging_Accident](
	[id] [nvarchar](50) NOT NULL,
	[source] [nvarchar](50) NULL,
	[severity] [tinyint] NULL,
	[start_time] [datetime2](7) NULL,
	[end_time] [datetime2](7) NULL,
	[start_lat] [float] NULL,
	[start_lng] [float] NULL,
	[end_lat] [float] NULL,
	[end_lng] [float] NULL,
	[distance_mi] [float] NULL,
	[description] [nvarchar](max) NULL,
	[street] [nvarchar](max) NULL,
	[city] [nvarchar](50) NULL,
	[county] [nvarchar](50) NULL,
	[state] [nvarchar](70) NULL,
	[zipcode] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[timezone] [nvarchar](50) NULL,
	[airport_code] [nvarchar](50) NULL,
	[weather_timestamp] [datetime2](7) NULL,
	[femperature_f] [float] NULL,
	[wind_chill_f] [float] NULL,
	[humidity] [float] NULL,
	[pressure_in] [float] NULL,
	[visibility_mi] [float] NULL,
	[wind_direction] [nvarchar](50) NULL,
	[wind_speed_mph] [float] NULL,
	[precipitation_in] [time](7) NULL,
	[weather_condition] [nvarchar](70) NULL,
	[amenity] [bit] NULL,
	[bump] [nvarchar](50) NULL,
	[crossing] [bit] NULL,
	[give_way] [nvarchar](50) NULL,
	[junction] [bit] NULL,
	[no_exit] [nvarchar](50) NULL,
	[railway] [bit] NULL,
	[roundabout] [nvarchar](50) NULL,
	[station] [bit] NULL,
	[stop] [bit] NULL,
	[traffic_calming] [nvarchar](50) NULL,
	[traffic_signal] [bit] NULL,
	[turning_loop] [nvarchar](50) NULL,
	[sunrise_sunset] [nvarchar](50) NULL,
	[civil_twilight] [nvarchar](50) NULL,
	[nautical_twilight] [nvarchar](50) NULL,
	[astronomical_twilight] [nvarchar](50) NULL,
	source_system_code INT,
    create_time_stamp DATETIME,
    update_time_stamp DATETIME
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
