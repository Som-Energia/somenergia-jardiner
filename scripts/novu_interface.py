import json
import logging
from typing import List, Optional

import requests
import typer

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)

app = typer.Typer()


def notify(base_url, api_key, payload, email, alert):
    alert = alert.replace("_", "")
    headers = {"Authorization": f"ApiKey {api_key}"}
    data = {
        "name": alert,
        "to": {"subscriberId": "recipient_lucia", "email": email},
        "payload": {"alerts": payload},
    }

    response = requests.post(base_url, headers=headers, json=data)
    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def add_topic(base_url, api_key, topic_key, topic_name):
    headers = {"Authorization": f"ApiKey {api_key}"}

    data = {"key": topic_key, "name": topic_name}

    topic_url = f"{base_url}/topics"

    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def notify_topic(base_url, api_key, topic_key, template_name="test_template"):
    headers = {"Authorization": f"ApiKey {api_key}"}

    data = {
        "name": template_name,
        "to": {"type": "Topic", "topicKey": topic_key},
        "payload": {"alerts": "test"},
    }

    topic_url = f"{base_url}/events/trigger"

    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def get_topics(base_url, api_key):
    headers = {"Authorization": f"ApiKey {api_key}"}

    topic_url = f"{base_url}/topics"

    response = requests.get(topic_url, headers=headers)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def get_subscribers(base_url, api_key):
    headers = {"Authorization": f"ApiKey {api_key}"}

    sub_url = f"{base_url}/subscribers"

    response = requests.get(sub_url, headers=headers)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def remove_subscriber(base_url, api_key, subscriber_id):
    headers = {"Authorization": f"ApiKey {api_key}"}

    sub_url = f"{base_url}/subscribers/{subscriber_id}"

    response = requests.delete(sub_url, headers=headers)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def add_topic_subscriber(base_url, api_key, topic_key, subscriber_ids: List[str]):
    headers = {"Authorization": f"ApiKey {api_key}"}

    data = {"subscribers": subscriber_ids}

    topic_url = f"{base_url}/topics/{topic_key}/subscribers"

    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(json.dumps(response.json(), indent=2))
    response.raise_for_status()

    return response


@app.command()
def remove_topic_subscriber(base_url, api_key, topic_key, subscriber_ids: List[str]):
    headers = {"Authorization": f"ApiKey {api_key}"}

    data = {"subscribers": subscriber_ids}

    topic_url = f"{base_url}/topics/{topic_key}/subscribers/removal"

    response = requests.post(topic_url, headers=headers, json=data)

    if response.status_code != requests.codes.no_content:
        logging.info(json.dumps(response.json(), indent=2))
    else:
        logging.info(response.status_code)
    response.raise_for_status()

    return response


@app.command()
def add_subscriber(
    base_url: str,
    api_key: str,
    subscriber_id: str,
    email: str,
    first_name: str,
    last_name: Optional[str] = typer.Argument(""),
    locale: Optional[str] = typer.Argument("ca"),
):
    headers = {"Authorization": f"ApiKey {api_key}"}

    data = {
        "subscriberId": subscriber_id,
        "email": email,
        "firstName": first_name,
        "lastName": last_name,
        "locale": locale,
    }

    topic_url = f"{base_url}/subscribers"

    response = requests.post(topic_url, headers=headers, json=data)

    logging.info(response.text)
    response.raise_for_status()

    return response


@app.command()
def delete_subscriber(base_url: str, api_key: str, subscriber_id: str):
    headers = {"Authorization": f"ApiKey {api_key}"}

    topic_url = f"{base_url}/subscribers/{subscriber_id}"

    response = requests.delete(topic_url, headers=headers)

    logging.info(response.text)
    response.raise_for_status()

    return response


if __name__ == "__main__":
    app()
