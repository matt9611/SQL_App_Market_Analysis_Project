# Google Play Store: App Market Analysis

A SQL-driven market analysis built for a fictional app development agency, **Northbeam Studio**, deciding on pricing and category strategy for its next app launch.

This project was built as a Data Analytics Bootcamp mini-project: take raw Play Store data, clean it, load it into a relational database, and use SQL to answer real business questions — free vs. paid pricing, which app category to target, and whether review volume signals app quality.

---

## Business Case

Northbeam Studio is in the pre-launch phase for its next app and needs a pricing and positioning strategy backed by data, not guesswork. This project answers three questions for them:

1. **Should the next app be free or paid**, to maximize sentiment and ratings?
2. **Which app category** offers the best mix of high ratings and high install volume?
3. **Does review volume** actually correlate with perceived app quality?

---

## Data Sources

Two datasets, both from Kaggle:

| File | Description |
|---|---|
| `googleplaystore.csv` | Primary dataset — one row per app. Fields: app name, category, rating, number of reviews, installs, type (Free/Paid), price, content rating, last updated, current version, Android version. |
| `googleplaystore_user_reviews.csv` | Secondary dataset — user reviews with pre-computed sentiment (label, polarity score, subjectivity score). |

The two files don't share a clean key by default — reviews only reference apps by name. During cleaning, reviews were matched to apps and re-linked using a **numeric `app_id`**, which is far more reliable than matching on name.

---

## Database Design

The cleaned data is loaded into a 3-table MySQL schema:

```
categories  (1) ──< apps  (1) ──< reviews
```

| Table | Purpose |
|---|---|
| `categories` | Lookup table — 33 unique app categories |
| `apps` | Core entity — one row per app, with a foreign key to `categories` |
| `reviews` | One row per user review, with a foreign key to `apps` |

See `schema.sql` for the full `CREATE TABLE` statements, and the ERD image in this repo for a visual diagram.

---

## Repo Structure

```
├── README.md                  ← you are here
├── schema.sql                 ← database schema (CREATE DATABASE / TABLE statements)
├── queries.sql                ← all 5 analysis queries, commented
├── data_cleaning.ipynb        ← Python cleaning pipeline (raw CSVs → cleaned CSVs)
├── report.ipynb               ← narrative report: findings, charts, conclusions
└── ERD.png                    ← entity-relationship diagram
```

---

## How to Reproduce This

1. **Clone the repo** and make sure you have MySQL Workbench and Jupyter installed (Python packages needed: `pandas`, `matplotlib`, `seaborn`).
2. **Run `data_cleaning.ipynb`** top to bottom. This reads the two raw Kaggle CSVs and exports three cleaned files: `categories.csv`, `apps.csv`, `reviews.csv`.
3. **Run `schema.sql`** in MySQL Workbench to create the `GoogleApps` database and its three empty tables.
4. **Import the three CSVs** using MySQL Workbench's Table Data Import Wizard, in this order: `categories` → `apps` → `reviews` (parent tables before the child that references them).
5. **Run the queries in `queries.sql`** against the loaded database, or open `report.ipynb` to see them already connected to pandas and visualized.

---

## Data Cleaning Summary

| Step | What happened |
|---|---|
| Load raw | 10,841 rows × 13 columns |
| Remove duplicates | −483 rows → 10,358 rows |
| Drop sparse-null rows | −2 rows → **10,356 final rows** |
| Fill rating nulls | 1,474 missing ratings filled with the column mean (4.19), to preserve row count for joins |
| Fix numeric types | `installs` and `price` arrived as text (e.g. `"10,000+"`, `"$4.99"`) — symbols stripped, cast to numeric |
| Build categories lookup | 33 unique categories factorized into FK-ready IDs |
| Final validation | Zero nulls, all foreign key relationships intact |

**Biggest cleaning challenges:** special characters/emojis in review text (which also broke MySQL Workbench's CSV import wizard until the text was sanitized), and reliably matching reviews to the correct app.

---

## Key Findings

| # | Question | Finding |
|---|---|---|
| Q1 | Which categories have the highest average rating? | Ratings cluster tightly across all 33 categories (4.01–4.39). Education leads narrowly, but within-category variation often exceeds the gap between categories — **category choice is a weak lever for rating.** |
| Q2 | Do paid apps have higher sentiment than free apps? | Paid apps score marginally higher (0.288 vs. 0.263 average sentiment polarity), but the gap is narrow — **not a decisive factor for pricing.** |
| Q3 | What's the average price per category? | Reliable pricing sits around **$9–$15** (Business, Medical, Productivity). Headline highs like Finance ($170.64) are misleading — driven by outlier apps or tiny sample sizes, not real market pricing. |
| Q4 | Which categories have the highest total installs? | **Game (31.5B)** and **Communication (24.2B)** dominate installs by a wide margin. Finance — the highest-priced category — ranks only ~15th (770M installs). **High price ≠ high reach.** |
| Q5 | Does review volume correlate with rating? | Apps with above-average review counts rate modestly higher (4.38 vs. 4.15) — a real but small gap, and not proof that more reviews *cause* better quality. |

---

## Recommendations for Northbeam Studio

1. **Adopt a freemium pricing model** — sentiment barely differs between free and paid, but the categories with the biggest reach are all low-price/free, since scale requires free access.
2. **Separate the rating decision from the reach decision** — don't expect one category to win on both fronts. Pick a category based on product fit, then benchmark it against the right goal (rating quality *or* market reach, not both).
3. **Treat review volume as an engagement signal, not a quality guarantee** — improve ratings directly through product quality, onboarding, and support, rather than assuming more reviews alone will drive better ratings.

---

## Tech Stack

- **Python** (pandas) — data cleaning
- **MySQL** — relational database and analysis queries
- **Matplotlib / Seaborn** — visualizations
- **Jupyter Notebook** — cleaning pipeline and final report

---

## Team

- Berker Ildokuz
- Matteo Grossi

Data Analytics Bootcamp — Mini Project, July 2026
