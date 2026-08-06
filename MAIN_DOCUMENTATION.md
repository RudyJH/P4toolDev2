# PPPPdev Application Documentation

# Personality and Public Policy Profile tool

The goal is to create a dynamic, self-updating database of public individuals with their Big-Five + Dark Three Personality Profile and Public Policy views called "PPPProfile". 
 
## Overview

**Application:** PPPPdev  
**File:** `app/main.py`

This is the main entry point for the FastAPI application. It sets up the application, including the database connection, CORS middleware, and API routes.
Checkpoint: July 2026 - working startup and basic openning web page.
2026 August: Fresh repo, continuiong dev
GitHub Repo:
  git@github.com:RudyJH/P4toolDev2.git

## Design considerations:
- Following recomended file structure as shown in https://fastapi.tiangolo.com/tutorial/bigger-applications/#apirouter


## Database Configuration

- **Database:** PostgreSQL (accessed asynchronously via SQLAlchemy 2)
- **Connection:** Async connection with SQLAlchemy 2
- **Lifespan Management:** Uses an async lifespan context manager to handle startup and shutdown events
  - **Init:** checks if database tables exist, Creates database tables 
  - **Startup:** Open database tables , check for 
  - **Shutdown:** Disposes of the connection pool

## Features

- Health check endpoint
- Routes for managing users
- CORS middleware enabled for all origins
- Connected token cookie is set on responses with a timestamp
- API documentation available via interactive docs

> Note: When `DB_INIT = 0`, database initialization is skipped and the user CRUD routines are not registered. The docs page will still load, but only the health endpoint is available.

## prerequisites : 
# first time: activate Enviroment from the root dir with:
$ source .venv/bin/activate

 - see .agent.md for further venv instructions

## Requirements
- FastAPI
- other Dependencies - use a venv based on requimements.txt

- Data Base connections using  SQLAlchemy
see main.py DB_INIT for  Dev and Debug mode
  - DB_INIT = 0: No DB, testing and startup development mode
  - DB_INIT = 1: SQLite database  
  - DB_INIT = 2: PostgreSQL (server must be running and ready)

###  Database Setup
- Check that PostgreSQL is running
- Create a user: `ppp_user`
- DB initialization in process (need first time init logic)

###  Run the Application in the <root>/v1 directory
```bash
uvicorn app.main:app --reload
```

### 4. Access API Documentation
Navigate to: `http://localhost:8000/docs`

## API Information

- **Title:** PPPPdev (from `settings.APP_NAME`)
- **Description:** PostgreSQL CRUD API — Users | Python 3 + FastAPI + SQLAlchemy 2
- **Version:** Retrieved from settings
- **Base Route:** `/api/v1`

## Endpoints

- `GET /health` - Health check endpoint (returns status and version)
- `/api/v1/...` - User management routes

## Architecture Notes

- Uses Alembic migrations in production (currently using direct table creation for development)
- CORS middleware configured to allow all origins
- Async context manager for proper resource management
