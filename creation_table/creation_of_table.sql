-- STEP 1: create the raw table matching the CSV columns
CREATE TABLE layoffs (
    company VARCHAR(50),
    location VARCHAR(50),
    industry VARCHAR(50),
    total_laid_off INTEGER,
    percentage_laid_off NUMERIC(5, 2),
    date DATE,
    stage VARCHAR(50),
    country VARCHAR(50),
    funds_raised_millions NUMERIC(10, 2)
);

-- STEP 2: set date format so MM/DD/YYYY in the CSV parses correctly
SET datestyle = 'MDY';

-- STEP 3: load the CSV data into layoffs
COPY layoffs (
    company,
    location,
    industry,
    total_laid_off,
    percentage_laid_off,
    date,
    stage,
    country,
    funds_raised_millions
)
FROM 'path_to/layoffs.csv' WITH (FORMAT csv, HEADER true, NULL 'NULL');

-- STEP 4: create an empty staging table with the exact same structure as layoffs so that we cannot manipulate the raw data.
CREATE TABLE layoffs_staging (LIKE layoffs INCLUDING ALL);

-- STEP 5: copy all the raw data into staging
-- where we can perform the data cleaning operations
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;