
create table Dim.Driver_Type(
    driver_type_key INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the driver type
    driver_type_id INT NOT NULL,  -- Foreign key to Driver_Type table
    driver_race NVARCHAR(255) NULL,  --
    gender NVARCHAR(50) NULL,
    driver_state NVARCHAR(50) NULL,  -- State where the driver is registered
    commercial_license BIT NULL,  -- Indicates if the driver has a commercial license
    driver_city_id INT NULL,  -- Foreign key to City table
    driver_city_name NVARCHAR(255) NULL,  -- Name of the city where the driver is registered
    county_id INT NULL,  -- Foreign key to County table
    county_name NVARCHAR(255) NULL,  -- Name of the county where the driver
    state_name NVARCHAR(255) NULL,  -- Name of the state where the driver is registered 
    country NVARCHAR(255) NULL,  -- Country where the driver is registered
)


select TOP 10 
dt.*, c.city_name, co.county_id, co.county_name, c.city_id,s.state_name, s.country
from NDS.Driver_Type dt
join NDS.City c on c.city_id= dt.driver_city_id
join NDS.County co on co.county_id = c.county_id
join NDS.State s on s.state_code=dt.driver_state