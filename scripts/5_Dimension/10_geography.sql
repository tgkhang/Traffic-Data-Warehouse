CREATE TABLE Dim.Geography (
    geography_key INT IDENTITY(1,1) PRIMARY KEY,
    
    city_name NVARCHAR(255) NULL,
    county_name NVARCHAR(50) NULL,

    state_code NVARCHAR(10) NULL,
    state_name NVARCHAR(100) NULL,
    country NVARCHAR(50) NULL,
    longitude FLOAT NULL,
    latitude FLOAT NULL
);


