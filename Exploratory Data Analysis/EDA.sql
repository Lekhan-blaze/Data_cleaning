-- Basic overview: total rows, date range, and distinct counts
SELECT 
    COUNT(*) AS total_rows,
    MIN(date) AS min_date,
    MAX(date) AS max_date,
    COUNT(DISTINCT company) AS total_companies,
    COUNT(DISTINCT industry) AS total_industries, 
    COUNT(DISTINCT country) AS total_countries
FROM layoffs_staging;

-- Min and max of all numeric columns
SELECT
    MIN(total_laid_off) AS min_laid_off,
    MAX(total_laid_off) AS max_laid_off,
    MIN(percentage_laid_off) AS min_percentage_laid_off,
    MAX(percentage_laid_off) AS max_percentage_laid_off,
    MIN(funds_raised_millions) AS min_funds_raised_millions,
    MAX(funds_raised_millions) AS max_funds_raised_millions
FROM layoffs_staging;

-- Top 10 companies by total layoffs
SELECT  
    company,
    SUM(total_laid_off) as total_off
FROM
    layoffs_staging
WHERE 
    total_laid_off IS NOT NULL
GROUP BY company
ORDER BY total_off DESC
LIMIT 10;

-- Companies that completely shut down (100% laid off), ordered by funding raised
SELECT
    company,
    industry,
    total_laid_off,
    funds_raised_millions,
    date
FROM layoffs_staging
WHERE funds_raised_millions IS NOT NULL
    AND percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Top 10 industries by total layoffs
WITH industry_of AS (
    SELECT
        industry, 
        SUM(total_laid_off) as total_off
    FROM layoffs_staging
    WHERE total_laid_off IS NOT NULL
    GROUP BY industry
    ORDER BY total_off DESC
    LIMIT 10
)
SELECT *
FROM industry_of;

-- Top 10 countries by total layoffs
SELECT
    country,
    SUM(total_laid_off) as total_off
FROM layoffs_staging
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY total_off DESC
LIMIT 10;

-- Monthly layoff trend
SELECT
    DATE_TRUNC('month',date)::DATE AS month,
    SUM(total_laid_off) as total_off
FROM 
    layoffs_staging
WHERE total_laid_off IS NOT NULL
    AND date IS NOT NULL
GROUP BY month
ORDER BY month;

-- Rolling (cumulative) total of layoffs month over month
WITH monthly_date AS(
    SELECT
        DATE_TRUNC('month',date)::DATE AS month,
        SUM(total_laid_off) as total_off
    FROM 
        layoffs_staging
    WHERE total_laid_off IS NOT NULL
        AND date IS NOT NULL
    GROUP BY month
    ORDER BY month
)
SELECT 
    month,
    total_off,
    SUM(total_off) OVER(ORDER BY month) as rolling_total
FROM 
    monthly_date
ORDER by month;

-- Total layoffs per year
SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(total_laid_off) AS total_off
FROM layoffs_staging
WHERE total_laid_off IS NOT NULL
    AND date IS NOT NULL
GROUP BY year
ORDER BY year;

-- Layoffs by company funding stage
SELECT
    stage,
    SUM(total_laid_off) as total_off
FROM layoffs_staging
WHERE
    total_laid_off IS NOT NULL
    AND stage IS NOT NULL
GROUP BY stage
ORDER BY total_off DESC;

-- Top 5 companies with most layoffs per year using DENSE_RANK
WITH yearly_company AS(
    SELECT
        company,
        EXTRACT(YEAR FROM date) AS year,
        SUM(total_laid_off) AS total_off
    FROM layoffs_staging
    WHERE total_laid_off IS NOT NULL
        AND date IS NOT NULL
    GROUP BY company,year
    ORDER BY year 
), Rankings AS(
    SELECT *,
    DENSE_RANK() OVER(PARTITION BY year ORDER BY total_off DESC) AS rank
    FROM yearly_company
)
SELECT * FROM rankings
WHERE rank <=5;

-- Companies with multiple layoff rounds
SELECT
    company,
    COUNT(*) as layoff_events,
    SUM(total_laid_off) as total_off
FROM layoffs_staging
WHERE
    total_laid_off IS NOT NULL
    AND company IS NOT NULL
GROUP BY company
HAVING COUNT(*) > 1
ORDER BY layoff_events DESC;