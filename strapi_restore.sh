
export "PGUSER=postgres"
export "PGPASSWORD=4HrPwpGnYHTyqrVu"
export "STRAPIDB=strapi-dev"
export "STRAPIDBNEW=strapi-dev-new"
export "STRAPIDBLEGACY=strapi-dev-legacy$(date +%s)"
export "HOST=wexl-nonprod-psql-db01.wexl.in"

# Strapi
# Create an new database
# Restore database
# Terminate all connections
# Switch databases
# Grant usage
#addr='/home/vsts/work/r1/a/+$(filename)'
#echo addr is $addr

psql -U $PGUSER -d $STRAPIDB -h $HOST -U $PGUSER -c "create database \"$STRAPIDBNEW\""

export "PGPASSWORD=bsCCtRS7DLL84D39"
export "STRAPIUSER=strapi-admin"

pg_restore -d $STRAPIDBNEW -h $HOST -Fc -U $STRAPIUSER --clean --if-exists /home/samdani/Downloads/2022-11-23-at-12-00-01_strapi_prod.dump

export "PGPASSWORD=4HrPwpGnYHTyqrVu"

psql -U $PGUSER -d $STRAPIDBNEW -h $HOST -U $PGUSER -c "SELECT pg_terminate_backend( pid )
														FROM pg_stat_activity
														WHERE pid <> pg_backend_pid( )
														    AND datname = '$STRAPIDB';
														ALTER DATABASE \"$STRAPIDB\" RENAME TO \"$STRAPIDBLEGACY\";"
psql -U $PGUSER -d $STRAPIDBLEGACY -h $HOST -U $PGUSER -c "ALTER DATABASE \"$STRAPIDBNEW\" RENAME TO \"$STRAPIDB\";"
psql -U $PGUSER -d $PGUSER -h $HOST -U $PGUSER -c "GRANT ALL ON SCHEMA public TO \"strapi-admin\";
