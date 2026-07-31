#  $ sudo -u postgres psql 
#  could not change directory to "/home/rudyj/Desktop/Claude/PPPPdev": Permission denied
#   psql (14.22 (Ubuntu 14.22-0ubuntu0.22.04.1))
#   Type "help" for help.

sudo -u postgres psql -A -t -c "SELECT usename, usesuper, usecreatedb, rolcanlogin FROM pg_roles WHERE usename='ppp_user';"
sudo -u postgres psql -A -t -c "SELECT datname, pg_catalog.pg_get_userbyid(datdba) FROM pg_database WHERE datname='users_db';"
sudo -u postgres psql -A -t -c "SHOW hba_file;"