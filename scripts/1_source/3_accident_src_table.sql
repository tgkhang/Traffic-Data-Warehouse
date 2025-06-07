Create database TrafficAccident
go

USE [TrafficAccident]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Accident](
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
	[astronomical_twilight] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO