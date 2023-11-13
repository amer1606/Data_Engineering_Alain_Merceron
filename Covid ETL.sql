
-------------------- DATA SOURCING --------------------


DROP SCHEMA IF EXISTS covid;
CREATE SCHEMA covid;


USE covid;
CREATE TABLE cases;
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\cases.csv'
INTO TABLE cases
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n';

CREATE TABLE occup;
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\occup.csv'
INTO TABLE occup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n';

CREATE TABLE avia_paoa_linear;
LOAD DATA INFILE 'C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\avia_paoa_linear.csv'
INTO TABLE occup
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n';

USE covid;

-- Correcting column titles in some instances
ALTER TABLE covid.cases RENAME COLUMN ï»¿country TO country;
ALTER TABLE covid.occup RENAME COLUMN ï»¿country TO country;

ALTER TABLE covid.vaccin_23 RENAME COLUMN ï»¿YearWeekISO TO YearWeek;
ALTER TABLE covid.vaccin_22 RENAME COLUMN ï»¿YearWeekISO TO YearWeek;
ALTER TABLE covid.vaccin_21 RENAME COLUMN ï»¿YearWeekISO TO YearWeek;
ALTER TABLE covid.vaccin_20 RENAME COLUMN ï»¿YearWeekISO TO YearWeek;



-------------------- EXTRACT TRANSFORM LOAD --------------------

-- Extract and transform essential data to have lighter databases on similar dimensions (weekly) --

-- Create "pop" (population) table with unique "country" and "population" data
-- (which will be droppped from all other tables) --

DROP TABLE IF EXISTS pop;
CREATE TABLE pop as
SELECT DISTINCT country, population FROM cases;

-- Create "country_codes" table with "country" and "abbr2" (two-letter abbreviation)
--  to join future tables --

DROP TABLE IF EXISTS country_codes;
CREATE TABLE country_codes (country VARCHAR(255), abbr2 CHAR(2) NOT NULL);
INSERT INTO country_codes (country, abbr2) VALUES
    ('Austria', 'AT'),
    ('Belgium', 'BE'),
    ('Bulgaria', 'BG'),
    ('Croatia', 'HR'),
    ('Cyprus', 'CY'),
    ('Czech Republic', 'CZ'),
    ('Denmark', 'DK'),
    ('Estonia', 'EE'),
    ('Finland', 'FI'),
    ('France', 'FR'),
    ('Germany', 'DE'),
    ('Greece', 'GR'),
    ('Hungary', 'HU'),
    ('Ireland', 'IE'),
    ('Italy', 'IT'),
    ('Latvia', 'LV'),
    ('Lithuania', 'LT'),
    ('Liechtenstein', 'LI'), 
    ('Luxembourg', 'LU'),
    ('Malta', 'MT'),
    ('Netherlands', 'NL'),
    ('Poland', 'PL'),
    ('Portugal', 'PT'),
    ('Romania', 'RO'),
    ('Slovakia', 'SK'),
    ('Slovenia', 'SI'),
    ('Spain', 'ES'),
    ('Sweden', 'SE');
SELECT * FROM country_codes;

-- Create "vaccin_20_red" table aggregating vaccination data (first and second dose only)
-- by week and by country --

DROP TABLE IF EXISTS vaccin_20_temp;
CREATE TABLE vaccin_20_temp AS
SELECT REPLACE(YearWeek, "W", "") AS Year_Week, ReportingCountry,
FirstDose, SecondDose FROM vaccin_20;
DROP TABLE IF EXISTS vaccin_20_temp2;
CREATE TABLE vaccin_20_temp2 AS
SELECT CONCAT(ReportingCountry, " ", Year_Week) AS WeekCountry, FirstDose, SecondDose
FROM vaccin_20_temp;
DROP TABLE IF EXISTS vaccin_20_red;
CREATE TABLE vaccin_20_red AS
SELECT WeekCountry, sum(FirstDose) AS 1stDose, sum(SecondDose) AS 2ndDose
FROM vaccin_20_temp2 GROUP BY WeekCountry ORDER BY WeekCountry ASC;
DROP TABLE vaccin_20_temp;
DROP TABLE vaccin_20_temp2;
SELECT * FROM vaccin_20_red;

-- Create "vaccin_21_red" table aggregating vaccination data (first and second dose only)
-- by week and by country --

DROP TABLE IF EXISTS vaccin_21_temp;
CREATE TABLE vaccin_21_temp AS
SELECT REPLACE(YearWeekISO, "W", "") AS Year_Week, ReportingCountry,
FirstDose, SecondDose FROM vaccin_21;
DROP TABLE IF EXISTS vaccin_21_temp2;
CREATE TABLE vaccin_21_temp2 AS
SELECT CONCAT(ReportingCountry, " ", Year_Week) AS WeekCountry, FirstDose, SecondDose FROM vaccin_21_temp;
DROP TABLE IF EXISTS vaccin_21_red;
CREATE TABLE vaccin_21_red AS
SELECT WeekCountry, sum(FirstDose) AS 1stDose, sum(SecondDose) AS 2ndDose
FROM vaccin_21_temp2 GROUP BY WeekCountry ORDER BY WeekCountry ASC;
DROP TABLE vaccin_21_temp;
DROP TABLE vaccin_21_temp2;
SELECT * FROM vaccin_21_red;

-- Create "vaccin_22_red" table aggregating vaccination data (first and second dose only)
-- by week and by country --

