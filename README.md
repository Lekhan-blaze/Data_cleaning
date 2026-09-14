# 🧹 Data Cleaning — Layoffs Dataset

A SQL-based data cleaning pipeline built with **PostgreSQL** to transform raw layoff data into a reliable, analysis-ready dataset.

## 📌 Overview

This project demonstrates a structured approach to cleaning messy real-world data using pure SQL. The source dataset (`Layoffs.csv`) contains global layoff records, and the cleaning pipeline addresses common data quality issues: duplicate rows, inconsistent formatting, and null values.

All transformations are performed on a **staging table** to preserve the original raw data.

## 📁 Project Structure

```
Data_cleaning/
├── Dataset/
│   └── Layoffs.csv              # Raw source data
├── creation_table/
│   └── creation_of_table.sql    # Table creation & CSV import
├── practice_sql.sql/
│   ├── 1_duplicates.sql         # Step 1 — Remove duplicate rows
│   ├── 2_sanderdize.sql         # Step 2 — Standardize text fields
│   └── 3_null_values.sql        # Step 3 — Handle NULL values
└── README.md
```

## 🔧 Cleaning Pipeline

The scripts are designed to be run **sequentially**:

### Step 0 — Setup ([`creation_of_table.sql`](creation_table/creation_of_table.sql))

- Creates the `layoffs` table matching the CSV schema
- Imports data from `Layoffs.csv` using `COPY`
- Creates a `layoffs_staging` table (exact clone) so all cleaning is done on the copy, keeping raw data intact

### Step 1 — Remove Duplicates ([`1_duplicates.sql`](practice_sql.sql/1_duplicates.sql))

- Uses a CTE with `ROW_NUMBER()` partitioned across all columns to identify exact duplicate rows
- Leverages PostgreSQL's internal `ctid` to target and delete only the duplicate copies, keeping the first occurrence

### Step 2 — Standardize Data ([`2_sanderdize.sql`](practice_sql.sql/2_sanderdize.sql))

- **Company names** — Trims leading/trailing whitespace (e.g., `" WeWork "` → `"WeWork"`)
- **Industry values** — Consolidates inconsistent crypto-related entries (`"Crypto Currency"`, `"Crypto/Blockchain"`, etc.) into a single `"Crypto"` label
- **Country names** — Removes trailing dots (e.g., `"Brazil."` → `"Brazil"`)

### Step 3 — Handle NULLs ([`3_null_values.sql`](practice_sql.sql/3_null_values.sql))

- Converts blank-space strings to proper `NULL` values
- Back-fills missing `industry` values by joining on `company` — if the same company has a known industry in another row, that value is used
- Deletes rows where **both** `total_laid_off` and `percentage_laid_off` are `NULL` (no useful layoff data)

## 📊 Dataset Schema

| Column                 | Type            | Description                          |
|------------------------|-----------------|--------------------------------------|
| `company`              | `VARCHAR(50)`   | Company name                         |
| `location`             | `VARCHAR(50)`   | City / region                        |
| `industry`             | `VARCHAR(50)`   | Industry sector                      |
| `total_laid_off`       | `INTEGER`       | Number of employees laid off         |
| `percentage_laid_off`  | `NUMERIC(5,2)`  | Percentage of workforce laid off     |
| `date`                 | `DATE`          | Date of layoff event                 |
| `stage`                | `VARCHAR(50)`   | Company funding stage                |
| `country`              | `VARCHAR(50)`   | Country                              |
| `funds_raised_millions`| `NUMERIC(10,2)` | Total funds raised (in millions USD) |

## 🚀 Getting Started

### Prerequisites

- **PostgreSQL** installed and running
- A tool to run `.sql` files (e.g., `psql`, pgAdmin, DBeaver)

### Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Data_cleaning.git
   cd Data_cleaning
   ```

2. Update the CSV path in [`creation_of_table.sql`](creation_table/creation_of_table.sql) (line 29) to point to your local `Layoffs.csv` location.

3. Run the scripts in order:
   ```sql
   -- Step 0: Create tables & import data
   \i creation_table/creation_of_table.sql

   -- Step 1: Remove duplicates
   \i practice_sql.sql/1_duplicates.sql

   -- Step 2: Standardize text fields
   \i practice_sql.sql/2_sanderdize.sql

   -- Step 3: Handle NULL values
   \i practice_sql.sql/3_null_values.sql
   ```

4. Query the cleaned data:
   ```sql
   SELECT * FROM layoffs_staging LIMIT 10;
   ```

## 🛠️ Tech Stack

- **SQL Dialect:** PostgreSQL
- **Key Concepts:** CTEs, Window Functions (`ROW_NUMBER`), Self-Joins, `TRIM`, `COPY`

## 📝 License

This project is open source and available for learning and personal use.
