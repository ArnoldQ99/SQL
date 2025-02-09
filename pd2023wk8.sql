-- Preppin' Data 2023 Week 08

-- Create a 'file date' (I ended up calling it 'month') using the month found in the file name
--     - The Null value should be replaced as 1
-- Clean the Market Cap value to ensure it is the true value as 'Market Capitalisation'
--     - Remove any rows with 'n/a'
-- Categorise the Purchase Price into groupings
    -- 0 to 24,999.99 as 'Low'
    -- 25,000 to 49,999.99 as 'Medium'
    -- 50,000 to 74,999.99 as 'High'
    -- 75,000 to 100,000 as 'Very High'
-- Categorise the Market Cap into groupings
    -- Below $100M as 'Small'
    -- Between $100M and below $1B as 'Medium'
    -- Between $1B and below $100B as 'Large' 
    -- $100B and above as 'Huge'
-- Rank the highest 5 purchases per combination of: file date, Purchase Price Categorisation and Market Capitalisation Categorisation.
-- Output only records with a rank of 1 to 5

REATE TABLE january(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM january;

CREATE TABLE february(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM february;

CREATE TABLE march(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM march;

CREATE TABLE april(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM april;

CREATE TABLE may(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM may;

CREATE TABLE june(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM june;

CREATE TABLE july(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM july;

CREATE TABLE august(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM august;

CREATE TABLE september(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM september;

CREATE TABLE october(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM october;

CREATE TABLE november(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM november;

CREATE TABLE december(
	id INT,
	first_name TEXT,
	last_name TEXT,
	ticker VARCHAR,
	sector VARCHAR,
	market TEXT,
	stock_name VARCHAR,
	market_cap VARCHAR,
	purchase_price VARCHAR
);

SELECT * FROM december;

-- Challenge

WITH combined_data AS (
	SELECT *, 'January' AS month FROM january
	UNION ALL
	SELECT *, 'February' AS month FROM february
	UNION ALL
	SELECT *, 'March' AS month FROM march
	UNION ALL 
	SELECT *, 'April' AS month FROM april
	UNION ALL
	SELECT *, 'May' AS month FROM may
	UNION ALL
	SELECT *, 'June' AS month FROM june
	UNION ALL
	SELECT *, 'July' AS month FROM july
	UNION ALL
	SELECT *, 'August' AS month FROM july
	UNION ALL
	SELECT *, 'September' AS month FROM september
	UNION ALL
	SELECT *, 'October' AS month FROM october
	UNION ALL
	SELECT *, 'November' AS month FROM november
	UNION ALL
	SELECT *, 'December' AS month FROM december
	),
cleaned_data AS(
	SELECT 
		id,
		first_name,
		last_name,
		ticker,
		sector,
		market,
		stock_name,
		CASE
			WHEN TRIM(market_cap,'$') LIKE '%B%' THEN (TRIM(TRIM(market_cap,'$'),'B') :: FLOAT * 1000000000)
			WHEN TRIM(market_cap,'$') LIKE '%M%' THEN (TRIM(TRIM(market_cap,'$'),'M') :: FLOAT * 1000000)
		END market_cap,
		TRIM(purchase_price,'$') AS purchase_price,
		month
	FROM combined_data
	WHERE market_cap != 'n/a'
	),
groupings AS(
	SELECT 
		*,
		CASE
			WHEN purchase_price :: FLOAT BETWEEN 0 AND 24999.99 THEN 'Low'
			WHEN purchase_price :: FLOAT BETWEEN 25000 AND 49999.99 THEN 'Medium'
			WHEN purchase_price :: FLOAT BETWEEN 50000 AND 74999.99 THEN 'High'
			WHEN purchase_price :: FLOAT BETWEEN 75000 AND 100000 THEN 'Very High'
		END purchase_price_grouping,
		CASE
			WHEN market_cap < 100000000 THEN 'Small'
			WHEN market_cap >= 100000000 OR market_cap < 1000000000 THEN 'Medium'
			WHEN market_cap >= 1000000000 OR market_cap < 100000000000 THEN 'Large'
			WHEN market_cap > 100000000000 THEN 'Huge'
		END market_cap_grouping
	FROM cleaned_data
),
final AS(
	SELECT
		*,
		RANK() OVER(PARTITION BY month, purchase_price_grouping, market_cap_grouping ORDER BY purchase_price :: FLOAT DESC) AS rank
	FROM groupings
	)
SELECT
	market_cap_grouping,
	purchase_price_grouping,
	month,
	ticker,
	sector,
	market,
	stock_name,
	market_cap,
	purchase_price,
	rank
FROM final 
WHERE rank <= 5



