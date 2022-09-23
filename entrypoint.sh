#!/bin/sh

export USERNAME="admin"
export PASSWORD="test1234"
export PORT=8080

function init_airflow {
  # make sure the db folder exists
  mkdir -p /app/airflow/db

  # Init the airflow db
  airflow db init
  airflow db upgrade || true

  # Create an admin user
  airflow users create \
      --username ${USERNAME} \
      --password ${PASSWORD} \
      --firstname Admin \
      --lastname Super \
      --role Admin \
      --email admin@admin.com

  # Airdlow parallelism
  echo "Default parallelism set to 4"
  sed -i "s/parallelism = .*/parallelism = 4/" /app/airflow/airflow.cfg

  # Log fetching timeout
  sed -i "s/log_fetch_timeout_sec = .*/log_fetch_timeout_sec = 10/" /app/airflow/airflow.cfg
  echo "Setting the log fetch timeout to"
  grep "log_fetch_timeout_sec" /app/airflow/airflow.cfg
}


function final_init {
  # Remove examples
  sed -i "s/load_examples = .*/load_examples = False/" /app/airflow/airflow.cfg
  sed -i "s/load_default_connections = .*/load_default_connections = False/" /app/airflow/airflow.cfg
  
  # API access
  sed -i "s/auth_backend = .*/auth_backend = airflow.api.auth.backend.basic_auth/" /app/airflow/airflow.cfg
}


if [[ $# -eq 0 ]]; then
    echo "Running airflow scheduler on background & webserver on port ${PORT}"
    init_airflow
    final_init
    ( airflow scheduler & ) && airflow webserver --port ${PORT}
else
    echo "No arguments needed on script"
    exit 1
fi
