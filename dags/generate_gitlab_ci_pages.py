import datetime as dt

from airflow import DAG
from airflow.models import Variable
from airflow.operators.bash import BashOperator

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
    "retries": 5,
    "retry_delay": dt.timedelta(minutes=5),
}


with DAG(
    dag_id="jardiner_generate_gitlab_ci_pages",
    schedule_interval="@daily",
    start_date=dt.datetime(2023, 9, 27),
    catchup=False,
    dagrun_timeout=dt.timedelta(minutes=10),
    tags=[
        "project:jardiner",
        "gitlab-ci",
        "gitlab-pages",
        "experimental",
    ],
    max_active_runs=1,
) as dag:
    TOKEN = Variable.get("GITLAB_CI_TOKEN_JARDINER_PAGES")
    REF = "main"
    PROJECT_ID = 69

    trigger_task_pages = BashOperator(
        task_id="trigger_task_pages",
        bash_command=(
            f"curl -X POST -v "
            f"-F token={TOKEN} -F ref={REF} -F variables[CI_TRIGGER_TASK_NAME]=pages "
            f"https://gitlab.somenergia.coop/api/v4/projects/{PROJECT_ID}/trigger/pipeline"
        ),
    )
