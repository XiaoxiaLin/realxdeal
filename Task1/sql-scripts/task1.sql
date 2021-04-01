-- Creating table postings_february

CREATE TABLE postings_february (
uuid VARCHAR(36) PRIMARY KEY,
category VARCHAR(25) NOT NULL,
zip_code VARCHAR(25),
price FLOAT DEFAULT NULL,
area FLOAT DEFAULT NULL,
created_at TIMESTAMP NOT NULL,
status VARCHAR(25) NOT NULL
);


-- Importing the csv file data in the tables created above

LOAD DATA LOCAL INFILE  '/var/lib/mysql-files/postings_february.csv' into table postings_february
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;


-- Question1: average price per square meter per category
-- If we remove the outliers, the avg price will be a littler different

SELECT 'category', 'avg_price_sqt_m2'
UNION ALL
SELECT
    category,
    AVG(nullif(price/area, 0)) AS avg_price_sqt_m2
FROM postings_february
GROUP BY category
INTO OUTFILE '/var/lib/mysql-files/task1_q1.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Question2: number of postings online, per category

SELECT 'category', 'number_of_online_posting'
UNION ALL
SELECT
    category,
    COUNT(*)
FROM postings_february
WHERE status="ONLINE"
GROUP BY category
INTO OUTFILE '/var/lib/mysql-files/task1_q2.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Qustion 3: number of postings created over the first and last day

SELECT 'created_date', 'number_of_postings'
UNION ALL
SELECT
    CAST(created_at AS DATE) AS created_date,
    COUNT(*)
FROM
    postings_february
WHERE
    CAST(created_at AS DATE) IN ("2021-02-01", "2021-02-28")
GROUP BY
    CAST(created_at AS DATE)
INTO OUTFILE '/var/lib/mysql-files/task1_q3.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';



-- Qustion 4: relative difference on postings created daily; do you see any pattern?
SELECT 'created_date', 'number_of_postings', 'previous_day_postings', 'relative_volum_percentage'
UNION ALL
SELECT
    daily_volumn.created_date,
    daily_volumn.number_of_postings,
    yesterday_volumn.previous_day_postings,
    100 * (yesterday_volumn.previous_day_postings - daily_volumn.number_of_postings)/(yesterday_volumn.previous_day_postings) AS relative_volum_percentage
FROM
    (SELECT
        CAST(created_at AS DATE) AS created_date,
        COUNT(*) AS number_of_postings
    FROM
        postings_february
    GROUP BY
        CAST(created_at AS DATE)) daily_volumn
    LEFT JOIN
    (SELECT
        DATE_ADD(CAST(created_at AS DATE), INTERVAL 1 DAY) AS created_date,
        COUNT(*) AS previous_day_postings
    FROM
        postings_february
    GROUP BY
        DATE_ADD(CAST(created_at AS DATE), INTERVAL 1 DAY)) yesterday_volumn
    USING (created_date)
INTO OUTFILE '/var/lib/mysql-files/task1_q4.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';


-- Question 5: a query reporting when an alert system monitoring the postings created daily should have fired
SELECT 'created_date', 'number_of_postings', 'previous_day_postings', 'relative_volum_percentage'
UNION ALL
SELECT
    daily_volumn.created_date,
    daily_volumn.number_of_postings,
    yesterday_volumn.previous_day_postings,
    100 * (daily_volumn.number_of_postings - yesterday_volumn.previous_day_postings)/(yesterday_volumn.previous_day_postings) AS relative_volum_percentage
FROM
    (SELECT
        CAST(created_at AS DATE) AS created_date,
        COUNT(*) AS number_of_postings
    FROM
        postings_february
    GROUP BY
        CAST(created_at AS DATE)) daily_volumn
    LEFT JOIN
    (SELECT
        DATE_ADD(CAST(created_at AS DATE), INTERVAL 1 DAY) AS created_date,
        COUNT(*) AS previous_day_postings
    FROM
        postings_february
    GROUP BY
        DATE_ADD(CAST(created_at AS DATE), INTERVAL 1 DAY)) yesterday_volumn
    USING (created_date)
WHERE 
    100 * (daily_volumn.number_of_postings-yesterday_volumn.previous_day_postings)/(yesterday_volumn.previous_day_postings)<-70
    OR
    100 * (daily_volumn.number_of_postings-yesterday_volumn.previous_day_postings)/(yesterday_volumn.previous_day_postings)>200
INTO OUTFILE '/var/lib/mysql-files/task1_q5.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';
