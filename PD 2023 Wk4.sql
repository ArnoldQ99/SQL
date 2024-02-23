/* Creating multiple tables for all 12 months, as the original file was an xlsx with 12 sheets */

CREATE TABLE January(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE February(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE March(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE April(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE May(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE June(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE July(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE August(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE September(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE October(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE November(
id text,
joining_day integer,
demographic text,
value varchar
);

CREATE TABLE December(
id text,
joining_day integer,
demographic text,
value varchar
);

SELECT * FROM january;	/* Check a single month table to determine whether the data has been imported correctly */

CREATE EXTENSION IF NOT EXISTS tablefunc;	/* Create an extension within the database to allow for the use of crosstab */

SELECT DISTINCT(jan.id), CONCAT(joining_day,'/','01','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity	/* Selecting the relavant fields needed to get to the final output, including concatenating a specific field */
FROM CROSSTAB(																												/* Crosstab function to turn the various measure names sitting within the demographic column into their own separate row for their specific id. The values sitting within the value column are used as the values for each new measure name */
	'SELECT id, demographic, value
	FROM january
	ORDER BY 1,2') as jan (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN january ON jan.id = january.id																							/* Joining the table back on itself to retrieve the joining_day field to allow it to be used within the concatenation */
UNION																														/* Unioning each months output to create the large output that includesd all months */
SELECT DISTINCT(feb.id), CONCAT(joining_day,'/','02','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM february
	ORDER BY 1,2') as feb (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN february ON feb.id = february.id
UNION
SELECT DISTINCT(mar.id), CONCAT(joining_day,'/','03','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM march
	ORDER BY 1,2') as mar (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN march ON mar.id = march.id
UNION
SELECT DISTINCT(apr.id), CONCAT(joining_day,'/','04','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM april
	ORDER BY 1,2') as apr (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN april ON apr.id = april.id
UNION
SELECT DISTINCT(may1.id), CONCAT(joining_day,'/','05','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM may
	ORDER BY 1,2') as may1 (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN may ON may1.id = may.id
UNION
SELECT DISTINCT(jun.id), CONCAT(joining_day,'/','06','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM june
	ORDER BY 1,2') as jun (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN june ON jun.id = june.id
UNION
SELECT DISTINCT(jul.id), CONCAT(joining_day,'/','07','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM july
	ORDER BY 1,2') as jul (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN july ON jul.id = july.id
UNION
SELECT DISTINCT(aug.id), CONCAT(joining_day,'/','08','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM august
	ORDER BY 1,2') as aug (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN august ON aug.id = august.id
UNION
SELECT DISTINCT(sep.id), CONCAT(joining_day,'/','09','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM september
	ORDER BY 1,2') as sep (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN september ON sep.id = september.id
UNION
SELECT DISTINCT(oct.id), CONCAT(joining_day,'/','10','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM october
	ORDER BY 1,2') as oct (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN october ON oct.id = october.id
UNION
SELECT DISTINCT(nov.id), CONCAT(joining_day,'/','11','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM november
	ORDER BY 1,2') as nov (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN november ON nov.id = november.id
UNION
SELECT DISTINCT(dec.id), CONCAT(joining_day,'/','12','/','2023') AS Joining_date, account_type, date_of_birth, ethnicity 
FROM CROSSTAB(
	'SELECT id, demographic, value
	FROM december
	ORDER BY 1,2') as dec (id text, account_type varchar, Date_of_Birth varchar, ethnicity varchar)
JOIN december ON dec.id = december.id
ORDER BY id;




