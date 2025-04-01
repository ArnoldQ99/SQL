/*

Requirements

1. Input the data
2. If the customer has cancelled their flight, make sure all rows are filtered out for that flight 
3. For each customer on a flight, filter the dataset to their most recent action
4. Based on the Date field, create a field which shows how many seats in total have been booked as of that date for each flight and class
	Hint: Running Sum could be useful here!
5. Bring in information about the Flight Details
6. Calculate the Capacity %: of the available seats on the flight for each class, what percentage have been booked so far
	For classes which are yet to be booked for a flight, ensure the Capacity % shows as 0% for these rows
	The Date for these rows should be today's date (28/02/2024) 
7. Output the data

*/

CREATE TABLE customer_actions(
	flight_number VARCHAR,
	flight_date VARCHAR,
	customer_id VARCHAR,
	action	TEXT,
	date	VARCHAR,
	class	TEXT,
	row	INT,
	seat	INT
);

ALTER TABLE customer_actions
ALTER COLUMN flight_date TYPE DATE USING flight_date::date;

ALTER TABLE customer_actions
ALTER COLUMN date TYPE DATE USING date::date;

SELECT * FROM customer_actions;

CREATE TABLE flight_details(
	flight_number VARCHAR,
	flight_date	VARCHAR,
	class	TEXT,
	capacity	INT
);

ALTER TABLE flight_details
ALTER COLUMN flight_date TYPE DATE USING flight_date::date;

SELECT * FROM flight_details;

-- Challenge Query

SELECT * 
FROM customer_actions 
WHERE (flight_number, customer_id) IN (
    SELECT flight_number, customer_id
    FROM customer_actions
    WHERE action = 'Cancelled'
);


DELETE FROM customer_actions
WHERE (flight_number, customer_id) IN (
    SELECT flight_number, customer_id
    FROM customer_actions
    WHERE action = 'Cancelled'
);


WITH ranked_actions AS(
	SELECT 
		*,
		RANK() OVER(PARTITION BY customer_id, flight_number ORDER BY date DESC) as rank
	FROM customer_actions
),
run_sum AS(
	SELECT 
		ra.flight_number,
		ra.flight_date,
		ra.class,
		COUNT(seat) OVER(PARTITION BY ra.flight_number,ra.class ORDER BY date) AS total_seats_booked_over_time,
		capacity,
		ra.customer_id,
		action,
		date,
		row,
		seat
	FROM ranked_actions AS ra
	JOIN flight_details AS fd
	ON 
		ra.flight_number = fd.flight_number
		AND
		ra.flight_date = fd.flight_date
		AND
		ra.class = fd.class
	WHERE rank = 1 
)
SELECT
	flight_number,
	flight_date,
	class,
	total_seats_booked_over_time,
	capacity,
	TRIM_SCALE(total_seats_booked_over_time :: numeric / capacity :: numeric) AS capacity_pct,
	customer_id,
	action,
	date,
	row,
	seat
FROM run_sum



