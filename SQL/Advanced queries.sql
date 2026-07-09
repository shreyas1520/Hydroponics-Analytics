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
Business Question:
Classify air temperature into categories.
*/

SELECT
    timestamp,
    air_temperature_c,
    CASE
        WHEN air_temperature_c < 25 THEN 'Low'
        WHEN air_temperature_c BETWEEN 25 AND 30 THEN 'Normal'
        ELSE 'High'
    END AS temperature_status
FROM sensor_readings;


/*
Business Question:
Assign severity levels to alerts.
*/

SELECT
    timestamp,
    alert,
    CASE
        WHEN alert='Normal' THEN 'Low'
        WHEN alert='High Temperature' THEN 'Medium'
        ELSE 'High'
    END AS severity
FROM sensor_readings;

/*
Business Question:
Find temperatures above average.
*/

WITH avg_temp AS
(
SELECT AVG(air_temperature_c) AS avg_temperature
FROM sensor_readings
)

SELECT
timestamp,
air_temperature_c
FROM sensor_readings, avg_temp
WHERE air_temperature_c>avg_temperature;


/*
Business Question:
Assign serial numbers based on temperature.
*/

SELECT

timestamp,

air_temperature_c,

ROW_NUMBER() OVER
(
ORDER BY air_temperature_c DESC
) AS row_num

FROM sensor_readings;


/*
Business Question:
Rank temperatures from highest to lowest.
*/

SELECT

timestamp,

air_temperature_c,

RANK() OVER
(
ORDER BY air_temperature_c DESC
) AS temperature_rank

FROM sensor_readings;



/*
Business Question:
Assign dense ranking.
*/

SELECT

timestamp,

air_temperature_c,

DENSE_RANK() OVER
(
ORDER BY air_temperature_c DESC
) AS dense_rank

FROM sensor_readings;



/*
Business Question:
Compare with previous reading.
*/

SELECT

timestamp,

air_temperature_c,

LAG(air_temperature_c)
OVER(ORDER BY timestamp)
AS previous_temperature

FROM sensor_readings;




/*
Business Question:
Compare with next reading.
*/

SELECT

timestamp,

air_temperature_c,

LEAD(air_temperature_c)
OVER(ORDER BY timestamp)
AS next_temperature

FROM sensor_readings;



/*
Business Question:
Calculate running average temperature.
*/

SELECT

timestamp,

air_temperature_c,

ROUND(

AVG(air_temperature_c)

OVER(

ORDER BY timestamp

ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW

),2)

AS running_average

FROM sensor_readings;



/*
Business Question:
Track cumulative alerts.
*/

SELECT

timestamp,

alert,

SUM(

CASE

WHEN alert<>'Normal' THEN 1

ELSE 0

END

)

OVER(ORDER BY timestamp)

AS cumulative_alerts

FROM sensor_readings;


/*
Business Question:
Display overall average alongside each record.
*/

SELECT

timestamp,

air_temperature_c,

AVG(air_temperature_c)
OVER()

AS overall_average

FROM sensor_readings;



/*
Business Question:
Average temperature within each alert category.
*/

SELECT

timestamp,

alert,

air_temperature_c,

ROUND(

AVG(air_temperature_c)

OVER(PARTITION BY alert)

,2)

AS avg_temp_alert

FROM sensor_readings;





/*
Business Question:
Show highest recorded temperature.
*/

SELECT

timestamp,

air_temperature_c,

FIRST_VALUE(air_temperature_c)

OVER(

ORDER BY air_temperature_c DESC

)

AS highest_temperature

FROM sensor_readings;



/*
Business Question:
Show latest recorded temperature.
*/

SELECT

timestamp,

air_temperature_c,

LAST_VALUE(air_temperature_c)

OVER(

ORDER BY timestamp

ROWS BETWEEN UNBOUNDED PRECEDING
AND UNBOUNDED FOLLOWING

)

AS latest_temperature

FROM sensor_readings;





/*
Business Question:
Create reusable normal condition view.
*/

CREATE VIEW normal_conditions AS

SELECT *

FROM sensor_readings

WHERE alert='Normal';


SELECT *
FROM normal_conditions;



CREATE VIEW high_temperature AS

SELECT *

FROM sensor_readings

WHERE air_temperature_c>30;

SELECT *
FROM high_temperature;





SELECT *

FROM sensor_readings

ORDER BY air_temperature_c DESC

LIMIT 5;




SELECT

EXTRACT(HOUR FROM timestamp) AS hour,

ROUND(AVG(air_temperature_c),2)

FROM sensor_readings

GROUP BY hour

ORDER BY AVG(air_temperature_c) DESC;






SELECT

DATE(timestamp) AS day,

COUNT(*) FILTER(WHERE alert<>'Normal') AS alerts,

RANK()

OVER(

ORDER BY COUNT(*) FILTER(WHERE alert<>'Normal') DESC

)

AS rank

FROM sensor_readings

GROUP BY DATE(timestamp);





SELECT

DATE(timestamp) AS day,

ROUND(

100.0*

COUNT(*) FILTER(WHERE alert='Normal')

/

COUNT(*)

,2)

AS efficiency

FROM sensor_readings

GROUP BY DATE(timestamp)

ORDER BY efficiency DESC;





