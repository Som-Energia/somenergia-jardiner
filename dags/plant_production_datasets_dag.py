from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from util_tasks.t_branch_pull_ssh import build_branch_pull_ssh_task
from util_tasks.t_git_clone_ssh import build_git_clone_ssh_task
from util_tasks.t_check_repo import build_check_repo_task
from util_tasks.t_update_docker_image import build_update_image_task
from docker.types import Mount, DriverConfig
from datetime import datetime, timedelta
from airflow.models import Variable

import urllib.parse

my_email = Variable.get("fail_email")
addr = Variable.get("repo_server_url")


args= {
  'email': my_email,
  'email_on_failure': True,
  'email_on_retry': True,
  'retries': 3,
  'retry_delay': timedelta(minutes=30),
}

nfs_config = {
    'type': 'nfs',
    'o': f'addr={addr},nfsvers=4',
    'device': ':/opt/airflow/repos'
}

driver_config = DriverConfig(name='local', options=nfs_config)
mount_nfs = Mount(source="local", target="/repos", type="volume", driver_config=driver_config)

def dbapi_to_dict(dbapi: str):
    parsed_string = urllib.parse.urlparse(dbapi)

    return {
        "provider": parsed_string.scheme,
        "user": parsed_string.username,
        "password": urllib.parse.unquote(parsed_string.password) if parsed_string.password else None,
        "host": parsed_string.hostname,
        "port": parsed_string.port,
        "database": parsed_string.path[1:]
    }

with DAG(dag_id='plant_production_datasets_v3', start_date=datetime(2023,1,10), schedule_interval='@daily', catchup=False, tags=["Plantmonitor","Jardiner", "Transform", "DBT"], default_args=args) as dag:

    repo_name = 'somenergia-jardiner'

    task_check_repo = build_check_repo_task(dag=dag, repo_name=repo_name)
    task_git_clone = build_git_clone_ssh_task(dag=dag, repo_name=repo_name)
    task_branch_pull_ssh = build_branch_pull_ssh_task(dag=dag, task_name='dbt_deps_task', repo_name=repo_name)
    task_update_image = build_update_image_task(dag=dag, repo_name=repo_name)


    dbapi = '{}'.format(Variable.get("plantmonitor_db"))

    dbapi_dict = dbapi_to_dict('{}'.format('{{ var.value.plantmonitor_db }}'))

    environment = {
        'DBUSER': dbapi_dict['user'],
        'DBPASSWORD': dbapi_dict['password'],
        'DBHOST': dbapi_dict['host'],
        'DBPORT': dbapi_dict['port'],
        'DBNAME': dbapi_dict['database']
    }

    dbt_deps_task = DockerOperator(
        api_version='auto',
        task_id='dbt_deps_task',
        docker_conn_id='somenergia_registry',
        environment=environment,
        image='{}/{}-requirements:latest'.format('{{ conn.somenergia_registry.host }}', repo_name),
        working_dir=f'/repos/{repo_name}/dbt_jardiner',
        command='dbt deps --profiles-dir config',
        docker_url=Variable.get("generic_moll_url"),
        mounts=[mount_nfs],
        mount_tmp_dir=False,
        auto_remove=True,
        retrieve_output=True,
        trigger_rule='none_failed',
    )

    dbt_transformation_task = DockerOperator(
        api_version='auto',
        task_id='dbt_transformation_task',
        docker_conn_id='somenergia_registry',
        environment=environment,
        image='{}/{}-requirements:latest'.format('{{ conn.somenergia_registry.host }}', repo_name),
        working_dir=f'/repos/{repo_name}/dbt_jardiner',
        command='dbt run --profiles-dir config --target pro --select plant_production_hourly+',
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
    task_branch_pull_ssh >> dbt_deps_task
    task_branch_pull_ssh >> task_update_image
    task_update_image >> dbt_deps_task
    dbt_deps_task >> dbt_transformation_task
