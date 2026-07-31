#!/usr/bin/env bash
set -euo pipefail

# PostgreSQL Setup Script for PPPPdev
# This script creates the ppp_user role and users_db database for the FastAPI app.
# Run with: sudo bash scripts/postgres_setup.sh

PGUSER="ppp_user"
PGPASSWORD="password"
PGDATABASE="users_db"

echo "PostgreSQL Setup for PPPPdev"
echo "================================"
echo "Creating user: $PGUSER"
echo "Creating database: $PGDATABASE"
echo ""

# Connect as postgres and create/alter the role and database
sudo -u postgres -i psql <<EOF
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$PGUSER') THEN
    CREATE ROLE $PGUSER LOGIN PASSWORD '$PGPASSWORD';
  ELSE
    ALTER ROLE $PGUSER LOGIN PASSWORD '$PGPASSWORD';
  END IF;
END$$;

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = '$PGDATABASE') THEN
    CREATE DATABASE $PGDATABASE OWNER $PGUSER;
  END IF;
END$$;

GRANT ALL PRIVILEGES ON DATABASE $PGDATABASE TO $PGUSER;

-- Show results
\du
\l
EOF

echo ""
echo "✓ PostgreSQL setup complete!"
echo ""
echo "Connection string for FastAPI:"
echo "DATABASE_URL=postgresql+asyncpg://$PGUSER:$PGPASSWORD@localhost:5432/$PGDATABASE"
echo ""
echo "Update your .env file with this connection string."
