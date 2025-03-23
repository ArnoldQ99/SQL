CREATE TABLE dsb_customer_ratings(					/* Create the Table to import the csv into */
customer_id text,
MA_ease_of_use integer,
MA_ease_of_access integer,
MA_navigation integer,
MA_likelihood_to_recommend integer,
MA_overall_rating integer,
OI_ease_of_use integer,
OI_ease_of_access integer,
OI_navigation integer,
OI_likelihood_to_recommend integer,
OI_overall_rating integer
);


SELECT preference, (cast(count(t.customer_id) as float)/cast(total_count.total_rows as float))*100 as percent_of_total			/* Query that then gathers together all the information needed to generate the final output for the challenege. */ 
FROM(

	SELECT customer_id,								/* Another subquery that uses the output from the inner query to then create the preferences using a case statement  */ 
	CASE 
		WHEN avg(ma_rating) - avg(oi_rating) >= 2 THEN 'Mobile App Superfan'
		WHEN avg(ma_rating) - avg(oi_rating) >= 1 AND avg(ma_rating) - avg(oi_rating) <= 1.99 THEN 'Mobile App Fan'
		WHEN avg(ma_rating) - avg(oi_rating) <= -1 AND avg(ma_rating) - avg(oi_rating) >= -1.99 THEN 'Online Interface Fan'
		WHEN avg(ma_rating) - avg(oi_rating) <= -2 THEN 'Online Interface Superfan'
		ELSE 'Neutral'
		END preference
	FROM(

			SELECT customer_id, 'Ease of Use' AS score_type, ma_ease_of_use AS ma_rating, oi_ease_of_use AS oi_rating FROM dsb_customer_ratings						/* Using a Union all to transpose the columns into rows with the same title for the different measure names & the same title for all mobile and online values, this is a subquery part of the bigger query */
			UNION ALL
			SELECT customer_id, 'Ease of Access' AS score_type, ma_ease_of_access AS ma_rating, oi_ease_of_access AS oi_rating FROM dsb_customer_ratings
			UNION ALL
			SELECT customer_id, 'Navigation' AS score_type, ma_navigation AS ma_rating, oi_navigation AS oi_rating FROM dsb_customer_ratings
			UNION ALL
			SELECT customer_id, 'Likelihood to recommend' AS score_type, ma_likelihood_to_recommend AS ma_rating, oi_likelihood_to_recommend AS oi_rating FROM dsb_customer_ratings
			ORDER BY customer_id

		)

	GROUP BY customer_id
	
	) as t 
CROSS JOIN (
	SELECT COUNT(*) as total_rows 
	FROM dsb_customer_ratings
	) as total_count
GROUP BY preference, total_count.total_rows
