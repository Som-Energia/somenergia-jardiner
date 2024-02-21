title: Gestionar notificacions a Novu
description: Com interactuar amb el sistema de notificacions Novu
date: 2023-07-10

# Novu helpers and quickstart

## Swagger API

[Novu api](https://api.novu.co/api/)

## overview

Features in novu get to the api waaaay before the get to the UI, so keep it at hand since most of the changes (adding removing subscribers, topics, etc.) will be done via python, react or postman via api rest calls.

## helpers

We have a handful of scripts to interact with novu via airflow or command-line `scripts/notify_alert.py` and `scripts/novu_interface.py`.

The `notify_alert` is ran by airflow to periodically check the alarm tables and trigger a notification on change.

`novu_interface` is more of a command-line util to do novu stuff manually, like adding subscribers or topics.

For example, to add a topic of a plant we'd do

```bash
$ python -m scripts.novu_interface --help

Usage: python -m scripts.novu_interface [OPTIONS] URL API_KEY TOPIC_KEY
                                         TOPIC_NAME

Usage: python -m scripts.novu_interface add-topic [OPTIONS] URL API_KEY
                                                   TOPIC_KEY TOPIC_NAME

╭─ Arguments ────────────────────────────────────────────────────────────╮
│ *    url             TEXT  [default: None] [required]                  │
│ *    api_key         TEXT  [default: None] [required]                  │
│ *    topic_key       TEXT  [default: None] [required]                  │
│ *    topic_name      TEXT  [default: None] [required]                  │
╰────────────────────────────────────────────────────────────────────────╯
╭─ Options ──────────────────────────────────────────────────────────────╮
│ --help          Show this message and exit.                            │
╰────────────────────────────────────────────────────────────────────────╯
```

```bash
$ python -m scripts.novu_interface add-topic {novu_base_url} {api_key} {topic_key} {topic_name}
$ python -m scripts.novu_interface add-topic http://moll3.somenergia.lan:3000/v1 {api_key} asomada-topic-1 "asomada general topic"
```
and to get the topics

```bash
$ python -m scripts.novu_interface get-topic {novu_base_url} {api_key} {topic_key} {topic_name}

2023-01-27 16:39:29,080 [INFO] {"page":0,"totalCount":1,"pageSize":10,"data":[
    {"_id":"63d3ef030d600f1df1a3829e","_environmentId":"6349479f3043d373c3d5fc07","_organizationId":"6349479f3043d373c3d5fc02","key":"asomada-topic-1","name":"asomada general topic","subscribers":[]}
]}
```

Let's add some subcribers to it:

```bash
$ python -m scripts.novu_interface add-subscriber http://moll3.somenergia.lan:3000/v1 {api_key} pol_recipient
$ python -m scripts.novu_interface add-topic-subscriber http://moll3.somenergia.lan:3000/v1 {api_key} asomada-topic-1 pol_recipient
```




