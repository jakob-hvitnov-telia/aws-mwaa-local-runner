#!/bin/sh

echo "Running custom startup script."

# Oracle client from plugins for thick mode
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/airflow/plugins/instantclient_21_10

# dbt global config
export DO_NOT_TRACK=1
export DBT_USE_COLORS=False

# dbt environments
if ! [[ "${MWAA_AIRFLOW_COMPONENT}" =~ ^(scheduler|webserver)$ ]]; then
    echo "Installing dbt"
    export DBT_VENV_PATH_1_5="/tmp/venv/dbt-1.5"
    /usr/bin/python3 -m venv ${DBT_VENV_PATH_1_5}
    ${DBT_VENV_PATH_1_5}/bin/pip install dbt-snowflake~=1.5.1
    # Keep this until there are still DAGs using this variable
    export DBT_VENV_PATH=${DBT_VENV_PATH_1_5}
fi