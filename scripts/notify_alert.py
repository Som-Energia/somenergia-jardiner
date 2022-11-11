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

def refresh_notification_table(con, schema, alertdf, alert_name):
    
    alertdf_new = alertdf
    
    alerts_status_df_old = pd.read_sql_table(con=con, table_name=alert_name+'_status', schema=schema)

    one_alert_status_df_old = alerts_status_df_old[alerts_status_df_old['alarm_name'] == alert_name]
    
    import ipdb; ipdb.set_trace()
    drop.time
    alertdf_diff: pd.DataFrame = alertdf_new - one_alert_status_df_old # difference
    
    alertdf_diff.to_sql(con=con, name='alerts_historic', if_exists='append', schema=schema)
    
    # filter out all previous status for this alarm type
    alerts_status_df = alerts_status_df_old[alerts_status_df_old['alarm_name'] != alert_name]
    
    alerts_status_df.append(alertdf_new)
    
    alerts_status_df.to_sql(con=con, name=alert_name+'_status', if_exists='replace', schema=schema)
    
    return alerts_status_df

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
    dbapi = get_dbapi(plantmonitor_db) # dbapi = plantmonitor_db when run by airflow
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        alertdf = pd.read_sql_table(alert, plantmonitor_db, schema=schema)
        alertdf = alertdf[alertdf['is_alarmed'] == True]

        alertdf_diff = refresh_notification_table()

        alertjson = alertdf_diff.to_json(orient='table')

        if len(alertdf_diff) > 0:
            #notify(novu_url, api_key, alertjson, reciver_email)
            logging.info(f"Alert {alert} notifed.")
        else:
            logging.info(f"Any alert {alert} to notify.")

    return True

if __name__ == '__main__':
  app()