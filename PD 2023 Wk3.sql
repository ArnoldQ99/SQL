/* Create Targets table for import */

CREATE TABLE targets(
online_or_in_person text,
q1 integer,
q2 integer,
q3 integer,
q4 integer
);

SELECT * FROM targets;

/* Output with explanations*/

SELECT								/* Select statement that grabs the relevant fields needed in the query from each dataset*/
	CASE pd.online_or_in_person		/* Case statement to rename the values in the Online or In-person field from the pd2023_wk1 table, Online for the 1 values and In-Person for the 2 values */
	WHEN '1' THEN 'Online'
	WHEN '2' THEN 'In-Person'
	END as type_of_transaction,
	targets.quarter, sum(pd.value) as value, targets.target, sum(pd.value) - targets.target as variance_to_target
FROM(
	SELECT							/* Using a sub-query to pivot specific columns from the targets dataset using unions, to match the data structure of the pd2023_wk1 table, whilst maintaining the header names */
		'1' as quarter, q1 AS target,
		online_or_in_person
	FROM
		targets
	UNION ALL
	SELECT
		'2' as quarter, q2 AS target,
		online_or_in_person
	FROM
		targets
	UNION ALL
	SELECT
		'3' as quarter, q3 AS target,
		online_or_in_person
	FROM
		targets
	UNION ALL
	SELECT
		'4' as quarter, q4 AS target,
		online_or_in_person
	FROM
		targets
) AS targets
JOIN pd2023_wk1 AS pd ON			/* Inner Joining the pd2023_wk1 table on multiple join condition. An alias was assigned to the table as to prevent from wriing the full table name each time it was needed */
(CASE pd.online_or_in_person
	WHEN '1' THEN 'Online'
	WHEN '2' THEN 'In-Person'
	END) = targets.online_or_in_person AND
(to_char(pd.transaction_date, 'Q') = targets.quarter)
WHERE SPLIT_PART(transaction_code,'-',1) = 'DSB'		/* Filtering for transanctions that that contain DSB at the start of the transaction code */
GROUP BY targets.quarter, targets.target,				/* Grouping by fields in the select statement that were not aggregated */
CASE pd.online_or_in_person
	WHEN '1' THEN 'Online'
	WHEN '2' THEN 'In-Person'
	END;

