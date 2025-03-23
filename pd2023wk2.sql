/* Create Transactions table for import */

CREATE TABLE pd2023wk2_transactions(
transaction_id varchar,
account_number integer,
sort_code varchar,
bank text
);

/* Create Swift Codes table for import */

CREATE TABLE pd2023wk2_swiftcodes(
bank text,
swift_code text,
check_digits varchar
);

SELECT * FROM pd2023wk2_transactions;
SELECT * FROM pd2023wk2_swiftcodes;

/* Output */

SELECT transaction_id,
'GB'||check_digits||swift_code||replace(sort_code, '-', '')||account_number as IBAN
FROM pd2023wk2_transactions
INNER JOIN pd2023wk2_swiftcodes
ON pd2023wk2_transactions.bank = pd2023wk2_swiftcodes.bank
