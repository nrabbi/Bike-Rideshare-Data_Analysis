-- cleaning data
WITH new_table AS(
SELECT *,
    DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length,
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM `rideshare-342715.cyclist.2021-combined`
WHERE started_at < ended_at 
AND start_station_name != '')

--finding min, avg and max ride length of paid members
SELECT 
    MIN(ride_length) AS min_ride_length,
    ROUND(AVG(ride_length), 2) AS avg_ride_length, 
    MAX(ride_length) AS max_ride_length
FROM new_table
WHERE member_casual = "member";