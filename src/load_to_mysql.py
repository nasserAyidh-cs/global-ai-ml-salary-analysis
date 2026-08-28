from pathlib import Path

import pandas as pd
from sqlalchemy import text

from database_connection import engine

project_root = Path(__file__).resolve().parent.parent

processed_file_path = (
    project_root
    / "data"
    / "processed"
    / "salaries_clean.csv"
)

table_name = "salary_records"

if not processed_file_path.exists():
    raise FileNotFoundError(
        f"Processed CSV file was not found: {processed_file_path}"
    )

expected_columns = [
    "work_year",
    "experience_level",
    "experience_level_label",
    "employment_type",
    "employment_type_label",
    "job_title",
    "salary",
    "salary_currency",
    "salary_in_usd",
    "employee_residence",
    "remote_ratio",
    "remote_type",
    "company_location",
    "company_size",
    "company_size_label"
]

df = pd.read_csv(processed_file_path)

actual_columns = set(df.columns)
expected_columns_set = set(expected_columns)

missing_columns = expected_columns_set - actual_columns
unexpected_columns = actual_columns - expected_columns_set

if missing_columns or unexpected_columns:
    raise ValueError(
        f"Column mismatch. "
        f"Missing: {sorted(missing_columns)}. "
        f"Unexpected: {sorted(unexpected_columns)}."
    )

df = df[expected_columns]

print(f"CSV rows ready for loading: {len(df):,}")

with engine.begin() as connection:
    existing_count = connection.execute(
        text("SELECT COUNT(*) FROM salary_records;")
    ).scalar()

    print(f"Existing MySQL rows: {existing_count:,}")

    if existing_count != 0:
        raise RuntimeError(
            "The salary_records table is not empty. "
            "Loading was stopped to prevent duplicate insertion."
        )

    df.to_sql(
        name=table_name,
        con=connection,
        if_exists="append",
        index=False,
        chunksize=1000,
        method="multi"
    )

    database_count = connection.execute(
        text("SELECT COUNT(*) FROM salary_records;")
    ).scalar()

    if database_count != len(df):
        raise RuntimeError(
            f"Row-count mismatch: CSV has {len(df):,} rows, "
            f"but MySQL has {database_count:,} rows."
        )

print(f"Inserted MySQL rows: {database_count:,}")
print("Data loading completed successfully.")