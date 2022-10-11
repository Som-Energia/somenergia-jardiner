import logging
import typer
from datetime import datetime
import sqlalchemy

from jardiner.jardiner_utils import get_config
from jardiner.jardineria import get_alarms


logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

app = typer.Typer()

@app.command()
def notify_alarms(
        data_interval_start : datetime,
        data_interval_end: datetime,
        plantmonitor_db: str,
        novu_url: str,
        api_key: str
    ):
    logging.info(f"Got {novu_url} and {api_key}")
    dbapi = get_config(plantmonitor_db)
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        alarms = get_alarms(conn)
        for alarm in alarms:
            logging.debug(f"Alarm {alarm}")

if __name__ == '__main__':
  app()