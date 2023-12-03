import random
import urllib.parse
from datetime import datetime, timedelta

from airflow import DAG
from airflow.models import Variable
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import DriverConfig, Mount

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")

__doc__ = """
# dbt test dset quality

Runs dbt test on the dset models every 3 days and store failures so that they
can be viewed in the dbt docs and observability dashboards in superset.
"""

args = {
    "email": my_email,
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 3,
    "retry_delay": timedelta(minutes=30),
}

nfs_config = {
    "type": "nfs",
    "o": f"addr={addr},nfsvers=4",
    "device": ":/opt/airflow/repos",
}


def get_random_moll() -> str:
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
    dag_id="dbt_test_dset_quality_v1",
    start_date=datetime(2023, 12, 1, 0, 0, 0),
    schedule_interval="0 1 */3 * *",
    catchup=False,
    tags=["Plantmonitor", "Jardiner", "test", "dbt", "data_quality"],
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

    image = "harbor.somenergia.coop/dades/somenergia-jardiner-dbt-docs:latest"
    command = (
        "dbt test"
        " --profiles-dir config"
        " --target prod"
        " --select tag:dset"
        " --store-failures"
    )

    dbt_test_task = DockerOperator(
        api_version="auto",
        task_id="dbt_test_task",
        environment=environment,
        docker_conn_id="somenergia_harbor_dades_registry",
        image=image,
        working_dir=f"/repos/{repo_name}/dbt_jardiner",
        command=command,
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
        force_pull=True,
    )