DROP TABLE IF EXISTS vaccin_22_temp;
CREATE TABLE vaccin_22_temp AS
SELECT REPLACE(YearWeek, "W", "") AS Year_Week, ReportingCountry,
FirstDose, SecondDose FROM vaccin_22;
DROP TABLE IF EXISTS vaccin_22_temp2;
CREATE TABLE vaccin_22_temp2 AS
SELECT CONCAT(ReportingCountry, " ", Year_Week) AS WeekCountry, FirstDose, SecondDose FROM vaccin_22_temp;
DROP TABLE IF EXISTS vaccin_22_red;
CREATE TABLE vaccin_22_red AS
SELECT WeekCountry, sum(FirstDose) AS 1stDose, sum(SecondDose) AS 2ndDose
FROM vaccin_22_temp2 GROUP BY WeekCountry ORDER BY WeekCountry ASC;
DROP TABLE vaccin_22_temp;
DROP TABLE vaccin_22_temp2;
SELECT * FROM vaccin_22_red;


-- Create "vaccin_23_red" table aggregating vaccination data (first and second dose only)
-- by week and by country --

DROP TABLE IF EXISTS vaccin_23_temp;
CREATE TABLE vaccin_23_temp AS
SELECT REPLACE(YearWeek, "W", "") AS Year_Week, ReportingCountry,
FirstDose, SecondDose FROM vaccin_23;
DROP TABLE IF EXISTS vaccin_23_temp2;
CREATE TABLE vaccin_23_temp2 AS
SELECT CONCAT(ReportingCountry, " ", Year_Week) AS WeekCountry, FirstDose, SecondDose FROM vaccin_23_temp;
DROP TABLE IF EXISTS vaccin_23_red;
CREATE TABLE vaccin_23_red AS
SELECT WeekCountry, sum(FirstDose) AS 1stDose, sum(SecondDose) AS 2ndDose
FROM vaccin_23_temp2 GROUP BY WeekCountry ORDER BY WeekCountry ASC;
DROP TABLE vaccin_23_temp;
DROP TABLE vaccin_23_temp2;
SELECT * FROM vaccin_23_red;

-- Aggregating Vaccin Data of all 4 years into single database --

DROP TABLE IF EXISTS vaccination;
CREATE TABLE vaccination AS
SELECT WeekCountry, 1stDose, 2ndDose
FROM (
    SELECT WeekCountry, 1stDose, 2ndDose FROM vaccin_20_red
    UNION ALL SELECT WeekCountry, 1stDose, 2ndDose FROM vaccin_21_red
    UNION ALL SELECT WeekCountry, 1stDose, 2ndDose FROM vaccin_22_red
	UNION ALL SELECT WeekCountry, 1stDose, 2ndDose FROM vaccin_23_red)
    AS vaccination ORDER BY WeekCountry ASC;
SELECT * FROM vaccination;

-- Create "deaths" table with "country" and "weekly_count" columns from "cases" (covid monitoring) --
DROP TABLE IF EXISTS deaths;
CREATE TABLE deaths AS
SELECT CONCAT(country, year_week) AS WeekCountry,
country, year_week, weekly_count FROM cases
WHERE indicator = "deaths" ORDER BY country, year_week ASC;
SELECT * FROM deaths;

-- Create "conf_cases" (confirmed cases) table with "country" and "weekly_count" of "cases" in table "cases" (covid monitoring) --
DROP TABLE IF EXISTS conf_cases;
CREATE TABLE conf_cases AS 
SELECT CONCAT(country, year_week) AS WeekCountry,
country, year_week, weekly_count AS case_count FROM cases
WHERE indicator = "cases"
ORDER BY country, year_week ASC;
UPDATE conf_cases
SET case_count = REPLACE(case_count, 'NA', '');
SELECT * FROM conf_cases;

-- Create "hospit" table with "country" and weekly aggregate of "values"
-- from data source "occup" (on "hospital occupancy" indicator) --

DROP TABLE IF EXISTS hospit_temp;
CREATE TABLE hospit_temp AS
SELECT country, indicator, date, REPLACE(year_week, "W","") AS yearWeek, value FROM occup
WHERE indicator = "Daily hospital occupancy";
DROP TABLE IF EXISTS hospit;
CREATE TABLE hospit AS
SELECT CONCAT(country, yearWeek) AS WeekCountry, sum(value) AS beds_week
FROM hospit_temp
GROUP BY WeekCountry
ORDER BY WeekCountry ASC;
DROP TABLE hospit_temp;
SELECT * FROM hospit;

-- Create "icu" table with "country" and weekly aggregate of "values"
-- from data source "occup" (on "Daily ICU occupancy" indicator) --

DROP TABLE IF EXISTS icu_temp;
CREATE TABLE icu_temp AS
SELECT country, indicator, date, REPLACE(year_week, "W","") AS yearWeek, value FROM occup
WHERE indicator = "Daily ICU occupancy";
DROP TABLE IF EXISTS icu;
CREATE TABLE icu AS
SELECT CONCAT(country, yearWeek) AS WeekCountry, sum(value) AS beds_week
FROM icu_temp
GROUP BY WeekCountry
ORDER BY WeekCountry ASC;
DROP TABLE icu_temp;
SELECT * FROM icu;


-- Create "passengers" table with "rep_airp" (airports) transformed into "country_code", TIME_PERIOD" and
-- "OBS_VALUE" as aggregate of airports per country --

DROP TABLE IF EXISTS passengers;
CREATE TABLE passengers AS 
SELECT LEFT(rep_airp, 2) AS country_code, TIME_PERIOD, OBS_VALUE FROM avia_paoa_page_linear
ORDER BY country_code, TIME_PERIOD ASC;
SELECT * FROM passengers;

