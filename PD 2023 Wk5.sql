WITH CTE AS (
SELECT
SPLIT_PART(transaction_code, '-', 1) as Bank,
TO_CHAR(transaction_date, 'Month') as transaction_date,
SUM(Value) as total_value,
RANK() OVER (
			PARTITION BY TO_CHAR(transaction_date, 'Month')
			ORDER BY sum(value) DESC
		) bank_rank_per_month
FROM pd2023_wk1
GROUP BY TO_CHAR(transaction_date, 'Month'), SPLIT_PART(transaction_code, '-', 1)
),
AVG_RANK AS(
SELECT 
Bank,
AVG(bank_rank_per_month) as avg_rank_per_bank
FROM CTE
GROUP BY Bank
),
AVG_RANK_VALUE AS (
SELECT
bank_rank_per_month,
AVG(total_value) AS avg_value_per_rank
FROM CTE
GROUP BY bank_rank_per_month
	)
SELECT
CTE.*,
avg_rank_per_bank,
avg_value_per_rank
FROM CTE
JOIN AVG_RANK AS AR ON AR.Bank = CTE.Bank
JOIN AVG_RANK_VALUE AS AV ON AV.bank_rank_per_month = CTE.bank_rank_per_month
