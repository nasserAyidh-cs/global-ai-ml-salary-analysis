USE global_ai_salary_analysis;

SELECT
    COUNT(*) AS total_records,
    MIN(record_id) AS first_record_id,
    MAX(record_id) AS last_record_id
FROM salary_records;


SELECT
    MIN(work_year) AS first_year,
    MAX(work_year) AS last_year,
    MIN(salary_in_usd) AS minimum_salary_usd,
    MAX(salary_in_usd) AS maximum_salary_usd
FROM salary_records;


SELECT
    work_year,
    COUNT(*) AS record_count
FROM salary_records
GROUP BY work_year
ORDER BY work_year;


SELECT
    COUNT(*) AS rows_with_any_null
FROM salary_records
WHERE
    work_year IS NULL
    OR experience_level IS NULL
    OR experience_level_label IS NULL
    OR employment_type IS NULL
    OR employment_type_label IS NULL
    OR job_title IS NULL
    OR salary IS NULL
    OR salary_currency IS NULL
    OR salary_in_usd IS NULL
    OR employee_residence IS NULL
    OR remote_ratio IS NULL
    OR remote_type IS NULL
    OR company_location IS NULL
    OR company_size IS NULL
    OR company_size_label IS NULL;