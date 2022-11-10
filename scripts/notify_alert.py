import logging
import requests
import typer
from datetime import datetime
import sqlalchemy
import pandas as pd

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

app = typer.Typer()

def notify(url, api_key, payload, email):
    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "name": "alertes-del-jardi",
        "to":  {
            "subscriberId": "recipient",
            "email": email
        },
        "payload": {
            'alarms': payload
        }
    }

    response = requests.post(url,headers=headers, json=data)
    logging.info(response.text)
    response.raise_for_status()

    return response

@app.command()
def get_alarms_to_notify(
        plantmonitor_db: str,
        novu_url: str,
        api_key: str,
        schema: str,
        reciver_email: str,
        alert: str
    ):
    logging.info(f"Got {novu_url} and {api_key}")
    alertdf = pd.read_sql_table(alert, plantmonitor_db, schema=schema)
    alertdf = alertdf[alertdf['is_alarmed'] == True]
    alertjson = alertdf.to_json(orient='table')

    if len(alertdf) > 0:
        #notify(novu_url, api_key, alertjson, reciver_email)
        logging.info(f"Alert {alert} notifed.")

        delete(taula_already_Notified - alertdf)
        alert_df_new = alertdf (- time) filter is not in taula_already_Notified
        notify(alert_df_new)
        alert_df_new append to taula_already_Notified
        alertdf (amb time) append to alerts_historic


    else:
        logging.info(f"Any alert {alert} to notify.")

    return True

if __name__ == '__main__':
  app()