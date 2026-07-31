# PostgreSQL Setup Guide for PPPPdev

## Overview
This guide covers setting up PostgreSQL for the FastAPI application. The app expects:
- **User**: `ppp_user`
- **Password**: `password`
- **Database**: `users_db`
- **Host**: `localhost:5432`

## Prerequisites
- PostgreSQL 12+ installed
- `psql` command-line client available
- Sudo access (or direct postgres superuser access)

## Step 1: Verify PostgreSQL is Running
```bash
pg_isready -h localhost
```
Should return: `localhost:5432 - accepting connections`

## Step 2: Create User and Database

### Option A: Automated (Recommended)
Run the setup script:
```bash
bash scripts/postgres_setup.sh
```

### Option B: Manual
If you get a permission error like `could not change directory to "/home/...": Permission denied`, switch to a directory postgres can access first:
```bash
cd /tmp
sudo -u postgres psql
```

Then execute:
```sql
-- Create or update the role
CREATE USER ppp_user WITH PASSWORD 'password';
-- If it already exists, use:
-- ALTER USER ppp_user WITH PASSWORD 'password';

-- Create the database
CREATE DATABASE users_db OWNER ppp_user;

-- Grant all privileges
GRANT ALL PRIVILEGES ON DATABASE users_db TO ppp_user;

-- Verify
\du          -- List roles
\l users_db  -- List databases

-- Exit
\q
```

## Step 3: Verify Connection
Test the connection from the app's environment:
```bash
# Activate venv
source .venv/bin/activate

# Test with psql
psql -U ppp_user -h localhost -d users_db -c "SELECT VERSION();"
```
You'll be prompted for the password: `password`

## Step 4: Update .env File
The `.env` file in `v1/root/.env` is pre-configured with the default credentials:
```
DATABASE_URL=postgresql+asyncpg://ppp_user:password@localhost:5432/users_db
```

If you used different credentials, update the `DATABASE_URL` accordingly.

## Step 5: Run Migrations (if needed)
```bash
cd v1
alembic upgrade head
```

## Troubleshooting

### "connection refused" error
- PostgreSQL server is not running. Start it:
  ```bash
  sudo systemctl start postgresql
  ```

### "password authentication failed" error
- User doesn't exist or wrong password
- Run the setup script: `bash scripts/postgres_setup.sh`

### "FATAL: role 'ppp_user' does not exist"
- The ppp_user role was not created. Run the setup script.

### Database already exists error
- Uncomment the DROP commands in `postgres_setup.sh` if you want to recreate.

## Connection Details
- **Host**: `localhost`
- **Port**: `5432`
- **User**: `ppp_user`
- **Password**: `password`
- **Database**: `users_db`

## Additional Resources
- PostgreSQL Docs: https://www.postgresql.org/docs/14/
- SQLAlchemy Async: https://docs.sqlalchemy.org/en/20/orm/extensions/asyncio.html
- AsyncPG: https://magicstack.github.io/asyncpg/
