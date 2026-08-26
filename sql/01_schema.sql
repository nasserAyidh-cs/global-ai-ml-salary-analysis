CREATE DATABASE IF NOT EXISTS global_ai_salary_analysis
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE global_ai_salary_analysis;

CREATE TABLE IF NOT EXISTS salary_records (
    record_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    work_year SMALLINT UNSIGNED NOT NULL,

    experience_level CHAR(2) NOT NULL,
    experience_level_label VARCHAR(20) NOT NULL,

    employment_type CHAR(2) NOT NULL,
    employment_type_label VARCHAR(20) NOT NULL,

    job_title VARCHAR(150) NOT NULL,

    salary DECIMAL(15, 2) NOT NULL,
    salary_currency CHAR(3) NOT NULL,
    salary_in_usd DECIMAL(12, 2) NOT NULL,

    employee_residence CHAR(2) NOT NULL,

    remote_ratio TINYINT UNSIGNED NOT NULL,
    remote_type VARCHAR(10) NOT NULL,

    company_location CHAR(2) NOT NULL,

    company_size CHAR(1) NOT NULL,
    company_size_label VARCHAR(10) NOT NULL,

    CONSTRAINT chk_salary_positive
        CHECK (salary > 0),

    CONSTRAINT chk_salary_usd_positive
        CHECK (salary_in_usd > 0),

    CONSTRAINT chk_remote_ratio
        CHECK (remote_ratio IN (0, 50, 100))
);