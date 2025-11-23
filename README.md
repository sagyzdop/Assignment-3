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

Application deployed to PythonAnywhere: `https://sagyzdop.pythonanywhere.com`

Database hosted on Supabase PostgreSQL with environment variable configuration for secure connection management.