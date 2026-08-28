USE  global_ai_salary_analysis;

-- Salary statistics by experience level
SELECT 
    experience_level,
    experience_level_label,
    COUNT(*) AS record_count,
    ROUND(AVG(salary_in_usd), 2) AS average_salary_usd,
    MIN(salary_in_usd) AS minimum_salary_usd,
    MAX(salary_in_usd) AS maximum_salary_usd

FROM salary_records
GROUP BY 
    experience_level,
    experience_level_label

ORDER BY FIELD(
    experience_level,
    'EN',
    'MI',
    'SE',
    'EX'
);

-- Median salary by experience level
WITH ranked_salaries AS (
    SELECT
        experience_level,
        experience_level_label,
        salary_in_usd,
        ROW_NUMBER() OVER (
            PARTITION BY experience_level
            ORDER BY salary_in_usd
        ) AS row_number_in_level,
        COUNT(*) OVER (
            PARTITION BY experience_level
        ) AS level_record_count
    FROM salary_records
)

SELECT
    experience_level,
    experience_level_label,
    level_record_count AS record_count,
    ROUND(AVG(salary_in_usd), 2) AS median_salary_usd
FROM ranked_salaries
WHERE row_number_in_level IN (
    FLOOR((level_record_count + 1) / 2),
    FLOOR((level_record_count + 2) / 2)
)
GROUP BY
    experience_level,
    experience_level_label,
    level_record_count
ORDER BY FIELD(
    experience_level,
    'EN',
    'MI',
    'SE',
    'EX'
);

-- Top 10 most represented job titles

SELECT
    job_title,
    COUNT(*) AS record_count,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_records
FROM salary_records
GROUP BY job_title
ORDER BY record_count DESC
LIMIT 10;


-- Top 10 job titles by median salary
-- Only job titles with at least 100 records are included
WITH ranked_job_salaries AS (
    SELECT
        job_title,
        salary_in_usd,
        ROW_NUMBER() OVER (
            PARTITION BY job_title
            ORDER BY salary_in_usd
        ) AS row_number_in_title,
        COUNT(*) OVER (
            PARTITION BY job_title
        ) AS job_record_count
    FROM salary_records
)

SELECT
    job_title,
    MAX(job_record_count) AS record_count,
    ROUND(AVG(salary_in_usd), 2) AS median_salary_usd
FROM ranked_job_salaries
WHERE row_number_in_title IN (
    FLOOR((job_record_count + 1) / 2),
    FLOOR((job_record_count + 2) / 2)
)
GROUP BY job_title
HAVING MAX(job_record_count) >= 100
ORDER BY median_salary_usd DESC
LIMIT 10;