UPDATE layoffs_staging
SET industry = NULL
WHERE industry = ' ';
/*
 WHERE industry = ' ' blank-space converted to NULL
 */

SELECT t1.industry,
    t2.industry
FROM layoffs_staging t1
    JOIN layoffs_staging as t2 ON t1.company = t2.company
WHERE (
        t1.industry IS NULL
        OR t1.industry = ''
    )
    AND t2.industry IS NOT NULL;
/*
 Selects the industry in first column and the industry in the second column 
 where industry is NULL and the industry in the second column is NOT NULL 
 */

UPDATE layoffs_staging t1
SET industry = t2.industry
FROM layoffs_staging t2
WHERE t1.company = t2.company
    AND t1.industry IS NULL
    AND t2.industry IS NOT NULL;
/* 
 UPDATED layoffs_staging t1 SET industry = t2.industry WHERE company IS SAME AND industry IS NULL 
 this is how the null data filled
 */

SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
/*
 Selects the rows where both total_laid_off and percentage_laid_off are NULL 
 */

DELETE FROM layoffs_staging
WHERE total_laid_off IS NULL
    AND percentage_laid_off IS NULL;
/*
 Deletes the rows where both total_laid_off and percentage_laid_off are NULL 
 */