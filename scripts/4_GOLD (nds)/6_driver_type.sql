CREATE TABLE NDS.Driver_Type (
    driver_type_id INT IDENTITY(1,1) PRIMARY KEY,  
    race NVARCHAR(100) NULL,            
    gender NVARCHAR(50) NULL,
    driver_state NVARCHAR(50) NULL,
    driver_city NVARCHAR(50) NULL,
    commercial_license BIT NULL         
);
GO


select distinct
    CASE 
        WHEN driver_state IS NULL THEN 'n/a'
        ELSE driver_state
    END AS driver_state, 
    UPPER(LEFT(race, 1)) + LOWER(SUBSTRING(race, 2, LEN(race))) as race,
    commercial_license,
	CASE WHEN UPPER(TRIM(gender)) = 'M' then 'Male'
		WHEN UPPER(TRIM(gender)) = 'F' then 'Female'
		else 'n/a'	
	END gender,
    CASE 
        WHEN driver_city IS NULL THEN 'n/a'
        WHEN LTRIM(RTRIM(driver_city)) IN ('', '.', '00', '000') THEN 'n/a'
        WHEN PATINDEX('%[^a-zA-Z0-9 ]%', driver_city) > 0 THEN 'n/a'
        WHEN ISNUMERIC(driver_city) = 1 THEN 'n/a'
        WHEN PATINDEX('[0-9]%', driver_city) = 1 THEN 'n/a'
        ELSE UPPER(LEFT(driver_city, 1)) + LOWER(SUBSTRING(driver_city, 2, LEN(driver_city)))
    END AS city
from Staging_Violation
where driver_state is null


