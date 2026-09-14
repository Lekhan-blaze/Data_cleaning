WITH duplicates as (
    SELECT ctid,
        row_number() OVER (
            PARTITION BY company,
            location,
            industry,
            total_laid_off,
            percentage_laid_off,
            date,
            stage,
            country,
            funds_raised_millions
        ) AS row_num
    FROM layoffs_staging
)
DELETE FROM layoffs_staging USING duplicates
WHERE layoffs_staging.ctid = duplicates.ctid
    AND duplicates.row_num > 1;
/*
 CTID: POSTGRESql internal identifier for each row 
 - Used a CTE to number every row within its duplicate group.
 - Ran a DELETE ... USING to join layoffs_staging to my CTE, matching each real row to its row_num.
 - Filtered to row_num > 1 so only the duplicate copies get deleted, keeping the first occurrence of each group.
 */