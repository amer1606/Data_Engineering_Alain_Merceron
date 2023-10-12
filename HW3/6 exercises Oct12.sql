-- EX1 : Do the same with speed. If speed is NULL or speed < 100 create a “LOW SPEED” category,
-- otherwise, mark as “HIGH SPEED”. 
USE birdstrikes;
SELECT airline, aircraft, speed,
    CASE 
        WHEN speed > 1000
            THEN 'HIGH SPEED'
		ELSE 'LOW SPEED'
    END
AS spCat  
FROM  birdstrikes
ORDER BY spCat;

-- Ex1b Use IF instead of CASE!
USE birdstrikes;
SELECT airline, aircraft, IF(speed > 100,"HIGH SPEED","LOW SPEED")
FROM birdstrikes;


-- EX2 How many distinct ‘aircraft’ we have in the database?
USE birdstrikes;
SELECT COUNT(DISTINCT aircraft) FROM birdstrikes;
-- 3

-- EX3 What was the lowest speed of aircrafts starting with ‘H’
USE birdstrikes;
SELECT DISTINCT aircraft, MIN(speed) FROM birdstrikes WHERE aircraft LIKE 'H%';
--   Helicopter	9


-- EX4 Which phase_of_flight has the least of incidents?
USE birdstrikes;
SELECT phase_of_flight, COUNT(damage) AS damage_count
FROM birdstrikes GROUP BY phase_of_flight ORDER BY damage_count ASC;
-- Taxi 2


-- EX5 What is the rounded highest average cost by phase_of_flight?
USE birdstrikes;
SELECT phase_of_flight, ROUND(AVG(cost)) AS AvCost
FROM birdstrikes GROUP BY phase_of_flight ORDER BY AvCost DESC;
-- Climb 54673


-- EX6 What the highest AVG speed of the states with names less than 5 characters?
USE birdstrikes;
SELECT AVG(speed) AS avSpeed, state FROM birdstrikes GROUP BY state HAVING LENGTH(state)<5;
-- 563.6000	Ohio
-- 300.0000	Utah
-- 469.4444	DC
-- 2862.5000 Iowa

