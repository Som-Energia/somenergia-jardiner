import requests
import logging

def notify(url, api_key, payload):

    headers = {
        'Authorization': f'ApiKey {api_key}',
        'Content-Type': 'application/json'
    }

    data='''{
        "name": "alarmes-del-jardi",
        "to":  {
            "subscriberId": "pol_recipient",
            "email": "pol.monso@somenergia.coop"
        },
        "payload": ''
    }'''

    response = requests.post(url, headers=headers, data=data)

    print(response.text)
    logging.debug(response.text)
    import ipdb; ipdb.set_trace()
    response.raise_for_status()

    return response