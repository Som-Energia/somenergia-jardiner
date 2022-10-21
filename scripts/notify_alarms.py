import logging
import typer
from datetime import datetime
import sqlalchemy
import pandas as pd
from jardiner.notification import notify

from jardiner.jardiner_utils import get_config
from jardiner.jardineria import get_alarms


logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

app = typer.Typer()

@app.command()
def get_alarms_to_notify(
        plantmonitor_db: str,
        novu_url: str,
        api_key: str,
        schema: str,
    ):
    logging.info(f"Got {novu_url} and {api_key}")
    dbapi = get_config(plantmonitor_db) # dbapi = plantmonitor_db when run by airflow
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        alarms = pd.read_sql_table('alarm_current_alarmed', conn, schema=schema)

    if alarms.shape[0] == 0:
        logging.info(f"No new alarms. {alarms}.")
        return

    alarms['day'] = alarms['day'].dt.strftime("%Y-%m-%d")
    alarms_payload = alarms.to_dict(orient='records')
    return notify(novu_url, api_key, alarms_payload)



if __name__ == '__main__':
  app()