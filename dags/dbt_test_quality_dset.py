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
# dbt test quality

Runs dbt test on the jardiner models and store failures so that they
can be viewed in the dbt docs and observability dashboards in superset.

As a second step, it sends the elementary EDR report to a
minio bucket to be served as a static web page.
"""

args = {
    "email": my_email,
    "email_on_failure": True,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=10),
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
        "password": (
            urllib.parse.unquote(parsed_string.password)
            if parsed_string.password
            else None
        ),
        "host": parsed_string.hostname,
        "port": parsed_string.port,
        "database": parsed_string.path[1:],
    }


with DAG(
    dag_id="dbt_test_dset_quality_v2",
    start_date=datetime(2023, 12, 1, 0, 0, 0),
    schedule_interval="0 3 * * *",
    catchup=False,
    tags=[
        "project:plantmonitor",
        "project:jardiner",
        "dbt-test",
        "dbt",
        "data-quality",
    ],
    default_args=args,
    doc_md=__doc__,
) as dag:
    repo_name = "somenergia-jardiner"

    sampled_moll = get_random_moll()

    dbapi = Variable.get("plantmonitor_db")

    dbapi_dict = dbapi_to_dict(dbapi)

    s3_bucket_name = Variable.get(
        "somenergia_jardiner_edr_s3_bucket_name",
        default_var="som-jardiner-elementary-reports",
    )

    s3_access_key = Variable.get(
        "somenergia_jardiner_edr_s3_access_key",
        default_var="jardiner_edr_reports",
    )

    s3_secret_key = Variable.get("somenergia_jardiner_edr_s3_secret_key")

    s3_endpoint = Variable.get(
        "somenergia_jardiner_edr_s3_endpoint",
        default_var="https://minio.somenergia.coop",
    )

    environment = {
        "DBUSER": dbapi_dict["user"],
        "DBPASSWORD": dbapi_dict["password"],
        "DBHOST": dbapi_dict["host"],
        "DBPORT": dbapi_dict["port"],
        "DBNAME": dbapi_dict["database"],
        "S3_BUCKET_NAME": s3_bucket_name,
        "S3_ACCESS_KEY": s3_access_key,
        "S3_SECRET_KEY": s3_secret_key,
        "S3_ENDPOINT": s3_endpoint,
        "DBT_PACKAGES_INSTALL_PATH": "/home/somenergia/.dbt/dbt_packages",
        "DBT_PROFILES_DIR": "/repos/somenergia-jardiner/dbt_jardiner/config",
        "DBT_PROJECT_DIR": "/repos/somenergia-jardiner/dbt_jardiner",
    }

    image = "harbor.somenergia.coop/dades/somenergia-jardiner-dbt-deps:latest"

    dbt_test_command = (
        "dbt test"
        " --profiles-dir config"
        " --target prod"
        " --select tag:jardiner elementary"
        " --store-failures"
        " --threads 4"
    )

    dbt_test_task = DockerOperator(
        api_version="auto",
        task_id="dbt_test_task",
        environment=environment,
        docker_conn_id="somenergia_harbor_dades_registry",
        image=image,
        working_dir=f"/repos/{repo_name}/dbt_jardiner",
        command=dbt_test_command,
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
        force_pull=True,
    )

    edr_command = [
        "/bin/sh",
        "-c",
        (
            "edr send-report"
            " --profiles-dir config"
            " --env prod"
            " --days-back 7"
            " --project-profile-target prod"
            " --profile-target prod"
            ' --aws-access-key-id "$S3_ACCESS_KEY"'
            ' --aws-secret-access-key "$S3_SECRET_KEY"'
            ' --s3-endpoint-url "$S3_ENDPOINT"'
            ' --s3-bucket-name "$S3_BUCKET_NAME"'
            " --project-name jardiner"
            " --target-path /tmp/"
            " --bucket-file-path index.html"
        ),
    ]

    edr_report_command = DockerOperator(
        api_version="auto",
        task_id="edr_report_command",
        environment=environment,
        docker_conn_id="somenergia_harbor_dades_registry",
        image=image,
        working_dir=f"/repos/{repo_name}/dbt_jardiner",
        entrypoint=[""],
        command=edr_command,
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="all_done",
        force_pull=True,
    )

    dbt_test_task >> edr_report_command
