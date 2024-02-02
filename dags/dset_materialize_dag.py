import random
import urllib.parse
from datetime import datetime, timedelta

from airflow import DAG
from airflow.models import Variable
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import DriverConfig, Mount

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")


args = {
    "email": my_email,
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
}

nfs_config = {
    "type": "nfs",
    "o": f"addr={addr},nfsvers=4",
    "device": ":/opt/airflow/repos",
}

__doc__ = """
# Executes dbt run on an incremental model, hourly

This dag will update an incremental model in the dbt jardiner project.

Warning: Note that views and other dbt dependencies need to exist beforehand
so that model can be succesfully executed.
"""


def get_random_moll():
    available_molls = Variable.get("available_molls").split()
    # trunk-ignore(bandit/B311)
    return random.choice(available_molls)


driver_config = DriverConfig(name="local", options=nfs_config)
mount_nfs = Mount(
    source="local", target="/repos", type="volume", driver_config=driver_config
)


def dbapi_to_dict(dbapi: str):
    parsed_string = urllib.parse.urlparse(dbapi)

    return {
        "provider": parsed_string.scheme,
        "user": parsed_string.username,
        "password": urllib.parse.unquote(parsed_string.password)
        if parsed_string.password
        else None,
        "host": parsed_string.hostname,
        "port": parsed_string.port,
        "database": parsed_string.path[1:],
    }


with DAG(
    dag_id="dset_materialize_dag",
    start_date=datetime(2023, 1, 10),
    schedule_interval="8/5 * * * *",
    catchup=False,
    tags=["scope:Plantmonitor", "scope:Jardiner", "dbt", "source:DSET"],
    max_active_runs=1,
    default_args=args,
    doc_md=__doc__,
) as dag:
    repo_name = "somenergia-jardiner"

    sampled_moll = get_random_moll()

    dbapi = Variable.get("plantmonitor_db")

    dbapi_dict = dbapi_to_dict(dbapi)

    environment = {
        "DBUSER": dbapi_dict["user"],
        "DBPASSWORD": dbapi_dict["password"],
        "DBHOST": dbapi_dict["host"],
        "DBPORT": dbapi_dict["port"],
        "DBNAME": dbapi_dict["database"],
    }

    dbt_transformation_task = DockerOperator(
        api_version="auto",
        task_id="dbt_transformation_task__dset_materialization",
        environment=environment,
        docker_conn_id="somenergia_harbor_dades_registry",
        image=f"harbor.somenergia.coop/dades/{repo_name}-dbt-docs:latest",
        working_dir=f"/repos/{repo_name}/dbt_jardiner",
        command=(
            "dbt run"
            " --profiles-dir config"
            " --target prod"
            " --select tag:dset_responses_fresh"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
        force_pull=True,
    )
