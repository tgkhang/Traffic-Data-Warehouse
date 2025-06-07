-- Create the database
CREATE DATABASE TrafficViolation;
GO

-- Use the database
USE [TrafficViolation]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Violation](
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
	[id] [int] NULL
) ON [PRIMARY]
GO


