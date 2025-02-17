/*
Prepping Data 2024 Week 1
Input the data
Split the Flight Details field to form:
Date 
Flight Number
From
To
Class
Price
Convert the following data fields to the correct data types:
Date to a date format
Price to a decimal value
Change the Flow Card field to Yes / No values instead of 1 / 0
Create two tables, one for Flow Card holders and one for non-Flow Card holders
Output the data sets
*/



CREATE TABLE prep_air(
	flight_details	VARCHAR,
	flow_card	BOOL,
	bags_checked	INT,
	meal_type	TEXT
);

-- First Output
CREATE VIEW	flow_card AS(

WITH initial_clean AS (
	SELECT
		SPLIT_PART(flight_details, '//', 1) AS date,
		SPLIT_PART(flight_details, '//', 2) AS flight_number,
		SPLIT_PART(flight_details, '//', 3) AS from_to,
		SPLIT_PART(flight_details, '//', 4) AS flight_class,
		SPLIT_PART(flight_details, '//', 5) AS price,
		flow_card,
		bags_checked,
		meal_type
	FROM prep_air
	),
second_clean AS(
	SELECT
		date :: date,
		flight_number,
		SPLIT_PART(from_to, '-', 1) AS from,
		SPLIT_PART(from_to, '-', 2) AS to,
		flight_class,
		price :: float,
		CASE
			WHEN flow_card = True THEN 'Yes'
			ELSE 'No'
		END AS flow_card,
		bags_checked,
		meal_type
	FROM initial_clean
)
SELECT 
	*
FROM second_clean
WHERE flow_card = 'Yes'

)


-- Second Output
CREATE VIEW no_flow_card AS(

WITH initial_clean AS (
	SELECT
		SPLIT_PART(flight_details, '//', 1) AS date,
		SPLIT_PART(flight_details, '//', 2) AS flight_number,
		SPLIT_PART(flight_details, '//', 3) AS from_to,
		SPLIT_PART(flight_details, '//', 4) AS flight_class,
		SPLIT_PART(flight_details, '//', 5) AS price,
		flow_card,
		bags_checked,
		meal_type
	FROM prep_air
	),
second_clean AS(
	SELECT
		date :: date,
		flight_number,
		SPLIT_PART(from_to, '-', 1) AS from,
		SPLIT_PART(from_to, '-', 2) AS to,
		flight_class,
		price :: float,
		CASE
			WHEN flow_card = True THEN 'Yes'
			ELSE 'No'
		END AS flow_card,
		bags_checked,
		meal_type
	FROM initial_clean
)
SELECT 
	*
FROM second_clean
WHERE flow_card = 'No'

)
