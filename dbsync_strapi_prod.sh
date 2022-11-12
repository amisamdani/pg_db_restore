#!/bin/bash

: '
	authored by: Krishna
'

export "PGUSER=postgres"
export "PGPASSWORD=4HrPwpGnYHTyqrVu"
export "RETAILDB=wexl_dev"
export "RETAILDBNEW=wexl_dev-new"
export "RETAILDBLEGACY=wexl_dev-legacy-$(date +%s)"
export "STRAPIDB=strapi-dev"
export "STRAPIDBNEW=strapi-dev-new"
export "STRAPIDBLEGACY=strapi-dev-legacy$(date +%s)"
export "HOST=wexl-nonprod-psql-db01.wexl.in"

# Retail Steps:
# Create a new database 
# Restore database
# Terminate all connections 
# Switch database
# Grant usage 

#-psql -U $PGUSER -d $RETAILDB -h $HOST -U $PGUSER -c "create database \"$RETAILDBNEW\""
#-pg_restore -d $RETAILDBNEW -h $HOST -Fc -U $PGUSER --clean --if-exists $HOME/Desktop/db_backup/wexl_prod.dump
#-psql -U $PGUSER -d $RETAILDBNEW -h $HOST -U $PGUSER -c "SELECT pg_terminate_backend( pid )
#-														FROM pg_stat_activity
#-														WHERE pid <> pg_backend_pid( )
#-														    AND datname = '$RETAILDB';
#-														ALTER DATABASE \"$RETAILDB\" RENAME TO \"$RETAILDBLEGACY\";"
#-
#-psql -U $PGUSER -d $RETAILDBLEGACY -h $HOST -U $PGUSER -c	"ALTER DATABASE \"$RETAILDBNEW\" RENAME TO \"$RETAILDB\";"
#-psql -U $PGUSER -d $RETAILDB -h $HOST -U $PGUSER -c "GRANT ALL ON DATABASE wexl_dev TO wexl_app_admin;"
#-psql -U $PGUSER -d $RETAILDB -h $HOST -U $PGUSER -c "GRANT USAGE ON SCHEMA PUBLIC TO fdwretailuser;"
#-psql -U $PGUSER -d $RETAILDB -h $HOST -U $PGUSER -c "GRANT SELECT ON ALL TABLES IN SCHEMA PUBLIC TO fdwretailuser;"

# Strapi
# Create an new database
# Restore database
# Terminate all connections
# Switch databases
# Grant usage

psql -U $PGUSER -d $RETAILDB -h $HOST -U $PGUSER -c "create database \"$STRAPIDBNEW\""

export "PGPASSWORD=bsCCtRS7DLL84D39"
export "STRAPIUSER=strapi-admin"

pg_restore -d $STRAPIDBNEW -h $HOST -Fc -U $STRAPIUSER --clean --if-exists $HOME/Desktop/db_backup/strapi_prod.dump

export "PGPASSWORD=4HrPwpGnYHTyqrVu"
psql -U $PGUSER -d $STRAPIDBNEW -h $HOST -U $PGUSER -c "SELECT pg_terminate_backend( pid )
														FROM pg_stat_activity
														WHERE pid <> pg_backend_pid( )
														    AND datname = '$STRAPIDB';
														ALTER DATABASE \"$STRAPIDB\" RENAME TO \"$STRAPIDBLEGACY\";"
psql -U $PGUSER -d $STRAPIDBLEGACY -h $HOST -U $PGUSER -c "ALTER DATABASE \"$STRAPIDBNEW\" RENAME TO \"$STRAPIDB\";"
psql -U $PGUSER -d $PGUSER -h $HOST -U $PGUSER -c "GRANT ALL ON SCHEMA public TO \"strapi-admin\";"
