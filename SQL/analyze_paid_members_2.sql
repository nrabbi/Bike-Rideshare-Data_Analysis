-- cleaning data
WITH new_table AS(
SELECT *,
    DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length,
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week
FROM `rideshare-342715.cyclist.2021-combined`
WHERE started_at < ended_at 
AND start_station_name != '')

--finding how many rides were taken on each day of the week by paid members
SELECT 
    CASE
        WHEN day_of_week = 1 THEN 'Sunday'
        WHEN day_of_week = 2 THEN 'Monday'
        WHEN day_of_week = 3 THEN 'Tuesday'
        WHEN day_of_week = 4 THEN 'Wednesday'
        WHEN day_of_week = 5 THEN 'Thursday'
        WHEN day_of_week = 6 THEN 'Friday'
        ELSE 'Saturday' 
    END AS weekday,
    COUNT(day_of_week) AS rides_taken
FROM new_table
WHERE member_casual = "member"
GROUP BY day_of_week
ORDER BY day_of_week;