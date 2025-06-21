CREATE TABLE NDS.Agency (
    agency_id INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key for agency records
    agency_name NVARCHAR(100) NOT NULL,       -- Name of the agency (e
);
GO


Create table NDS.SubAgency (
    sub_agency_id INT IDENTITY(1,1) PRIMARY KEY,  -- Surrogate key for sub-agency records
    sub_agency_name NVARCHAR(100) NOT NULL,       -- Name of the sub-agency (e.g., 'Baltimore Police Department')
    agency_id INT NOT NULL,                        -- Foreign key to Agency table
    district NVARCHAR(50) NULL,                 -- District or division within the sub-agency
    city_id INT NOT NULL,                        -- Foreign key to City table
);

select distinct agency from 
Bronze.Violation

SELECT DISTINCT
    sub_agency as sub_agency_name,
    LTRIM(RTRIM(
        SUBSTRING(sub_agency, 1, CHARINDEX(',', sub_agency) - 1)
    )) AS district,
    c.city_id, agency_id
FROM Bronze.Violation v
join NDS.City c on c.city_name= v.city
join NDS.Agency a on a.agency_name= v.agency
WHERE sub_agency IS NOT NULL AND CHARINDEX(',', sub_agency) > 0
