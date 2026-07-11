-- Google Play Store: App Market Analysis

USE GoogleApps;


-- Q1: Which categories have the highest average rating?

SELECT c.category_name as category, AVG (a.rating) as avg_rating, STDDEV(a.rating) as rating_stddev
FROM apps AS a
INNER JOIN categories AS c
ON a.category_id = c.category_id
GROUP BY category
ORDER BY avg_rating DESC;


-- Q2: Do paid apps have higher average sentiment than free apps?

SELECT a.type, AVG (r.sentiment_polarity) as sent_pol 
FROM apps AS a
INNER JOIN reviews AS r
ON a.app_id = r.app_id
GROUP BY type;


-- Q3: What is the average price among paid apps, per category?

SELECT c.category_name, AVG(a.price) as avg_price, MIN(a.price) as min_price, MAX(a.price) as max_price
FROM categories as c
INNER JOIN apps as a
ON c.category_id = a.category_id
WHERE a.price > 0 OR a.type = "Paid"
GROUP BY c.category_name
ORDER BY avg_price DESC;


-- Q4: Which categories have the highest total install counts?

SELECT c.category_name, SUM(a.installs) as tot_install_count
FROM categories as c
LEFT JOIN apps as a
ON c.category_id = a.category_id
GROUP BY c.category_name
ORDER BY tot_install_count DESC;


-- Q5: Is there a relationship between number of reviews and rating?

SELECT
    CASE
        WHEN a.reviews_count >= (SELECT AVG(reviews_count) FROM apps)
            THEN 'Above average review count'
        ELSE 'Below average review count'
    END AS review_volume_bucket,
    COUNT(a.app_id) as num_apps, AVG(a.rating) as avg_rating
FROM apps a
WHERE a.rating IS NOT NULL
GROUP BY review_volume_bucket;

