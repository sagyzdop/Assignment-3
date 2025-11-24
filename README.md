# Online Caregivers Platform - Assignment 3

PostgreSQL-backed caregivers management platform with Python utilities and Flask web interface.

## Production Deployment

**Live Application:** https://assignment-3-tkq0.onrender.com

- **Hosting:** Render.com (free tier)
- **Database:** Supabase PostgreSQL (cloud-managed)
- **Runtime:** Python 3.12 + Gunicorn WSGI server
- **CI/CD:** Automatic deployments from GitHub

## Local Development

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Database

Edit `.env` and uncomment one option:
- **Local Docker:** `DATABASE_URL=postgresql://postgres:postgres@localhost:5432/caregivers_db`
- **Cloud Supabase:** `DATABASE_URL=postgresql://postgres.PROJECT_ID:PASSWORD@...`

### 3. Start Database (Docker)

```bash
docker-compose up -d
```

Starts:
- PostgreSQL on port 5432
- pgAdmin at http://localhost:5050 (login: `admin@caregivers.com` / `admin`)

### 4. Initialize Schema

```bash
python3 load_schema.py
```

### 5. Run Application

```bash
# Test queries
python3 queries.py

# Start web server
python3 app.py
```

Visit: http://127.0.0.1:5000/

### Database Management

**pgAdmin UI:** http://localhost:5050 (pre-configured connection, if asked, the password for the database is `postgres`)

**PostgreSQL CLI:**
```bash
docker exec -it caregivers_db psql -U postgres -d caregivers_db
```

**Stop containers:**
```bash
docker-compose down -v
```

## Tech Stack

- PostgreSQL 15 (Docker / Supabase)
- Python 3 + SQLAlchemy 2.0
- Flask 3.0 + Bootstrap 5
- pgAdmin 4
- Render.com

## Features

**Part 1:** Database schema with 10+ rows per table  
**Part 2:** 14 queries (updates, deletes, joins, aggregations, views)  
**Part 3:** Full CRUD web app for all entities