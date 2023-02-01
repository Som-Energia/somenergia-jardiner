from airflow import DAG
from datetime import timedelta
from airflow.providers.docker.operators.docker import DockerOperator
from util_tasks.t_branch_pull_ssh import build_branch_pull_ssh_task
from util_tasks.t_git_clone_ssh import build_git_clone_ssh_task
from util_tasks.t_check_repo import build_check_repo_task
from util_tasks.t_update_docker_image import build_update_image_task
from docker.types import Mount, DriverConfig
from datetime import datetime, timedelta
from airflow.models import Variable

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")

smtp=dict(
    host=Variable.get("notifier_smtp_url"),
    port=Variable.get("notifier_smtp_port"),
    user=Variable.get("notifier_smtp_user"),
    password=Variable.get("notifier_smtp_password"),
)

args= {
  'email': my_email,
  'email_on_failure': True,
  'email_on_retry': False,
  'retries': 0,
  'retry_delay': timedelta(minutes=5),
}


nfs_config = {
    'type': 'nfs',
    'o': f'addr={addr},nfsvers=4',
    'device': ':/opt/airflow/repos'
}

driver_config = DriverConfig(name='local', options=nfs_config)
mount_nfs = Mount(source="local", target="/repos", type="volume", driver_config=driver_config)


with DAG(dag_id='alert_inverter_interinverter_relative_temperature_v2', start_date=datetime(2022,11,17), schedule_interval='3-59/5 * * * *', catchup=False, tags=["Plantmonitor", "Jardiner"], default_args=args) as dag:

    repo_name = 'somenergia-jardiner'

    task_check_repo = build_check_repo_task(dag=dag, repo_name=repo_name)
    task_git_clone = build_git_clone_ssh_task(dag=dag, repo_name=repo_name)
    task_branch_pull_ssh = build_branch_pull_ssh_task(dag=dag, task_name='alert_inverter_interinverter_relative_temperature', repo_name=repo_name)
    task_update_image = build_update_image_task(dag=dag, repo_name=repo_name)

    notify_alarms_task = DockerOperator(
        api_version='auto',
        task_id='alert_inverter_interinverter_relative_temperature',
        docker_conn_id='somenergia_registry',
        image='{}/{}-requirements:latest'.format('{{ conn.somenergia_registry.host }}', repo_name),
        working_dir=f'/repos/{repo_name}',
        command='python3 -m scripts.notify_alert "{{ var.value.plantmonitor_db }}"\
                "{{ var.value.novu_url }}" "{{ var.value.novu_api_key }}" "{{ var.value.plantmonitor_db_prod_schema }}" alert_inverter_interinverter_relative_temperature False',
        docker_url=Variable.get("generic_moll_url"),
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule='none_failed',
    )

    task_check_repo >> task_git_clone
    task_check_repo >> task_branch_pull_ssh
    task_git_clone >> task_update_image
    task_branch_pull_ssh >> notify_alarms_task
    task_branch_pull_ssh >> task_update_image
    task_update_image >> notify_alarms_task