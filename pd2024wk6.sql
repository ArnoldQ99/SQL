/*
1. Input the csv file
2. Add a row number to the data set
3. Find the latest row (largest row number) to capture the individuals correct salary information
4. Find each team member's annual salary
5. Find each team member's maximum tax band based on their annual salary
	- 20% rate
	- 40% rate
	- 45% rate 
6. Work out how much tax an individual paid for each of the % bands. Call these fields:
	- 20% tax rate paid
	- 40% tax rate paid
	- 45% tax rate paid
7. Total the tax paid across all three % bands. Call this field 'Total Tax Paid' 
8. Output the data
*/

CREATE TABLE salaries(
	staff_id INT,
	col_1 FLOAT,
	col_2 FLOAT,
	col_3 FLOAT,
	col_4 FLOAT,
	col_5 FLOAT,
	col_6 FLOAT,
	col_7 FLOAT,
	col_8 FLOAT,
	col_9 FLOAT,
	col_10 FLOAT,
	col_11 FLOAT,
	col_12 FLOAT
);

-- Challenge Query

WITH annual_salary AS(
	SELECT 
		staff_id,
		SUM(salary) AS salary
	FROM(	
		SELECT
			staff_id,
			unnest(array[col_1, col_2, col_3, col_4, col_5, col_6, col_7, col_8, col_9, col_10, col_11, col_12]) AS salary
		FROM salaries )
	GROUP BY 1
),
max_tax_band AS(
	SELECT 
		*,
		CASE
			WHEN salary BETWEEN 12571 AND 50270 THEN '20% rate'
			WHEN salary BETWEEN 50271 AND 125140 THEN '40% rate'
			ELSE '45% rate'
		END AS max_tax_rate
	FROM annual_salary
),
tax_calcs AS(
	SELECT
		*, 
		CASE
			WHEN max_tax_rate = '20% rate' THEN (salary-12570) * 0.2
			ELSE ROUND((50270 - 12570) * 0.2, 0)
		END AS rate_tax_paid_20_percent,
		CASE
			WHEN max_tax_rate = '40% rate' THEN (salary - 50270) * 0.4
			WHEN max_tax_rate = '45% rate' THEN ROUND((125140 - 50270)*0.4,0)
			ELSE 0
		END AS rate_tax_paid_40_percent,
		CASE
			WHEN max_tax_rate = '45% rate' THEN (salary - 125140) * 0.45
			ELSE 0
		END AS rate_tax_paid_45_percent
	FROM max_tax_band
)
SELECT 
	staff_id,
	salary,
	max_tax_rate,
	(rate_tax_paid_20_percent + rate_tax_paid_40_percent + rate_tax_paid_45_percent) AS total_tax_paid,
	rate_tax_paid_20_percent,
	rate_tax_paid_40_percent,
	rate_tax_paid_45_percent
FROM tax_calcs

