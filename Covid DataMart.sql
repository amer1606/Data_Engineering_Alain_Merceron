
----------------- DATA MART ------------------


-- CREATING SYNTHETIC TABLE WITH ALL COVID DATA - WeekCountry = PrimaryKey
DROP TABLE IF EXISTS CovidSynth;
CREATE TABLE CovidSynth AS
SELECT
	conf_cases.WeekCountry,
    conf_cases.case_count,
    hospit.beds_week,
    icu.icu_week,
    deaths.death_count
FROM conf_cases
JOIN hospit ON conf_cases.WeekCountry = hospit.WeekCountry
JOIN icu ON conf_cases.WeekCountry = icu.WeekCountry
JOIN deaths ON conf_cases.WeekCountry = deaths.WeekCountry;
SELECT * FROM CovidSynth;

-- CREATING SYNTHETIC TABLE WITH ALL COVID DATA + VACCINATION
-- WeekCountry = PrimaryKey --
DROP TABLE IF EXISTS CovidBehavior;
CREATE TABLE CovidBehavior AS
SELECT
	conf_cases.WeekCountry,
    conf_cases.case_count,
    hospit.beds_week,
    icu.icu_week,
    deaths.death_count,
    vaccination.FstDose
FROM conf_cases
JOIN hospit ON conf_cases.WeekCountry = hospit.WeekCountry
JOIN icu ON conf_cases.WeekCountry = icu.WeekCountry
JOIN deaths ON conf_cases.WeekCountry = deaths.WeekCountry
JOIN vaccination ON conf_cases.WeekCountry = vaccination.WeekCountry;
SELECT * FROM CovidBehavior;


DROP TABLE IF EXISTS statistics_summary;
CREATE TABLE statistics_summary AS
SELECT
    AVG(case_count) AS average_cases,
    AVG(beds_week) AS average_hosp,
    AVG(icu_week) AS average_icu,
    AVG(death_count) AS average_deaths,
    AVG(FstDose) AS average_vaccin,
    STD(case_count) AS stdev_cases,
    STD(beds_weeks) AS stdev_hosp,
    STD(icu_week) AS stdev_icu,
    STD(death_count) AS stdev_death,
    STD(FstDose) AS stdev_vaccin
FROM CovidBehavior;

DROP TABLE IF EXISTS abc;
CREATE TABLE abc
SELECT LEFT(WeekCountry, LENGTH(WeekCountry - 7)) AS country, RIGHT(WeekCountry, 7) AS Year_Week
FROM CovidSynth;
SELECT * FROM abc;





DROP TABLE IF EXISTS statistics_summary;
CREATE TABLE statistics_summary AS
SELECT CORR(case_count, beds_week) AS correlation_case_hosp
FROM CovidBehavior;

   USING (orderNumber)
WHERE
    orderNumber = 10123;



MIN(case_count) AS min_cases,
    MIN(beds_week) AS min_beds,
    MAX(case_count) AS max_cases,
    MAX(beds_week) AS max_beds
    
    
DELIMITER ;

DROP TRIGGER IF EXISTS update_covid; 

DELIMITER $$

CREATE TRIGGER update_covid
AFTER INSERT
ON orderdetails FOR EACH ROW
BEGIN
	
	-- log the order number of the newley inserted order
    	INSERT INTO messages SELECT CONCAT('new orderNumber: ', NEW.orderNumber);

	-- archive the order and assosiated table entries to product_sales
  	INSERT INTO product_sales
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	WHERE orderNumber = NEW.orderNumber
	ORDER BY 
		orderNumber, 
		orderLineNumber;
        
END $$

DELIMITER ;


SELECT WeekCountry, RIGHT(WeekCountry, 7) AS year_week FROM hospit;
SELECT WeekCountry, LEFT(WeekCountry, LENGTH(WeekCountry)-7) AS country FROM hospit;
SELECT WeekCountry, RIGHT(WeekCountry, 7) AS year_week FROM icu;
SELECT WeekCountry, LEFT(WeekCountry, LENGTH(WeekCountry)-7) AS country FROM icu;