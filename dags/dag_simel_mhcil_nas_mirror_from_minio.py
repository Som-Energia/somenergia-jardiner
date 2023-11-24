import datetime as dt
import random

from airflow import DAG
from airflow.models import Variable
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import DriverConfig, Mount

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")


__doc__ = """
# Mirror directory from NAS to minio.somenergia.coop for MHCIL Files

## Purpose
Executes a docker container that uses the minio client, to mirror a
directory from the NAS to Minio, for loading into Airbyte later.
"""

args = {
    "email": my_email,
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 3,
    "retry_delay": dt.timedelta(minutes=5),
}


# mount NAS volume on the docker container at /mercat-electric
mercat_electric_driver = DriverConfig(name="local", options={})
mount_mercat_electric = Mount(
    source="mercat-johnny",
    target="/mercat-electric",
    type="volume",
    driver_config=mercat_electric_driver,
)


def get_random_moll():
    available_molls = Variable.get("available_molls").split()
    # trunk-ignore(bandit/B311)
    return random.choice(available_molls)


with DAG(
    dag_id="dag_simel_mhcil_nas_mirror_from_minio_v1",
    start_date=dt.datetime(2023, 1, 10),
    schedule_interval="@daily",
    catchup=False,
    tags=[
        "curve:MHCIL",
        "scope:Jardiner",
        "scope:Mercat",
        "ingesta:historic",
        "ingesta:minio",
        "source:SIMEL",
        "source:NAS",
    ],
    default_args=args,
) as dag:
    sampled_moll = get_random_moll()

    environment = {
        "MINIO_HOST": Variable.get("MINIO_SOM_HOST"),
        "MINIO_ACCESS_KEY": Variable.get("MINIO_SOM_AIRBYTE_ACCESS_KEY"),
        "MINIO_SECRET_KEY": Variable.get("MINIO_SOM_AIRBYTE_SECRET_KEY"),
    }

    MINIO_ALIAS = "minio_som"
    MIRROR_ORIG_PATH = "/mercat-electric/20_SIMEL/1394_pen/MHCIL"
    MIRROR_DEST_PATH = f"{MINIO_ALIAS}/simel-mhcil-nas"

    cmd = [
        "/bin/sh",
        "-c",
        (
            f'mc alias set {MINIO_ALIAS} "$MINIO_HOST" "$MINIO_ACCESS_KEY" "$MINIO_SECRET_KEY"'  # noqa
            f" && mc mirror {MIRROR_ORIG_PATH} {MIRROR_DEST_PATH}"
        ),
    ]

    mc_mirror_task = DockerOperator(
        api_version="auto",
        task_id="mc_mirror_task",
        environment=environment,
        docker_conn_id="somenergia_harbor_dades_registry",
        image="minio/mc:latest",
        entrypoint=[""],
        command=cmd,
        docker_url=sampled_moll,
        mounts=[mount_mercat_electric],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
        force_pull=True,
    )
