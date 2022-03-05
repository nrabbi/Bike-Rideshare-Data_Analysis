-- cleaning data
WITH new_table AS(
SELECT *,
    DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length,
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
    EXTRACT(MONTH FROM started_at) AS month_of_ride
FROM `rideshare-342715.cyclist.2021-combined`
WHERE started_at < ended_at 
AND start_station_name != '')

-- find the different types of bikes used by casual and paid members
SELECT member_casual, rideable_type, COUNT(*) AS amount
FROM new_table
GROUP BY member_casual, rideable_type
ORDER BY member_casual;