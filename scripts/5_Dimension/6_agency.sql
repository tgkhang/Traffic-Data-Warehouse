
create table Dim.Agency(
    agency_key INT IDENTITY(1,1) PRIMARY KEY,  -- Unique identifier for the agency
    sub_agency_id INT NOT NULL,  -- Foreign key to SubAgency table
    sub_agency_name NVARCHAR(255) NULL,  -- Name of the sub-agency
    agency_id INT NOT NULL,  -- Foreign key to Agency table
    district NVARCHAR(255) NULL,  -- District of the agency
    city_id INT NULL,  -- Foreign key to City table
    agency_name NVARCHAR(255) NULL,  -- Name of the agency
    city_name NVARCHAR(255) NULL,  -- Name of the city where the agency
    county_name NVARCHAR(255) NULL,  -- Name of the county where the agency
    state_code NVARCHAR(50) NULL,  -- State code where the agency is located
    state_name NVARCHAR(255) NULL,  -- Name of the state where the agency is located
    country NVARCHAR(255) NULL  -- Country where the agency is located
)



select 
sa.sub_agency_id, sa.sub_agency_name, a.agency_id, sa.district, sa.city_id, a.agency_name,
c.city_name, co.county_name, s.state_code, s.state_name,s.country
from NDS.SubAgency sa
join NDS.Agency a on sa.agency_id=a.agency_id
join NDS.City c on c.city_id= sa.city_id
join NDS.County co on co.county_id = c.county_id
join NDS.State s on s.state_code= co.state_code