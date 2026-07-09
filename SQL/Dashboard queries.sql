CREATE TABLE sensor_readings (
    id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP,
    ph NUMERIC,
    tds NUMERIC,
    temperature NUMERIC,
    humidity NUMERIC,
    water_level NUMERIC
);
DROP TABLE sensor_readings;


CREATE TABLE sensor_readings (

    reading_id SERIAL PRIMARY KEY,

    timestamp TIMESTAMP,

    ph DECIMAL(3,2),

    tds_ppm INTEGER,

    air_temperature_c DECIMAL(4,1),

    water_temperature_c DECIMAL(4,1),

    humidity_pct INTEGER,

    water_level_pct INTEGER,

    water_pump VARCHAR(5),

    nutrient_pump VARCHAR(5),

    humidifier VARCHAR(5),

    exhaust_fan VARCHAR(5),

    alert VARCHAR(30)

);

DROP TABLE sensor_readings;


CREATE TABLE sensor_readings (

    timestamp TIMESTAMP,

    ph DECIMAL(3,2),

    tds_ppm INTEGER,

    air_temperature_c DECIMAL(4,1),

    water_temperature_c DECIMAL(4,1),

    humidity_pct INTEGER,

    water_level_pct INTEGER,

    water_pump VARCHAR(5),

    nutrient_pump VARCHAR(5),

    humidifier VARCHAR(5),

    exhaust_fan VARCHAR(5),

    alert VARCHAR(30)

);


ALTER TABLE sensor_readings
ALTER COLUMN alert TYPE VARCHAR(100);


SELECT *
FROM sensor_readings;


SELECT *
FROM sensor_readings
LIMIT 10;


SELECT COUNT(*) AS total_records
FROM sensor_readings;

SELECT
timestamp,
ph,
tds_ppm
FROM sensor_readings;

SELECT MAX(air_temperature_c) AS max_temperature
FROM sensor_readings;



SELECT DATE(timestamp) AS day,
       AVG(ph) AS avg_ph,
       AVG(air_temperature_c) AS avg_temperature
FROM sensor_readings
GROUP BY day
ORDER BY day;



SELECT alert,
       COUNT(*) AS alert_count
FROM sensor_readings
GROUP BY alert
ORDER BY alert_count DESC;


SELECT DATE(timestamp) AS day,
       AVG(air_temperature_c) AS avg_temperature,
       AVG(humidity_pct) AS avg_humidity
FROM sensor_readings
GROUP BY day
ORDER BY day;

SELECT DATE(timestamp) AS day,
       COUNT(*) FILTER (WHERE water_pump = 'ON') AS pump_on_count
FROM sensor_readings
GROUP BY day
ORDER BY day;


SELECT alert,
       COUNT(*) AS alert_count
FROM sensor_readings
GROUP BY alert
ORDER BY alert_count DESC;

--On which day was the hottest recorded temperature?
SELECT DATE(timestamp) AS day,
       MAX(air_temperature_c) AS max_temperature
FROM sensor_readings
GROUP BY day
ORDER BY max_temperature DESC
LIMIT 1;


--On which day did we experience the lowest humidity?
SELECT DATE(timestamp) AS day,
       MIN(humidity_pct) AS min_humidity
FROM sensor_readings
GROUP BY day
ORDER BY min_humidity
LIMIT 1;

--What is the correlation between temperature and humidity?
SELECT CORR(air_temperature_c, humidity_pct) AS temperature_humidity_correlation
FROM sensor_readings;

--How many times was the water pump activated each day, and what was the average temperature on those days?
SELECT DATE(timestamp) AS day,
       COUNT(*) FILTER (WHERE water_pump = 'ON') AS pump_on_count,
       AVG(air_temperature_c) AS avg_temperature
FROM sensor_readings
GROUP BY day
ORDER BY day;

--Which alert type occurred most frequently?
SELECT alert,
       COUNT(*) AS alert_count
FROM sensor_readings
GROUP BY alert
ORDER BY alert_count DESC
LIMIT 1;