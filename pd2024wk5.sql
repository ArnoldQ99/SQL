/*
Requirements

1. Input the data
2. For the first output:
	Create a dataset that gives all the customer details for booked flights in 2024. Make sure the output also includes details on the flights origin and destination
	When outputting the data, create an excel file with a new sheet for each output (so 1 file for all outputs this week!)
3. For the second output:	
	Create a dataset that allows Prep Air to identify which flights have not yet been booked in 2024
	Add a datestamp field to this dataset for today's date (31/01/2024) so that Prep Air know the unbooked flights as of the day the workflow is run
	When outputting the table to a new sheet in the Excel Workbook, choose the option "Append to Table" under Write Options. This means that if the workflow is run on a different day, the results will add additional rows to the dataset, rather than overwriting the previous run's data
4. For the third output:
	Create a dataset that shows which customers have yet to book a flight with Prep Air in 2024
	Create a field which will allow Prep Air to see how many days it has been since the customer last flew (compared to 31/01/2024)
	Categorise customers into the following groups:
		Recent fliers - flown within the last 3 months
		Taking a break - 3-6 months since last flight
		Been away a while - 6-9 months since last flight
		Lapsed Customers - over 9 months since last flight
	Output the data to a new sheet in the Excel Workbook
*/

CREATE TABLE prep_air_2024_flights(
	date	DATE,
	flight_number	VARCHAR,
	flight_from	TEXT,
	flight_to	TEXT
);

SELECT * FROM prep_air_2024_flights;

CREATE TABLE prep_air_customers(
	customer_id	INT,
	last_date_flown	DATE,
	first_name	TEXT,
	last_name	TEXT,
	email	VARCHAR,
	gender	TEXT
);

SELECT * FROM prep_air_customers;

CREATE TABLE prep_air_ticket_sales(
	date	DATE,
	flight_number	VARCHAR,
	customer_id	INT,
	ticket_price	FLOAT
);

SELECT * FROM prep_air_ticket_sales


-- 1st Output

SELECT 
	ts.date,
	f.flight_from,
	f.flight_to,
	f.flight_number,
	ts.customer_id,
	c.last_date_flown,
	c.first_name,
	c.last_name,
	c.email,
	c.gender,
	ts.ticket_price
FROM prep_air_ticket_sales AS ts
JOIN prep_air_2024_flights AS f
ON 
	f.date = ts.date
	AND
	f.flight_number = ts.flight_number
JOIN prep_air_customers AS c
ON c.customer_id = ts.customer_id


-- 2nd Output

SELECT 
	'31/01/2024' AS flights_unbooked_as_of,
	f.date,
	f.flight_number,
	f.flight_from,
	f.flight_to
FROM prep_air_2024_flights AS f
FULL JOIN prep_air_ticket_sales AS ts
ON 
	f.date = ts.date
	AND
	f.flight_number = ts.flight_number
WHERE customer_id iS NULL

-- 3rd Output

SET datestyle = dmy;

SELECT
	c.customer_id,
	('31/01/2024' :: DATE) - c.last_date_flown AS days_since_last_flown,
	CASE
		WHEN (('31/01/2024' :: DATE) - c.last_date_flown) < 90 THEN 'Recent fliers - flown within the last 3 months'
		WHEN (('31/01/2024' :: DATE) - c.last_date_flown) BETWEEN 90 AND 180 THEN 'Taking a break - 3-6 months since last flight'
		WHEN (('31/01/2024' :: DATE) - c.last_date_flown) BETWEEN 180 AND 270 THEN 'Been away a while - 6-9 months since last flight'
		ELSE 'Lapsed Customers - over 9 months since last flight'
	END AS customer_category,
	c.last_date_flown,
	c.first_name,
	c.last_name,
	c.email,
	c.gender
FROM prep_air_2024_flights AS f
JOIN prep_air_ticket_sales AS ts
ON 
	ts.date = f.date
	AND
	ts.flight_number = f.flight_number
RIGHT JOIN prep_air_customers AS c
ON c.customer_id = ts.customer_id
WHERE ts.customer_id IS NULL




