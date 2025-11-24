# Online Caregivers Platform - Assignment 3

PostgreSQL-backed caregivers management platform with Python utilities and Flask web interface.

## Quick Start with Docker (Local Development)

### 1. Start PostgreSQL Database + pgAdmin

```bash
docker-compose up -d
```

This starts:
- **PostgreSQL 15** on `localhost:5432`
- **pgAdmin 4** on `http://localhost:5050`

### 2. Access pgAdmin

Visit: **http://localhost:5050**
- Email: `admin@caregivers.com`
- Password: `admin`

The database connection is pre-configured and ready to use!

### 3. Load Schema and Data

```bash
docker exec -i caregivers_db psql -U postgres -d caregivers_db < schema_and_data.sql
```

### 4. Install Python Dependencies

```bash
pip install -r requirements.txt
```

### 5. Run with Local Database

**Option A: Use local Docker database**
```bash
# Create .env file
echo "DATABASE_URL=postgresql://postgres:postgres@localhost:5432/caregivers_db" > .env

# Run queries
python3 queries.py

# Run web app
python3 app.py
```

**Option B: Use cloud Supabase database**
```bash
# Set Supabase URL in .env
echo "DATABASE_URL=postgresql://postgres.PROJECT_ID:PASSWORD@aws-1-us-east-1.pooler.supabase.com:5432/postgres" > .env

# Run queries
python3 queries.py

# Run web app
python3 app.py
```

Visit: **http://127.0.0.1:5000/**

## Tech Stack

- PostgreSQL 15 (Docker for local, Supabase for production)
- Python 3 + SQLAlchemy 2.0
- Flask 3.0 + Bootstrap 5
- pgAdmin 4 (database management UI)
- Render.com (cloud deployment)

## Features

**Part 1:** Database schema with 10+ rows per table  
**Part 2:** 14 queries (updates, deletes, joins, aggregations, views)  
**Part 3:** Full CRUD web app for all entities (users, caregivers, members, jobs, appointments)

## Database Management

### Docker Management
```bash
# Stop containers
docker-compose down

# Stop and remove all data
docker-compose down -v

# View logs
docker-compose logs -f

# Restart services
docker-compose restart
```

### pgAdmin (Web UI)
Access at **http://localhost:5050** when Docker is running
- Pre-configured connection to local PostgreSQL
- Visual query builder
- Database browser and editor

### PostgreSQL CLI
```bash
# Access PostgreSQL directly
docker exec -it caregivers_db psql -U postgres -d caregivers_db
```

## Production Deployment

### Live Application
Live URL: **https://assignment-3-tkq0.onrender.com**

### Architecture
- **Hosting Platform:** Render.com (free tier)
- **Database:** Supabase PostgreSQL (cloud-managed PostgreSQL 15)
- **Deployment:** Full-stack cloud deployment with automatic GitHub integration

**Deployment Features:**
- Complete application deployed at https://assignment-3-tkq0.onrender.com
- Automatic deployments from GitHub repository
- External database connections supported (Supabase PostgreSQL)
- Environment variables configured in Render dashboard
- Python 3.12 runtime with gunicorn WSGI server

### Local Development

```bash
# Set Supabase connection in .env
DATABASE_URL=postgresql://postgres.PROJECT_ID:PASSWORD@aws-1-us-east-1.pooler.supabase.com:5432/postgres

# Run application
python3 app.py

# Visit http://127.0.0.1:5000
```