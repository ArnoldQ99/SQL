/*
Requirements

1. Input the data
2. Aggregate the data so we have a single balance for each day already in the dataset, for each account
3. Scaffold the data so each account has a row between 31st Jan and 14th Feb (hint)
	- Make sure new rows have a null in the Transaction Value field
4. Filter to just this date - 13th Feb
5. Output the data - making it clear which date is being filtered to
*/


CREATE TABLE account_statements(
	account_number INT,
	balance_date	VARCHAR,
	transaction_value	FLOAT,
	balance	FLOAT
);


-- Challenge Query

CREATE TABLE scaff_data(
	date	DATE
);

INSERT INTO scaff_data(date)
SELECT generate_series(
		'2023-01-31':: DATE,
		'2023-02-14':: DATE,
		INTERVAL '1 DAY'
	);

SELECT * FROM scaff_data;

set datestyle = 'dmy';

--

SELECT
	sd.date,
	account_number,
	COALESCE(SUM(transaction_value), 0) AS transaction_value,
	SUM(balance) AS balance
FROM scaff_data AS sd
LEFT JOIN account_statements AS ac
ON sd.date = ac.balance_date :: DATE
WHERE sd.date = '2023-02-01'
GROUP BY 1,2
ORDER BY 1

