UPDATE layoffs_staging
SET company = TRIM(company);
/*
TRIM(company) — fixed names like "WeWork ", "Captain Fresh ", " E Inc.", " Included Health" that had stray leading/trailing spaces.
 */

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
/*
industry LIKE 'Crypto%' — caught various crypto-related misspellings like "Crypto Currency", "Crypto-currency", "Crypto/Blockchain", etc., and standardized them to "Crypto".
 */

UPDATE layoffs_staging
SET country = TRIM(
        TRAILING '.'
        FROM country
    );
/*
TRIM(TRAILING '.' FROM country) — removed trailing dots from country names like "Brazil." to make them clean.
 */

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;