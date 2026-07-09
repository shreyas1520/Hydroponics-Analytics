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

/*
Question:
Which day was the most stable?

Insight:
The day with the fewest alerts indicates the most stable hydroponic conditions.
*/

SELECT
    DATE(timestamp) AS day,
    COUNT(*) FILTER (WHERE alert <> 'Normal') AS total_alerts
FROM sensor_readings
GROUP BY DATE(timestamp)
ORDER BY total_alerts ASC
LIMIT 1;

/*
Business Question:
Which day experienced the highest number of alerts?
*/

SELECT
    DATE(timestamp) AS day,
    COUNT(*) FILTER (WHERE alert <> 'Normal') AS total_alerts
FROM sensor_readings
GROUP BY DATE(timestamp)
ORDER BY total_alerts DESC
LIMIT 1;



/*
Business Question:
During which hour is the average temperature highest?
*/

SELECT
    EXTRACT(HOUR FROM timestamp) AS hour,
    ROUND(AVG(air_temperature_c),2) AS avg_temperature
FROM sensor_readings
GROUP BY hour
ORDER BY avg_temperature DESC;



/*
Business Question:
Does higher temperature reduce humidity?
*/

SELECT
    ROUND(CORR(air_temperature_c, humidity_pct),2) AS correlation
FROM sensor_readings;



/*
Business Question:
How many alerts occurred when the water pump was ON vs OFF?
*/

SELECT
    water_pump,
    COUNT(*) FILTER (WHERE alert <> 'Normal') AS alert_count
FROM sensor_readings
GROUP BY water_pump;



/*
Business Question:
What is the average pH when the system is operating normally?
*/

SELECT
    ROUND(AVG(ph),2) AS average_ph
FROM sensor_readings
WHERE alert='Normal';


/*
Business Question:
How does TDS behave during abnormal conditions?
*/

SELECT
    ROUND(AVG(tds_ppm),2) AS average_tds
FROM sensor_readings
WHERE alert<>'Normal';


/*
Business Question:
Which day had the best operating conditions?
*/

SELECT
    DATE(timestamp) AS day,
    ROUND(AVG(ph),2) AS avg_ph,
    ROUND(AVG(air_temperature_c),2) AS avg_temp,
    COUNT(*) FILTER (WHERE alert<>'Normal') AS alerts
FROM sensor_readings
GROUP BY DATE(timestamp)
ORDER BY alerts ASC, avg_temp ASC;



/*
Business Question:
Which day had the poorest operating conditions?
*/

SELECT
    DATE(timestamp) AS day,
    ROUND(AVG(ph),2) AS avg_ph,
    ROUND(AVG(air_temperature_c),2) AS avg_temp,
    COUNT(*) FILTER (WHERE alert<>'Normal') AS alerts
FROM sensor_readings
GROUP BY DATE(timestamp)
ORDER BY alerts DESC, avg_temp DESC;



/*
Business Question:
Calculate a stability score for each day.
*/

SELECT
    DATE(timestamp) AS day,
    ROUND(
        AVG(
            CASE
                WHEN alert='Normal' THEN 1
                ELSE 0
            END
        )*100,2
    ) AS stability_score
FROM sensor_readings
GROUP BY DATE(timestamp)
ORDER BY stability_score DESC;


/*
Business Question:
Which actuator was activated most frequently?
*/

SELECT 'Water Pump' AS actuator, COUNT(*) AS activations
FROM sensor_readings
WHERE water_pump='ON'

UNION ALL

SELECT 'Nutrient Pump', COUNT(*)
FROM sensor_readings
WHERE nutrient_pump='ON'

UNION ALL

SELECT 'Humidifier', COUNT(*)
FROM sensor_readings
WHERE humidifier='ON'

UNION ALL

SELECT 'Exhaust Fan', COUNT(*)
FROM sensor_readings
WHERE exhaust_fan='ON'

ORDER BY activations DESC;


/*
Business Question:
Which environmental parameter exceeded its threshold most often?
*/

SELECT
'High Temperature' AS Parameter,
COUNT(*)
FROM sensor_readings
WHERE air_temperature_c>30

UNION ALL

SELECT
'Low Humidity',
COUNT(*)
FROM sensor_readings
WHERE humidity_pct<60

UNION ALL

SELECT
'Low Water Level',
COUNT(*)
FROM sensor_readings
WHERE water_level_pct<50;



/*
Business Question:
What are the average sensor values during normal operation?
*/

SELECT
ROUND(AVG(ph),2) AS avg_ph,
ROUND(AVG(tds_ppm),2) AS avg_tds,
ROUND(AVG(air_temperature_c),2) AS avg_air_temp,
ROUND(AVG(water_temperature_c),2) AS avg_water_temp,
ROUND(AVG(humidity_pct),2) AS avg_humidity,
ROUND(AVG(water_level_pct),2) AS avg_water_level
FROM sensor_readings
WHERE alert='Normal';



/*
Business Question:
What percentage of readings were normal?
*/

SELECT
ROUND(
100.0*
COUNT(*) FILTER(WHERE alert='Normal')
/
COUNT(*)
,2) AS system_efficiency
FROM sensor_readings;



SELECT
    alert,
    ROUND(AVG(air_temperature_c),2) AS avg_temperature,
    ROUND(AVG(humidity_pct),2) AS avg_humidity,
    ROUND(AVG(ph),2) AS avg_ph,
    ROUND(AVG(tds_ppm),2) AS avg_tds
FROM sensor_readings
GROUP BY alert
ORDER BY alert;

