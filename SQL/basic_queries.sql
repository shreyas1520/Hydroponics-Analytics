/*
==========================================================
Project : Hydroponics Analytics System
Database: hydroponics_db
Table   : sensor_readings

Objective:
Perform basic SQL analysis on hydroponics sensor data.

Author  : Shreyas Kadam
==========================================================
*/


-- 1. What does the complete dataset look like?
SELECT *
FROM sensor_readings;

--2. Can we quickly inspect the first few records?
SELECT *
FROM sensor_readings
LIMIT 10;

How many observations were collected?

-- Count total sensor readings

SELECT COUNT(*) AS total_records
FROM sensor_readings;

-- Display timestamp, pH and temperature

SELECT
timestamp,
ph,
air_temperature_c,
humidity_pct
FROM sensor_readings;


-- Display unique alert types

SELECT DISTINCT alert
FROM sensor_readings;

-- Highest air temperature

SELECT MAX(air_temperature_c) AS highest_temperature
FROM sensor_readings;


-- Lowest humidity

SELECT MIN(humidity_pct) AS minimum_humidity
FROM sensor_readings;


-- Average TDS

SELECT ROUND(AVG(tds_ppm),2) AS average_tds
FROM sensor_readings;


-- Average air temperature

SELECT ROUND(AVG(air_temperature_c),2) AS average_temperature
FROM sensor_readings;


-- Display all abnormal readings

SELECT
timestamp,
alert
FROM sensor_readings
WHERE alert <> 'Normal';


-- Water pump ON records

SELECT *
FROM sensor_readings
WHERE water_pump='ON';


-- Humidifier ON records

SELECT *
FROM sensor_readings
WHERE humidifier='ON';


-- Exhaust fan ON records

SELECT *
FROM sensor_readings
WHERE exhaust_fan='ON';


-- Temperature greater than 30°C

SELECT *
FROM sensor_readings
WHERE air_temperature_c > 30;


-- Humidity below 60%

SELECT *
FROM sensor_readings
WHERE humidity_pct < 60;


-- Low water level

SELECT *
FROM sensor_readings
WHERE water_level_pct < 50;



-- Highest temperatures first

SELECT
timestamp,
air_temperature_c
FROM sensor_readings
ORDER BY air_temperature_c DESC;


-- Latest records

SELECT *
FROM sensor_readings
ORDER BY timestamp DESC
LIMIT 10;


-- Temperature between 25°C and 30°C

SELECT *
FROM sensor_readings
WHERE air_temperature_c BETWEEN 25 AND 30;