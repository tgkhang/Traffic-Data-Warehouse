CREATE TABLE NDS.Driver_Type (
    driver_type_id INT IDENTITY(1,1) PRIMARY KEY,  
    race NVARCHAR(100) NULL,            
    gender NVARCHAR(50) NULL,
    driver_state NVARCHAR(50) NULL,
    driver_city_id NVARCHAR(50) NULL,
    commercial_license BIT NULL         
);
GO


SELECT DISTINCT
    CASE 
        WHEN driver_state IS NULL THEN 'n/a'
        ELSE driver_state
    END AS driver_state, 

    race,
    commercial_license,
    CASE 
        WHEN UPPER(TRIM(gender)) = 'M' THEN 'Male'
        WHEN UPPER(TRIM(gender)) = 'F' THEN 'Female'
        ELSE 'n/a'
    END AS gender,
    c.city_id
FROM Bronze.Violation v
join NDS.City c on c.city_name= v.driver_city

