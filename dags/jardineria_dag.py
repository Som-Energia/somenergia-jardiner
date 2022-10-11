from airflow import DAG
from datetime import timedelta
from airflow.providers.docker.operators.docker import DockerOperator
from util_tasks.t_branch_pull_ssh import build_branch_pull_ssh_task
from util_tasks.t_git_clone_ssh import build_git_clone_ssh_task
from util_tasks.t_check_repo import build_check_repo_task
from util_tasks.t_image_build import build_image_build_task
from util_tasks.t_remove_image import build_remove_image_task
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
  'retries': 5,
  'retry_delay': timedelta(minutes=5),
}


nfs_config = {
    'type': 'nfs',
    'o': f'addr={addr},nfsvers=4',
    'device': ':/opt/airflow/repos'
}

driver_config = DriverConfig(name='local', options=nfs_config)
mount_nfs = Mount(source="local", target="/repos", type="volume", driver_config=driver_config)


with DAG(dag_id='jardiner_dag', start_date=datetime(2022,9,26), schedule_interval='@hourly', catchup=False, tags=["Plantmonitor", "Jardiner"], default_args=args) as dag:

    repo_github_name = 'somenergia-jardiner'

    task_branch_pull_ssh = build_branch_pull_ssh_task(dag=dag, task_name='jardineria', repo_github_name=repo_github_name)
    task_git_clone = build_git_clone_ssh_task(dag=dag, repo_github_name=repo_github_name)
    task_check_repo = build_check_repo_task(dag=dag, repo_github_name=repo_github_name)
    task_image_build = build_image_build_task(dag=dag, repo_github_name=repo_github_name)
    task_remove_image = build_remove_image_task(dag=dag, repo_github_name=repo_github_name)

    notify_alarms_task = DockerOperator(
        api_version='auto',
        task_id='jardineria',
        image=f'{repo_github_name}-requirements:latest',
        working_dir=f'/repos/{repo_github_name}',
        command='python3 -m jardiner.notify_alarms "{{ data_interval_start }}" "{{ data_interval_end }}" "{{ var.value.plantmonitor_prod_db }}"\
                "{{ var.value.notifier_smtp_url }}" "{{ var.value.notifier_smtp_port }}" "{{ var.value.notifier_smtp_user }}" "{{ var.value.notifier_smtp_password }}"',
        docker_url=Variable.get("moll_url"),
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule='none_failed',
    )

    task_check_repo >> task_git_clone
    task_check_repo >> task_branch_pull_ssh
    task_git_clone >> task_image_build
    task_branch_pull_ssh >> notify_alarms_task
    task_branch_pull_ssh >> task_remove_image
    task_remove_image >> task_image_build >> notify_alarms_task