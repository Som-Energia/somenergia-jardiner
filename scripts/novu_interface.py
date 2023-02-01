import logging
import requests
import typer
from typing import List, Optional

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

@app.command()
def add_topic(url, api_key, topic_key, topic_name):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "key": topic_key,
        "name": topic_name
    }

    response = requests.post(url, headers=headers, json=data)

    logging.info(response.text)
    response.raise_for_status()

    return response

@app.command()
def get_topics(url, api_key):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    response = requests.get(url, headers=headers)

    logging.info(response.text)
    response.raise_for_status()

    return response


@app.command()
def add_topic_subscriber(url, api_key, topic_key, subscriber_ids: List[str]):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "subscribers": subscriber_ids
    }

    topic_url = f'{url}/topics/{topic_key}/subscribers'



    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(response.text)
    response.raise_for_status()

    return response

@app.command()
def add_subscriber(url: str, api_key: str, subscriber_id: str, email: str, first_name: str, last_name: Optional[str] = typer.Argument(''), locale: Optional[str] = typer.Argument('ca')):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    data={
        "subscriberId": subscriber_id,
        "email": email,
        "firstName": first_name,
        "lastName": last_name,
        "locale": locale,
    }

    topic_url = f'{url}/subscribers'


    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(response.text)
    response.raise_for_status()

    return response

@app.command()
def delete_subscriber(url: str, api_key: str, subscriber_id: str):

    headers = {
        'Authorization': f'ApiKey {api_key}'
    }

    topic_url = f'{url}/subscribers/{subscriber_id}'


    response = requests.delete(topic_url, headers=headers)

    logging.info(response.text)
    response.raise_for_status()

    return response    


if __name__ == '__main__':
  app()