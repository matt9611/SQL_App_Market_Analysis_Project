-- Google Play Store Project — Database Schema
-- Creating the database and all 3 tables with primary/foreign keys.

CREATE DATABASE IF NOT EXISTS GoogleApps
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE GoogleApps;

DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS apps;
DROP TABLE IF EXISTS categories;

-- TABLE 1: categories

CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- TABLE 2: apps (references categories)
-- NOTE: primary key column renamed id -> app_id to match apps.csv from data_cleaning.ipynb
-- NOTE: current_version widened from VARCHAR(20) to VARCHAR(100) -- some real version
--       strings (build hashes, browser bundle names) run up to ~50 characters.
-- NOTE: app_id is NOT auto-increment -- data_cleaning.ipynb already generates final,
--       sequential app_id values before export, and reviews.csv was matched against
--       those exact same values. Auto-increment must not be allowed to regenerate them.

CREATE TABLE apps (
    app_id           INT PRIMARY KEY,
    app_name         VARCHAR(200),
    category_id      INT,
    rating           FLOAT,
    reviews_count    INT,
    size             VARCHAR(20),
    installs         INT,
    type             VARCHAR(10),
    price            FLOAT,
    content_rating   VARCHAR(20),
    last_updated     VARCHAR(20),
    current_version  VARCHAR(100),
    android_version  VARCHAR(20),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- TABLE 3: reviews (references apps)
-- NOTE: foreign key column renamed app_id -> app_id still, but now points to apps(app_id)
--       instead of apps(id), matching the rename above.
-- NOTE: no app_name column here -- data_cleaning.ipynb drops it from the final export
--       (reviews_final_df keeps only review_id, app_id, translated_review, sentiment,
--       sentiment_polarity, sentiment_subjectivity). Keeping this table's columns in
--       sync with that DataFrame.
-- NOTE: app_id is NOT NULL -- the notebook drops any review row that has no matching
--       app_id before export, so every row in reviews.csv always has one.

CREATE TABLE reviews (
    review_id               INT AUTO_INCREMENT PRIMARY KEY,
    app_id                  INT NOT NULL,
    translated_review       TEXT,
    sentiment               VARCHAR(10),
    sentiment_polarity      FLOAT,
    sentiment_subjectivity  FLOAT,
    FOREIGN KEY (app_id) REFERENCES apps(app_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
