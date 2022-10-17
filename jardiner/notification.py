import requests
import logging

def notify(url, api_key, payload):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "name": "alarmes-del-jardi",
        "to":  {
            "subscriberId": "pol_recipient",
            "email": "pol.monso@somenergia.coop"
        },
        "payload": {
            'alarms': payload
        }
    }

    response = requests.post(url,headers=headers, json=data)

    print(response.text)
    logging.debug(response.text)
    import ipdb; ipdb.set_trace()
    response.raise_for_status()

    return response