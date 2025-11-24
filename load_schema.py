from sqlalchemy import create_engine, text
from sqlalchemy.pool import NullPool
from dotenv import load_dotenv
import os

load_dotenv()

DATABASE_URL = os.environ.get('DATABASE_URL')
engine = create_engine(DATABASE_URL, poolclass=NullPool)

print("Loading schema and data to database...")

with open('schema_and_data.sql', 'r') as f:
    sql_content = f.read()

with engine.begin() as conn:
    try:
        raw_conn = conn.connection
        cursor = raw_conn.cursor()
        cursor.execute(sql_content)
        cursor.close()
        print("Schema and data loaded successfully.")
    except Exception as e:
        print(f"Error loading schema: {e}")
        raise

print("Now you can run: python3 queries.py")
