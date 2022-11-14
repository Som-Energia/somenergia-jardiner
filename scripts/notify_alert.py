import logging
import requests
import typer
import datetime
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

    table_name = alert_name + '_status'

    table_exists = True
    try:
        alert_status_df_old = pd.read_sql_table(con=con, table_name=table_name, schema=schema)
    except ValueError:
        table_exists = False

    if table_exists:
        alertdf_new_clean = alertdf_new.drop(columns=['time'])

        alert_status_df_old_clean = alert_status_df_old.drop(columns=['time'])
        alert_status_df_old_clean['xgroupby'] = 'old'
        alertdf_new_clean['xgroupby'] = 'new'
        df = pd.concat([alert_status_df_old_clean,alertdf_new_clean]).reset_index(drop=True)
        groupby_df = df.groupby(['plant_id','plant_name','device_type','device_name','is_alarmed'])
        difference_rows = [x[0] for x in groupby_df.groups.values() if len(x) == 1]
        df = df.reindex(difference_rows)
        alertdf_diff = df[df['xgroupby']=='new'].drop('xgroupby',axis=1)

    else:
        alertdf_diff = alertdf_new.copy()
        alertdf_diff.drop(columns=['time'], inplace=True)

    alertdf_diff['notification_time'] = pd.Timestamp.utcnow()

    alertdf_diff.to_sql(con=con, name=alert_name + '_historic', if_exists='append', schema=schema, index=False)
    alertdf_new.to_sql(con=con, name=table_name, if_exists='replace', schema=schema, index=False)

    return alertdf_new, alertdf_diff

@app.command()
def get_alarms_to_notify(
        plantmonitor_db: str,
        novu_url: str,
        api_key: str,
        schema: str,
        receiver_email: str,
        alert: str
    ):
    logging.info(f"Got {novu_url} and {api_key}")
    dbapi = plantmonitor_db # pending implement custom function jardiner.utils get_dbapi
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        alertdf = pd.read_sql_table(alert, plantmonitor_db, schema=schema)
        alertdf = alertdf.filter(items=['time','plant_id','plant_name','device_type','device_name','alarm_name','is_alarmed'])
        if len(alertdf) == 0:
            logging.info(f"No alert {alert} returned..")
            return True

        alertdf, alertdf_diff = refresh_notification_table(con=conn, schema=schema, alertdf=alertdf, alert_name=alert)

        alertjson = alertdf_diff.to_json(orient='table')

        if len(alertdf_diff) > 0:
            #notify(novu_url, api_key, alertjson, receiver_email)
            logging.info(f"Alert {alert} notifed.")
        else:
            logging.info(f"No alert {alert} to notify.")

    return True

if __name__ == '__main__':
  app()