import random
from datetime import datetime, timedelta

from airflow import DAG
from airflow.models import Variable
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import DriverConfig, Mount

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")

smtp = dict(
    host=Variable.get("notifier_smtp_url"),
    port=Variable.get("notifier_smtp_port"),
    user=Variable.get("notifier_smtp_user"),
    password=Variable.get("notifier_smtp_password"),
)

args = {
    "email": my_email,
    "email_on_failure": True,
    "email_on_retry": False,
    "retries": 0,
    "retry_delay": timedelta(minutes=5),
}


nfs_config = {
    "type": "nfs",
    "o": f"addr={addr},nfsvers=4",
    "device": ":/opt/airflow/repos",
}


def get_random_moll():
    available_molls = Variable.get("available_molls").split()
    # trunk-ignore(bandit/B311)
    return random.choice(available_molls)


driver_config = DriverConfig(name="local", options=nfs_config)
mount_nfs = Mount(
    source="local", target="/repos", type="volume", driver_config=driver_config
)


with DAG(
    dag_id="plant_alerts",
    start_date=datetime(2022, 11, 17),
    schedule_interval="3-59/5 * * * *",
    catchup=False,
    tags=["Plantmonitor", "Jardiner"],
    max_active_runs=1,
    default_args=args,
) as dag:
    repo_name = "somenergia-jardiner"

    sampled_moll = get_random_moll()

    alert_meter_no_readings_task = DockerOperator(
        api_version="auto",
        task_id="alert_meter_no_readings",
        docker_conn_id="somenergia_harbor_dades_registry",
        image="{}/{}-app:latest".format(
            "{{ conn.somenergia_harbor_dades_registry.host }}", repo_name
        ),
        working_dir=f"/repos/{repo_name}",
        command=(
            "python3 -m scripts.notify_alert"
            " {{ var.value.plantmonitor_db }}"
            " {{ var.value.novu_base_url }}"
            " {{ var.value.novu_api_key }}"
            " {{ var.value.plantmonitor_db_prod_schema }}"
            " alert_meter_no_readings True"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
    )

    alert_inverter_zero_power_task = DockerOperator(
        api_version="auto",
        task_id="alert_inverter_zero_power",
        docker_conn_id="somenergia_harbor_dades_registry",
        image="{}/{}-app:latest".format(
            "{{ conn.somenergia_harbor_dades_registry.host }}", repo_name
        ),
        working_dir=f"/repos/{repo_name}",
        command=(
            "python3 -m scripts.notify_alert "
            " {{ var.value.plantmonitor_db }}"
            " {{ var.value.novu_base_url }}"
            " {{ var.value.novu_api_key }}"
            " {{ var.value.plantmonitor_db_prod_schema }}"
            " alert_inverter_zero_power_at_daylight True"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
    )

    alert_meter_zero_energy_task = DockerOperator(
        api_version="auto",
        task_id="alert_meter_zero_energy",
        docker_conn_id="somenergia_harbor_dades_registry",
        image="{}/{}-app:latest".format(
            "{{ conn.somenergia_harbor_dades_registry.host }}", repo_name
        ),
        working_dir=f"/repos/{repo_name}",
        command=(
            "python3 -m scripts.notify_alert"
            " {{ var.value.plantmonitor_db }}"
            " {{ var.value.novu_base_url }}"
            " {{ var.value.novu_api_key }}"
            " {{ var.value.plantmonitor_db_prod_schema }}"
            " alert_meter_zero_energy True"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
    )

    alert_inverter_temperature_task = DockerOperator(
        api_version="auto",
        task_id="alert_inverter_temperature",
        docker_conn_id="somenergia_harbor_dades_registry",
        image="{}/{}-app:latest".format(
            "{{ conn.somenergia_harbor_dades_registry.host }}", repo_name
        ),
        working_dir=f"/repos/{repo_name}",
        command=(
            "python3 -m scripts.notify_alert"
            " {{ var.value.plantmonitor_db }}"
            " {{ var.value.novu_base_url }}"
            " {{ var.value.novu_api_key }}"
            " {{ var.value.plantmonitor_db_prod_schema }}"
            " alert_inverter_temperature False"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
    )

    alert_inverter_interinverter_relative_temperature_task = DockerOperator(
        api_version="auto",
        task_id="alert_inverter_interinverter_relative_temperature",
        docker_conn_id="somenergia_harbor_dades_registry",
        image="{}/{}-app:latest".format(
            "{{ conn.somenergia_harbor_dades_registry.host }}",
            repo_name,
        ),
        working_dir=f"/repos/{repo_name}",
        command=(
            "python3 -m scripts.notify_alert "
            " {{ var.value.plantmonitor_db }}"
            " {{ var.value.novu_base_url }}"
            " {{ var.value.novu_api_key }}"
            " {{ var.value.plantmonitor_db_prod_schema }}"
            " alert_inverter_interinverter_relative_temperature False"
        ),
        docker_url=sampled_moll,
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule="none_failed",
    )
