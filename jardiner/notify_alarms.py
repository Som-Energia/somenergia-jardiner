import typer
import logging

from datetime import datetime

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

app = typer.Typer()

def get_config(dbapi_argument):
    if dbapi_argument == 'prod':
        return dotenv_values(".env.prod")
    elif dbapi_argument == 'pre':
        return dotenv_values(".env.pre")
    else:
        return dbapi_argument

@app.command()
def notify_alarms(
        data_interval_start : datetime,
        data_interval_end: datetime,
        plantmonitor_prod_db: str,
        novu_url: str,
        api_key: str
    ):
    logging.info(f"Got {novu_url} and {api_key}")
    dbapi = get_config(plantmonitor_prod_db)

if __name__ == '__main__':
  app()