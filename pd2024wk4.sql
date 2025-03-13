/*
Requirements

1. Input the Excel workbook containing the four worksheets of data
2. Union the Flow Card and Non-Flow card data sets together
3. Create a data field to show whether the seat was booked by someone with the Flow Card or not
	- Call this field 'Flow Card?'
4. Aggregate the Seat Bookings to count how many bookings there are for:
	- Each Seat
	- In each Row
	- In each Class
	- For Flow and Non-Flow Card holders
5. Join on the Seating Plan data to ensure you have a data set for every seat on the plane, even if it hasn't been book
	- Only return the records for the seats that haven't been booked
6. Output the data set showing what seat, rows and class have NOT been booked
*/


CREATE TABLE flow_card(
	Customer_id	VARCHAR,
	seat	INT,
	Row	INT,
	Class	VARCHAR
);

SELECT * FROM flow_card;

CREATE TABLE non_flow_card(
	Customer_id	VARCHAR,
	seat	INT,
	Row	INT,
	Class	VARCHAR
);

CREATE TABLE non_flow_card2(
	Customer_id	VARCHAR,
	seat	INT,
	Row	INT,
	Class	VARCHAR
);

CREATE TABLE seat_plan(
	Class	VARCHAR,
	Seat	INT,
	Row	INT
);


-- Challenge Query

WITH union_data AS(
	SELECT *, 'Yes' AS flow_card FROM flow_card
	UNION ALL
	SELECT *, 'No' AS flow_card FROM non_flow_card
	UNION ALL
	SELECT *, 'No' AS flow_card FROM non_flow_card2
	),
cte AS(
	SELECT
		seat,
		row,
		class,
		flow_card,
		COUNT(customer_id) AS number_of_bookings
	FROM union_data
	GROUP BY 1,2,3,4
)
SELECT 
	sp.class,
	sp.seat,
	sp.row
FROM cte
FULL JOIN seat_plan AS sp
ON 
	cte.class = sp.class
	AND
	cte.seat = sp.seat
	AND
	cte.row = sp.row
WHERE number_of_bookings IS NULL





