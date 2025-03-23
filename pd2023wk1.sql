/* Create the table to import data into */

CREATE TABLE pd2023_wk1 (
transaction_code varchar,
value integer,
customer_code varchar,
Online_or_in_person char,
transaction_date timestamp
);

/* Output 1 */

SELECT SPLIT_PART(transaction_code, '-', 1) as Bank, sum(value) as Value
FROM pd2023_wk1
GROUP BY Bank;

/* Output 2 */

SELECT SPLIT_PART(transaction_code, '-',1) as Bank,
CASE online_or_in_person
	WHEN '1' THEN 'Online'
	WHEN '2' THEN 'In-Person'
	END online_or_in_person,	
to_char(transaction_date, 'Day') as Transaction_Day, sum(value)
FROM pd2023_wk1
GROUP BY Bank, Transaction_Day, online_or_in_person;

/* Output 3 */

SELECT SPLIT_PART(transaction_code, '-', 1) as Bank, customer_code, sum(Value)
FROM pd2023_wk1
GROUP BY Bank, customer_code;
