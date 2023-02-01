import logging
import requests
import typer
import datetime
import sqlalchemy
import pandas as pd
import json
import numpy as np

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

app = typer.Typer()

def notify(url, api_key, payload, email, alert):
    alert = alert.replace('_','')
    headers = {
        'Authorization': f'ApiKey {api_key}'
    }
    data={
        "name": alert,
        "to":  {
            "subscriberId": "recipient_lucia",
            "email": email
        },
        "payload": {
            'alerts': payload
        }
    }

    response = requests.post(url, headers=headers, json=data)
    logging.info(response.text)
    response.raise_for_status()

    return response


def notify_topic(url, api_key, payload, topic_ids, alert):
    alert = alert.replace('_','')
    headers = {
        'Authorization': f'ApiKey {api_key}'
    }
    data={
        "name": alert,
        "to":  topic_ids,
        "payload": {
            'alerts': payload
        }
    }

    response = requests.post(url, headers=headers, json=data)
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
        alert_status_df_old_clean = alert_status_df_old.copy()

        alertdf_new_clean_merged = alertdf_new_clean.merge(alert_status_df_old_clean, how='left', on=['plant_id','plant_name' ,'device_type' ,'device_name' ,'alarm_name'])
        alertdf_new_clean['is_alarmed'] = np.where(alertdf_new_clean_merged['is_alarmed_x'].isnull(), alertdf_new_clean_merged['is_alarmed_y'], alertdf_new_clean_merged['is_alarmed_x'])
        # If still NULL then False (rare case without readings 30 days before):
        alertdf_new_clean['is_alarmed'] = np.where(alertdf_new_clean['is_alarmed'].isnull(), False, alertdf_new_clean['is_alarmed'])

        alert_status_df_old_clean['xgroupby'] = 'old'
        alertdf_new_clean['xgroupby'] = 'new'
        df = pd.concat([alert_status_df_old_clean,alertdf_new_clean]).reset_index(drop=True)
        groupby_df = df.groupby(['plant_id','plant_name','device_type','device_name','is_alarmed'])
        difference_rows = [x[0] for x in groupby_df.groups.values() if len(x) == 1]
        df = df.reindex(difference_rows)
        alertdf_diff = df[df['xgroupby']=='new'].drop('xgroupby',axis=1)
        alertdf_new_clean.drop('xgroupby',axis=1, inplace=True)

    else:
        alertdf_new['is_alarmed'] = False
        alertdf_new_clean = alertdf_new.copy()
        alertdf_new_clean.drop(columns=['time'], inplace=True)
        alertdf_diff = alertdf_new.copy()
        alertdf_diff.drop(columns=['time'], inplace=True)

    alertdf_diff['notification_time'] = pd.Timestamp.utcnow()

    alertdf_diff.to_sql(con=con, name=alert_name + '_historic', if_exists='append', schema=schema, index=False)
    alertdf_new_clean.to_sql(con=con, name=table_name, if_exists='replace', schema=schema, index=False)

    return alertdf_new, alertdf_diff

def df_notify_topic_if_diff(alertdf_diff, novu_url, api_key, topic_keys, alert):
    
    alertjson = alertdf_diff.to_json(orient='table')
    alertdata = json.loads(alertjson)['data']

    if len(alertdf_diff) > 0:
            notify_topic(novu_url, api_key, alertdata, topic_keys, alert)
            logging.info(f"Alert {alert} notifed.")
    else:
        logging.info(f"No alert {alert} to notify.")

@app.command()
def get_alarms_to_notify(
        plantmonitor_db: str,
        novu_url: str,
        api_key: str,
        schema: str,
        alert: str,
        to_notify: str
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
        alertdf_diff['color'] = np.where(alertdf_diff['is_alarmed'] == True, '#FD0D0D', '#2F9905')

        if not to_notify:
            logging.info(f"Alert {alert} would notify but to_notify is False.")
            return True

        topic_keys = ['dades', 'gestio_dactius']

        df_notify_topic_if_diff(alertdf_diff, novu_url, api_key, topic_keys, alert)
            
        notification_topics_df = pd.read_sql_table('plant_topic_association', plantmonitor_db, schema=schema)

        plants_by_topic = notification_topics_df.groupby('notification_topic')['plant_id'].apply(list).to_dict() 

        for notification_topic, plants in plants_by_topic.items():
           
            sub_alertdf_diff = alertdf_diff[alertdf_diff['plant_id'] in plants]

            df_notify_topic_if_diff(sub_alertdf_diff, novu_url, api_key, notification_topic, alert)

    return True

if __name__ == '__main__':
  app()