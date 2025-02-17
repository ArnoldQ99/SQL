-- Preppin' Data 2023 Week 09

-- For the Transaction Path table:
--     Make sure field naming convention matches the other tables
--         - i.e. instead of Account_From it should be Account From
-- Filter out the cancelled transactions
-- Split the flow into incoming and outgoing transactions 
-- Bring the data together with the Balance as of 31st Jan 
-- Work out the order that transactions occur for each account
--     Hint: where multiple transactions happen on the same day, assume the highest value transactions happen first
-- Use a running sum to calculate the Balance for each account on each day 
-- The Transaction Value should be null for 31st Jan, as this is the starting balance
-- Output the data

WITH split_flow AS (
SELECT 
	account_to AS account_id,
	transaction_date,
	balance,
	value
FROM trans_detail AS td
JOIN trans_path AS tp
ON td.transaction_id = tp.transaction_id
JOIN acc_info AS ai
ON ai.account_number = tp.account_to
WHERE 
	cancelled != True 
	AND
	balance_date = '2023-01-31'

UNION ALL

SELECT 
	account_from AS account_id,
	transaction_date,
	balance,
	value * -1 AS value
FROM trans_detail AS td
JOIN trans_path AS tp
ON tp.transaction_id = td.transaction_id
JOIN acc_info AS ai
ON ai.account_number = tp.account_from
WHERE 
	cancelled != True 
	AND
	balance_date = '2023-01-31'

UNION ALL

SELECT
	account_number AS account_id,
	balance_date AS transaction_date,
	COALESCE(NULL,0) AS value,
	balance
FROM acc_info
	)
SELECT 
	account_id AS account_number,
	transaction_date AS balance_date,
	value AS transaction_value,
	SUM(value) OVER(PARTITION BY account_id ORDER BY transaction_date, value DESC) + balance AS balance
FROM split_flow
ORDER BY 1,2,3 DESC	
 	
	





