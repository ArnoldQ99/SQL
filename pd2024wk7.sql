/*
Requirements

1. Input the data
2. Fix the Relationship Start field so that it has a Date data type
3. Create a field for today's date (14/02/2024)
4. To count the number of Valentine's days, we need to think a little more creatively than using a simple datediff function to count the number of years. 
	A couple of potential routes could be:
		- Scaffolding the data so there is a row per day, filtering to Valentine's days and counting the number of rows
		- A logical calculation that takes into consideration whether the Couple's Relationship Start date is before or after Valentines Day
5. To prepare to join onto the Gift ideas dataset, make the Year field match the data type of the Number of Valentine's field
6. Join the 2 datasets together
7. Remove unnecessary fields
8. Output the data
*/

CREATE TABLE couples(
	couple	TEXT,
	relationship_start	VARCHAR
);

SELECT * FROM couples;

CREATE TABLE gifts(
	year	VARCHAR,
	gift	VARCHAR
);

SELECT * FROM gifts;


-- Challenge Query

ALTER TABLE couples
ALTER COLUMN relationship_start SET DATA TYPE DATE USING (relationship_start :: date);

ALTER TABLE couples
ADD today DATE;

UPDATE couples
SET today = '2024-02-14'

SELECT * FROM couples

UPDATE gifts
SET year = REGEXP_REPLACE(year, '(st|nd|rd|th)', '')

SELECT * FROM gifts;

--

WITH RECURSIVE date_series AS (
	SELECT 
		couple,
		relationship_start :: TIMESTAMP,
		today
	FROM couples

	UNION ALL

	SELECT 
		ds.couple,
		ds.relationship_start + INTERVAL '1 day',
		ds.today
	FROM date_series AS ds
	JOIN couples AS c
	ON ds.couple = c.couple
	WHERE (ds.relationship_start + INTERVAL '1 day') <= ds.today
)
SELECT 
	couple, 
	number_of_valentines,
	gift
FROM (
	SELECT 
		couple,
		count(relationship_start) AS number_of_valentines
	FROM date_series 
	WHERE 
	EXTRACT(MONTH FROM relationship_start) = 2
	AND
	EXTRACT(DAY FROM relationship_start) = 14
	GROUP BY 1
	ORDER BY 1
) AS ds
JOIN gifts AS g
ON g.year :: numeric = ds.number_of_valentines
