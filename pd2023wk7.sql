-- Preppin' Data 2023 Week 07

-- For the Transaction Path table:
--     - Make sure field naming convention matches the other tables
--         - i.e. instead of Account_From it should be Account From
-- For the Account Information table:
--     - Make sure there are no null values in the Account Holder ID
--     - Ensure there is one row per Account Holder ID
--         - Joint accounts will have 2 Account Holders, we want a row for each of them
-- For the Account Holders table:
--     - Make sure the phone numbers start with 07
-- Bring the tables together
-- Filter out cancelled transactions 
-- Filter to transactions greater than £1,000 in value 
-- Filter out Platinum accounts

CREATE TABLE acc_holders(
	account_Holder_id INT,
	name	TEXT,
	date_of_birth	DATE,
	contact_number	INT,
	first_line_of_address	VARCHAR
	);

ALTER TABLE acc_holders
ALTER COLUMN date_of_birth TYPE VARCHAR,
ALTER COLUMN contact_number TYPE VARCHAR;
	
CREATE	TABLE acc_info(
	account_number INT,
	account_type TEXT,
	account_holder_id VARCHAR,
	balance_date DATE,
	balance FLOAT
	);

DROP TABLE IF EXISTS trans_detail;
CREATE TABLE trans_detail(
	transaction_id INT,
	transaction_date DATE,
	value FLOAT,
	cancelled BOOL
	);

ALTER TABLE	trans_detail
ALTER COLUMN transaction_id TYPE int8;

CREATE TABLE trans_path(
	transaction_id INT,
	account_to INT,
	account_from INT
	);

ALTER TABLE	trans_path
ALTER COLUMN transaction_id TYPE int8;

SELECT * FROM acc_holders;
SELECT * FROM acc_info;
SELECT * FROM trans_detail;
SELECT * FROM trans_path;

-- Solution

WITH cte AS(
	SELECT
		*
	FROM 
		(
		SELECT
			account_number,
			account_type,
			TRIM(UNNEST(string_to_array(account_holder_id, ','))) :: VARCHAR AS acc_holder_id ,
			balance_date,
			balance
		FROM acc_info
		)
	WHERE
		acc_holder_id IS NOT NULL
		AND
		account_type != 'Platinum'
	),
cte2 AS(
	SELECT
		account_holder_id :: VARCHAR,
		name,
		date_of_birth,
		'0' || contact_number AS contact_number,
		first_line_of_address
	FROM acc_holders
	)
SELECT
	tp.transaction_id,
	tp.account_to,
	td.transaction_date,
	td.value,
	cte.account_number,
	cte.account_type,
	cte.balance_date,
	cte.balance,
	cte2.name,
	cte2.date_of_birth,
	cte2.contact_number,
	cte2.first_line_of_address
FROM trans_detail AS td
JOIN trans_path AS tp
ON tp.transaction_id = td.transaction_id
JOIN cte
ON cte.account_number = tp.account_from
JOIN cte2
ON cte.acc_holder_id = cte2.account_holder_id
WHERE
	cancelled != true
	AND
	td.value > 1000
	




