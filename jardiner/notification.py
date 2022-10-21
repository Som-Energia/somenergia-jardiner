import requests
import logging
import datetime

def notify(url, api_key, payload):
    last_day_alarm = datetime.datetime.today().date() - datetime.timedelta(days = 1) # not sure if 1 or 2 days

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "name": "alarmes-del-jardi",
        "to":  {
            "subscriberId": "roger_recipient",
            "email": "roger.sanjaume@somenergia.coop"
        },
        "payload": {
            'name': [{'yesterday':last_day_alarm.strftime("%d/%m/%Y")}],
            'alarms': payload
        }
    }

    response = requests.post(url,headers=headers, json=data)
    logging.info(response.text)
    response.raise_for_status()

    return response