-- cleaning data
WITH new_table AS(
SELECT *,
    DATETIME_DIFF(ended_at, started_at, MINUTE) AS ride_length,
    EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
    EXTRACT(MONTH FROM started_at) AS month_of_ride
FROM `rideshare-342715.cyclist.2021-combined`
WHERE started_at < ended_at 
AND start_station_name != '')

--finding how many rides were taken on each month by paid members
SELECT 
    CASE
        WHEN month_of_ride = 1 THEN 'January'
        WHEN month_of_ride = 2 THEN 'February'
        WHEN month_of_ride = 3 THEN 'March'
        WHEN month_of_ride = 4 THEN 'April'
        WHEN month_of_ride = 5 THEN 'May'
        WHEN month_of_ride = 6 THEN 'June'
        WHEN month_of_ride = 7 THEN 'July'
        WHEN month_of_ride = 8 THEN 'August'
        WHEN month_of_ride = 9 THEN 'September'
        WHEN month_of_ride = 10 THEN 'October'
        WHEN month_of_ride = 11 THEN 'November'
        ELSE 'December' 
    END AS Month, 
    COUNT(month_of_ride) AS rides_taken
FROM new_table 
WHERE member_casual = "member"
GROUP BY Month
ORDER BY 
    CASE 
        WHEN Month = "January" THEN 1
        WHEN Month = "February" THEN 2
        WHEN Month = "March" THEN 3
        WHEN Month = "April" THEN 4
        WHEN Month = "May" THEN 5
        WHEN Month = "June" THEN 6
        WHEN Month = "July" THEN 7
        WHEN Month = "August" THEN 8
        WHEN Month = "September" THEN 9
        WHEN Month = "October" THEN 10
        WHEN Month = "November" THEN 11
        WHEN Month = "December" THEN 12
        ELSE NULL
    END; 