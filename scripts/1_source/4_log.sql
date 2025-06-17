USE TrafficAccident;
GO

-- Drop if exists
IF OBJECT_ID('Accident_ChangeLog', 'U') IS NOT NULL
    DROP TABLE Accident_ChangeLog;
GO

CREATE TABLE Accident_ChangeLog (
    id NVARCHAR(50) NOT NULL,                          -- ID of the affected row in main table
    change_type CHAR(1) NOT NULL,                      -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    change_time DATETIME NOT NULL DEFAULT GETDATE(),   -- When the change occurred
    processed BIT NOT NULL DEFAULT 0                   -- Flag to track ETL progress
);


USE TrafficViolation;
GO

-- Drop if exists
IF OBJECT_ID('Violation_ChangeLog', 'U') IS NOT NULL
    DROP TABLE Violation_ChangeLog;
GO

CREATE TABLE Violation_ChangeLog (
    id INT NOT NULL,                          -- ID of the affected row in main table
    change_type CHAR(1) NOT NULL,             -- 'I' (Insert), 'U' (Update), 'D' (Delete)
    change_time DATETIME NOT NULL DEFAULT GETDATE(), -- When the change occurred
    processed BIT NOT NULL DEFAULT 0          -- Flag to track ETL progress
);
