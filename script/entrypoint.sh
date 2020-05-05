#!/usr/bin/env bash

TRY_LOOP="20"

# Defaults and back-compat
: "${AIRFLOW_HOME:="/usr/local/airflow"}"
: "${AIRFLOW__CORE__FERNET_KEY:=${FERNET_KEY:=$(python3 -c "from cryptography.fernet import Fernet; FERNET_KEY = Fernet.generate_key().decode(); print(FERNET_KEY)")}}"
: "${AIRFLOW__CORE__EXECUTOR:=${EXECUTOR:-Sequential}Executor}"

export \
  AIRFLOW_HOME \
  AIRFLOW__CELERY__BROKER_URL \
  AIRFLOW__CELERY__RESULT_BACKEND \
  AIRFLOW__CORE__EXECUTOR \
  AIRFLOW__CORE__FERNET_KEY \
  AIRFLOW__CORE__LOAD_EXAMPLES \
  AIRFLOW__CORE__SQL_ALCHEMY_CONN \

# Load DAGs exemples (default: Yes)
if [[ -z "$AIRFLOW__CORE__LOAD_EXAMPLES" && "${LOAD_EX:=n}" == n ]]
then
  AIRFLOW__CORE__LOAD_EXAMPLES=False
fi

wait_for_port() {
  local name="$1" host="$2" port="$3"
  local j=0
  while ! nc -z "$host" "$port" >/dev/null 2>&1 < /dev/null; do
    j=$((j+1))
    if [ $j -ge $TRY_LOOP ]; then
      echo >&2 "$(date) - $host:$port still not reachable, giving up"
      exit 1
    fi
    echo "$(date) - waiting for $name... $j/$TRY_LOOP"
    sleep 5
  done
}

case "$1" in
  webserver)
    airflow initdb
    exec airflow webserver
    ;;
  scheduler)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow scheduler
    ;;
  worker)
    # To give the webserver time to run initdb.
    sleep 10
    exec airflow worker
    ;;
  flower)
    sleep 10
    exec airflow "$@"
    ;;
esac

