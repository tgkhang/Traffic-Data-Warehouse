-- Create the DWTraffic database
IF DB_ID('DWTraffic') IS NULL
    CREATE DATABASE DWTraffic;
GO

-- Use the newly created database
USE DWTraffic;
GO

-- Create the NDS schema if not exists
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'NDS')
    EXEC('CREATE SCHEMA NDS');
GO

-- Create the NDS.State table
IF OBJECT_ID('NDS.State', 'U') IS NOT NULL
    DROP TABLE NDS.State;
GO

CREATE TABLE NDS.State (
    state_id INT IDENTITY(1,1) PRIMARY KEY,
    state_code NVARCHAR(10),
    state_name NVARCHAR(100),
    country NVARCHAR(50)
);
GO

-- Insert state data
INSERT INTO NDS.State (state_code, state_name, country) VALUES 
('AB', 'Alberta', 'Canada'),
('AK', 'Alaska', 'USA'),
('AL', 'Alabama', 'USA'),
('AR', 'Arkansas', 'USA'),
('AS', 'American Samoa', 'USA'),
('AZ', 'Arizona', 'USA'),
('BC', 'British Columbia', 'Canada'),
('CA', 'California', 'USA'),
('CO', 'Colorado', 'USA'),
('CT', 'Connecticut', 'USA'),
('DC', 'District of Columbia', 'USA'),
('DE', 'Delaware', 'USA'),
('FL', 'Florida', 'USA'),
('GA', 'Georgia', 'USA'),
('GU', 'Guam', 'USA'),
('HI', 'Hawaii', 'USA'),
('IA', 'Iowa', 'USA'),
('ID', 'Idaho', 'USA'),
('IL', 'Illinois', 'USA'),
('IN', 'Indiana', 'USA'),
('IT', 'Invalid/Unknown', 'Unknown'),
('KS', 'Kansas', 'USA'),
('KY', 'Kentucky', 'USA'),
('LA', 'Louisiana', 'USA'),
('MA', 'Massachusetts', 'USA'),
('MB', 'Manitoba', 'Canada'),
('MD', 'Maryland', 'USA'),
('ME', 'Maine', 'USA'),
('MH', 'Marshall Islands', 'USA'),
('MI', 'Michigan', 'USA'),
('MN', 'Minnesota', 'USA'),
('MO', 'Missouri', 'USA'),
('MS', 'Mississippi', 'USA'),
('MT', 'Montana', 'USA'),
('NB', 'New Brunswick', 'Canada'),
('NC', 'North Carolina', 'USA'),
('ND', 'North Dakota', 'USA'),
('NE', 'Nebraska', 'USA'),
('NF', 'Newfoundland (Obsolete)', 'Canada'),
('NH', 'New Hampshire', 'USA'),
('NJ', 'New Jersey', 'USA'),
('NM', 'New Mexico', 'USA'),
('NS', 'Nova Scotia', 'Canada'),
('NV', 'Nevada', 'USA'),
('NY', 'New York', 'USA'),
('OH', 'Ohio', 'USA'),
('OK', 'Oklahoma', 'USA'),
('ON', 'Ontario', 'Canada'),
('OR', 'Oregon', 'USA'),
('PA', 'Pennsylvania', 'USA'),
('PE', 'Prince Edward Island', 'Canada'),
('PQ', 'Quebec (Old Code)', 'Canada'),
('PR', 'Puerto Rico', 'USA'),
('QC', 'Quebec', 'Canada'),
('RI', 'Rhode Island', 'USA'),
('SC', 'South Carolina', 'USA'),
('SD', 'South Dakota', 'USA'),
('SK', 'Saskatchewan', 'Canada'),
('TN', 'Tennessee', 'USA'),
('TX', 'Texas', 'USA'),
('US', 'Unknown', 'Unknown'),
('UT', 'Utah', 'USA'),
('VA', 'Virginia', 'USA'),
('VI', 'Virgin Islands', 'USA'),
('VT', 'Vermont', 'USA'),
('WA', 'Washington', 'USA'),
('WI', 'Wisconsin', 'USA'),
('WV', 'West Virginia', 'USA'),
('WY', 'Wyoming', 'USA'),
('XX', 'Unknown/Invalid', 'Unknown');
GO