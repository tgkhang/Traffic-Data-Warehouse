--main change is to add source_system_code, create_time_stamp, and update_time_stamp columns to all staging tables

create database StagingDB

go 

use StagingDB
go

CREATE TABLE dbo.Staging_City (
    city NVARCHAR(100),
    country NVARCHAR(100),
    latitude FLOAT,
    longitude FLOAT,
    source_system_code INT,
    create_time_stamp DATETIME,
    update_time_stamp DATETIME
);

go

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Staging_Humidity](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [float] NULL,
	[Portland] [float] NULL,
	[San_Francisco] [float] NULL,
	[Seattle] [float] NULL,
	[Los_Angeles] [float] NULL,
	[San_Diego] [float] NULL,
	[Las_Vegas] [float] NULL,
	[Phoenix] [float] NULL,
	[Albuquerque] [float] NULL,
	[Denver] [float] NULL,
	[San_Antonio] [float] NULL,
	[Dallas] [float] NULL,
	[Houston] [float] NULL,
	[Kansas_City] [float] NULL,
	[Minneapolis] [float] NULL,
	[Saint_Louis] [float] NULL,
	[Chicago] [float] NULL,
	[Nashville] [float] NULL,
	[Indianapolis] [float] NULL,
	[Atlanta] [float] NULL,
	[Detroit] [float] NULL,
	[Jacksonville] [float] NULL,
	[Charlotte] [float] NULL,
	[Miami] [float] NULL,
	[Pittsburgh] [float] NULL,
	[Toronto] [float] NULL,
	[Philadelphia] [float] NULL,
	[New_York] [float] NULL,
	[Montreal] [float] NULL,
	[Boston] [float] NULL,
	[Beersheba] [float] NULL,
	[Tel_Aviv_District] [float] NULL,
	[Eilat] [float] NULL,
	[Haifa] [float] NULL,
	[Nahariyya] [float] NULL,
	[Jerusalem] [float] NULL,
	  -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Staging_Pressure](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [smallint] NULL,
	[Portland] [smallint] NULL,
	[San_Francisco] [smallint] NULL,
	[Seattle] [smallint] NULL,
	[Los_Angeles] [smallint] NULL,
	[San_Diego] [smallint] NULL,
	[Las_Vegas] [smallint] NULL,
	[Phoenix] [smallint] NULL,
	[Albuquerque] [smallint] NULL,
	[Denver] [smallint] NULL,
	[San_Antonio] [smallint] NULL,
	[Dallas] [smallint] NULL,
	[Houston] [smallint] NULL,
	[Kansas_City] [smallint] NULL,
	[Minneapolis] [smallint] NULL,
	[Saint_Louis] [smallint] NULL,
	[Chicago] [smallint] NULL,
	[Nashville] [smallint] NULL,
	[Indianapolis] [smallint] NULL,
	[Atlanta] [smallint] NULL,
	[Detroit] [smallint] NULL,
	[Jacksonville] [smallint] NULL,
	[Charlotte] [smallint] NULL,
	[Miami] [smallint] NULL,
	[Pittsburgh] [smallint] NULL,
	[Toronto] [smallint] NULL,
	[Philadelphia] [smallint] NULL,
	[New_York] [smallint] NULL,
	[Montreal] [smallint] NULL,
	[Boston] [smallint] NULL,
	[Beersheba] [smallint] NULL,
	[Tel_Aviv_District] [smallint] NULL,
	[Eilat] [smallint] NULL,
	[Haifa] [smallint] NULL,
	[Nahariyya] [smallint] NULL,
	[Jerusalem] [smallint] NULL,
		  -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Staging_Temperature](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [float] NULL,
	[Portland] [float] NULL,
	[San_Francisco] [float] NULL,
	[Seattle] [float] NULL,
	[Los_Angeles] [float] NULL,
	[San_Diego] [float] NULL,
	[Las_Vegas] [float] NULL,
	[Phoenix] [float] NULL,
	[Albuquerque] [float] NULL,
	[Denver] [float] NULL,
	[San_Antonio] [float] NULL,
	[Dallas] [float] NULL,
	[Houston] [float] NULL,
	[Kansas_City] [float] NULL,
	[Minneapolis] [float] NULL,
	[Saint_Louis] [float] NULL,
	[Chicago] [float] NULL,
	[Nashville] [float] NULL,
	[Indianapolis] [float] NULL,
	[Atlanta] [float] NULL,
	[Detroit] [float] NULL,
	[Jacksonville] [float] NULL,
	[Charlotte] [float] NULL,
	[Miami] [float] NULL,
	[Pittsburgh] [float] NULL,
	[Toronto] [float] NULL,
	[Philadelphia] [float] NULL,
	[New_York] [float] NULL,
	[Montreal] [float] NULL,
	[Boston] [float] NULL,
	[Beersheba] [float] NULL,
	[Tel_Aviv_District] [float] NULL,
	[Eilat] [float] NULL,
	[Haifa] [float] NULL,
	[Nahariyya] [float] NULL,
	[Jerusalem] [float] NULL,
	 -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO



CREATE TABLE [dbo].[Staging_Wind_Direction](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [float] NULL,
	[Portland] [float] NULL,
	[San_Francisco] [float] NULL,
	[Seattle] [float] NULL,
	[Los_Angeles] [float] NULL,
	[San_Diego] [float] NULL,
	[Las_Vegas] [float] NULL,
	[Phoenix] [float] NULL,
	[Albuquerque] [float] NULL,
	[Denver] [float] NULL,
	[San_Antonio] [float] NULL,
	[Dallas] [float] NULL,
	[Houston] [float] NULL,
	[Kansas_City] [float] NULL,
	[Minneapolis] [float] NULL,
	[Saint_Louis] [float] NULL,
	[Chicago] [float] NULL,
	[Nashville] [float] NULL,
	[Indianapolis] [float] NULL,
	[Atlanta] [float] NULL,
	[Detroit] [float] NULL,
	[Jacksonville] [float] NULL,
	[Charlotte] [float] NULL,
	[Miami] [float] NULL,
	[Pittsburgh] [float] NULL,
	[Toronto] [float] NULL,
	[Philadelphia] [float] NULL,
	[New_York] [float] NULL,
	[Montreal] [float] NULL,
	[Boston] [float] NULL,
	[Beersheba] [float] NULL,
	[Tel_Aviv_District] [float] NULL,
	[Eilat] [float] NULL,
	[Haifa] [float] NULL,
	[Nahariyya] [float] NULL,
	[Jerusalem] [float] NULL,
		 -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO


CREATE TABLE [dbo].[Staging_Wind_Speed](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [float] NULL,
	[Portland] [float] NULL,
	[San_Francisco] [float] NULL,
	[Seattle] [float] NULL,
	[Los_Angeles] [float] NULL,
	[San_Diego] [float] NULL,
	[Las_Vegas] [float] NULL,
	[Phoenix] [float] NULL,
	[Albuquerque] [float] NULL,
	[Denver] [float] NULL,
	[San_Antonio] [float] NULL,
	[Dallas] [float] NULL,
	[Houston] [float] NULL,
	[Kansas_City] [float] NULL,
	[Minneapolis] [float] NULL,
	[Saint_Louis] [float] NULL,
	[Chicago] [float] NULL,
	[Nashville] [float] NULL,
	[Indianapolis] [float] NULL,
	[Atlanta] [float] NULL,
	[Detroit] [float] NULL,
	[Jacksonville] [float] NULL,
	[Charlotte] [float] NULL,
	[Miami] [float] NULL,
	[Pittsburgh] [float] NULL,
	[Toronto] [float] NULL,
	[Philadelphia] [float] NULL,
	[New_York] [float] NULL,
	[Montreal] [float] NULL,
	[Boston] [float] NULL,
	[Beersheba] [float] NULL,
	[Tel_Aviv_District] [float] NULL,
	[Eilat] [float] NULL,
	[Haifa] [float] NULL,
	[Nahariyya] [float] NULL,
	[Jerusalem] [float] NULL,
		 -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[Staging_Weather_Description](
	[datetime] [datetime2](7) NOT NULL,
	[Vancouver] [nvarchar](50) NULL,
	[Portland] [nvarchar](50) NULL,
	[San_Francisco] [nvarchar](50) NULL,
	[Seattle] [nvarchar](50) NULL,
	[Los_Angeles] [nvarchar](50) NULL,
	[San_Diego] [nvarchar](50) NULL,
	[Las_Vegas] [nvarchar](50) NULL,
	[Phoenix] [nvarchar](50) NULL,
	[Albuquerque] [nvarchar](50) NULL,
	[Denver] [nvarchar](50) NULL,
	[San_Antonio] [nvarchar](50) NULL,
	[Dallas] [nvarchar](50) NULL,
	[Houston] [nvarchar](50) NULL,
	[Kansas_City] [nvarchar](50) NULL,
	[Minneapolis] [nvarchar](50) NULL,
	[Saint_Louis] [nvarchar](50) NULL,
	[Chicago] [nvarchar](50) NULL,
	[Nashville] [nvarchar](50) NULL,
	[Indianapolis] [nvarchar](50) NULL,
	[Atlanta] [nvarchar](50) NULL,
	[Detroit] [nvarchar](50) NULL,
	[Jacksonville] [nvarchar](50) NULL,
	[Charlotte] [nvarchar](50) NULL,
	[Miami] [nvarchar](50) NULL,
	[Pittsburgh] [nvarchar](50) NULL,
	[Toronto] [nvarchar](50) NULL,
	[Philadelphia] [nvarchar](50) NULL,
	[New_York] [nvarchar](50) NULL,
	[Montreal] [nvarchar](50) NULL,
	[Boston] [nvarchar](50) NULL,
	[Beersheba] [nvarchar](50) NULL,
	[Tel_Aviv_District] [nvarchar](50) NULL,
	[Eilat] [nvarchar](50) NULL,
	[Haifa] [nvarchar](50) NULL,
	[Nahariyya] [nvarchar](50) NULL,
	[Jerusalem] [nvarchar](50) NULL,
		 -- Metadata columns
    [source_system_code] INT NULL,
    [create_time_stamp] DATETIME NULL,
    [update_time_stamp] DATETIME NULL
) ON [PRIMARY]
GO
