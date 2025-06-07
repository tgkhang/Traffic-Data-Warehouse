# Data Warehouse – Data Sources

This project integrates multiple real-world datasets to support smart urban traffic management. It focuses on analyzing weather conditions, traffic violations, and accidents to derive actionable insights for improving city traffic systems.

## Data Sources

### 1. Historical Hourly Weather Data
- **URL:** https://www.kaggle.com/datasets/selfishgene/historical-hourly-weather-data
- **Provider:** Kaggle (uploaded by selfishgene)
- **Description:** Contains hourly weather data for 30 major cities in the USA and Canada. It includes temperature, humidity, wind speed, pressure, and other weather metrics.
- **Usage in project:** Used to correlate weather conditions with traffic accidents and violations.
- **Important fields:**
  - `datetime`
  - `temperature`, `humidity`, `wind_speed`, `pressure`
  - `city`

### 2. Traffic Violations in USA
- **URL:** https://www.kaggle.com/datasets/felix4guti/traffic-violations-in-usa/data
- **Provider:** Kaggle (uploaded by felix4guti)
- **Description:** A dataset of traffic violations across multiple cities in the USA, including violation types, vehicle details, driver demographics, and enforcement details.
- **Usage in project:** Forms a primary source for analyzing violation frequency, risk factors, and vehicle-driver behavior patterns.
- **Important fields:**
  - `date_of_stop`, `time_of_stop`
  - `vehicle_type`, `violation_type`, `location`
  - `alcohol`, `contributed_to_accident`, `driver_race`, `driver_gender`

### 3. US Accidents (2016–2021)
- **URL:** https://www.kaggle.com/datasets/sobhanmoosavi/us-accidents
- **Provider:** Kaggle (uploaded by sobhanmoosavi)
- **Description:** A large-scale dataset of over 2.8 million traffic accidents in the United States, with detailed attributes such as location, time, weather conditions, and severity.
- **Usage in project:** Supports the analysis of accident trends, severity factors, and location-based risks.
- **Important fields:**
  - `start_time`, `end_time`
  - `city`, `state`, `severity`
  - `temperature`, `visibility`, `weather_condition`

