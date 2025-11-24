# Online Caregivers Platform - Assignment 3

PostgreSQL-backed caregivers management platform with Python utilities and Flask web interface.

## Quick Start with Docker

### 1. Start PostgreSQL Database

```bash
docker-compose up -d
```

### 2. Load Schema and Data

```bash
docker exec -i caregivers_db psql -U postgres -d caregivers_db < schema_and_data.sql
```

### 3. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 4. Run Part 2 Queries

```bash
python3 queries.py
```

### 5. Run Part 3 Web Application

```bash
python3 app.py
```

Visit: **http://127.0.0.1:5000/**

## Tech Stack

- PostgreSQL 15 (Docker for local, Supabase for production)
- Python 3 + SQLAlchemy 2.0
- Flask 3.0 + Bootstrap 5
- PythonAnywhere (cloud deployment)

## Features

**Part 1:** Database schema with 10+ rows per table  
**Part 2:** 14 queries (updates, deletes, joins, aggregations, views)  
**Part 3:** Full CRUD web app for all entities (users, caregivers, members, jobs, appointments)

## Database Management

```bash
# Stop container
docker-compose down -v

# Access PostgreSQL CLI
docker exec -it caregivers_db psql -U postgres -d caregivers_db
```

## Production Deployment

### Deployed Frontend
Live URL: **https://sagyzdop.pythonanywhere.com** (frontend only)

### Architecture
- **Frontend Hosting:** PythonAnywhere (free tier)
- **Database:** Supabase PostgreSQL (cloud-managed PostgreSQL 15)
- **Full-Stack:** Local development with cloud database

### PythonAnywhere Limitation

**Important:** PythonAnywhere free tier does not support external database connections. From their documentation:

> "Accessing your PostgreSQL database from outside PythonAnywhere"
> "Warning -- this will only work in paid accounts"
> https://help.pythonanywhere.com/pages/AccessingPostgresFromOutsidePythonAnywhere/

**Current Deployment:**
- ✅ Frontend deployed and accessible at https://sagyzdop.pythonanywhere.com
- ✅ Full application (frontend + database) runs locally with Supabase cloud database
- ❌ Full cloud deployment requires PythonAnywhere paid account ($5/month)

### Local Development (Full-Stack with Cloud Database)

```bash
# Set Supabase connection in .env
DATABASE_URL=postgresql://postgres.PROJECT_ID:PASSWORD@aws-1-us-east-1.pooler.supabase.com:5432/postgres

# Run application
python3 app.py

# Visit http://127.0.0.1:5000
```

The application is fully functional locally with Supabase cloud database, demonstrating production-ready architecture.

### Alternative Free Cloud Platforms

For free full-stack deployment with external database support:

**Render.com (Recommended):**
- Free PostgreSQL database
- Free web service hosting
- No external connection restrictions
- Deploy from GitHub

**Railway.app:**
- Free tier with PostgreSQL
- Automatic deployments
- Environment variables in dashboard

**Heroku:**
- Free tier with PostgreSQL add-on
- Git-based deployment
- Buildpack auto-detection