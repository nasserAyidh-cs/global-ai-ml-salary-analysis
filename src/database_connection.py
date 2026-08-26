from pathlib import Path
import os

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL


project_root = Path(__file__).resolve().parent.parent
env_path = project_root / ".env"

load_dotenv(env_path)


database_url = URL.create(
    drivername="mysql+pymysql",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT", "3306")),
    database=os.getenv("DB_NAME")
)


engine = create_engine(database_url)


if __name__ == "__main__":
    with engine.connect() as connection:
        database_name = connection.execute(
            text("SELECT DATABASE();")
        ).scalar()

        record_count = connection.execute(
            text("SELECT COUNT(*) FROM salary_records;")
        ).scalar()

        print(f"Connected database: {database_name}")
        print(f"Current records: {record_count:,}")