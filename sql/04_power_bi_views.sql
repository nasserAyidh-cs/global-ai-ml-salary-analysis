USE global_ai_salary_analysis;

CREATE OR REPLACE VIEW vw_salary_analysis AS
SELECT
    record_id,
    work_year,

    experience_level,
    experience_level_label,
    CASE experience_level
        WHEN 'EN' THEN 1
        WHEN 'MI' THEN 2
        WHEN 'SE' THEN 3
        WHEN 'EX' THEN 4
    END AS experience_level_order,

    employment_type,
    employment_type_label,

    job_title,

    salary,
    salary_currency,
    salary_in_usd,

    CASE
        WHEN salary_in_usd < 50000 THEN 'Below 50K'
        WHEN salary_in_usd < 100000 THEN '50K-99K'
        WHEN salary_in_usd < 150000 THEN '100K-149K'
        WHEN salary_in_usd < 200000 THEN '150K-199K'
        ELSE '200K+'
    END AS salary_band,

    CASE
        WHEN salary_in_usd < 50000 THEN 1
        WHEN salary_in_usd < 100000 THEN 2
        WHEN salary_in_usd < 150000 THEN 3
        WHEN salary_in_usd < 200000 THEN 4
        ELSE 5
    END AS salary_band_order,

    employee_residence,
    remote_ratio,
    remote_type,
    company_location,

    company_size,
    company_size_label,
    CASE company_size
        WHEN 'S' THEN 1
        WHEN 'M' THEN 2
        WHEN 'L' THEN 3
    END AS company_size_order

FROM salary_records;