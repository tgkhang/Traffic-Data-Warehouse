# 📂 Source Files for Traffic Data Warehouse

This folder contains the SQL scripts to create the source tables for the Traffic Data Warehouse. These tables are used to store raw data before it is processed and loaded into the data warehouse. Below is a description of each source file and how to use them:

## 1. `1_weather_src_table.sql` 🌦️

This script creates the `Weather` database and its associated tables:

- 🌬️ `WindSpeed`
- 🧭 `WindDirection`
- 🌤️ `WeatherDescription`
- 🌡️ `Temperature`
- 📉 `Pressure`
- 💧 `Humidity`
- 🏙️ `City`

These tables store weather-related data for various cities. Use this script to reference the data types and structure for weather data. You can insert data manually or use the import feature of Microsoft SQL Server to load data into these tables.

## 2. `2_violation_src_table.sql` 🚦

This script is designed to create tables for storing traffic violation data. It includes fields for violation details, locations, and timestamps. Use this script to understand the schema for traffic violation data. Data can be inserted manually or imported using Microsoft SQL Server's import feature.

## 3. `3_accident_src_table.sql` 🚑

This script creates the `TrafficAccident` database and the `Accident` table. The `Accident` table includes fields for accident details such as location, severity, weather conditions, and other related attributes. Use this script to reference the data types and structure for accident data. Data can be inserted manually or imported using Microsoft SQL Server's import feature.

## 🛠️ How to Use

1. 📝 Execute the SQL scripts in the order provided to create the source tables in your SQL Server instance.
2. 📊 Use the data types and table structures as a reference when preparing your data for import.
3. To load data into the tables, there are 2 ways, you can:
   - 🖊️ Use the `INSERT` or `BULK INSERT` SQL command for manual data entry.
   - 📥 Use the "Import Data" feature in Microsoft SQL Server Management Studio (SSMS) to bulk load data from CSV or other file formats.

These source tables serve as the foundation for building your Traffic Data Warehouse. Ensure the data is clean and consistent before processing it further.
