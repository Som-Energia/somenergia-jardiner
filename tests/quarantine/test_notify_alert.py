from pathlib import Path

import pandas as pd
import pytest
import sqlalchemy
from dotenv import dotenv_values
from pandas.testing import assert_frame_equal

from jardiner.jardiner_utils import get_dbapi
from jardiner.settings import settings
from scripts.notify_alert import evaluate_and_notify_alarm, refresh_notification_table

ASSETS_DIR = Path(__file__).parent / "assets"


@pytest.fixture()
def transaction_connection():
    dbapi = settings.db_url  # dbapi = plantmonitor_db when run by airflow

    engine = sqlalchemy.create_engine(dbapi, echo=False)

    connection = engine.connect()
    transaction = connection.begin()

    yield connection, engine

    transaction.rollback()
    connection.close()


@pytest.fixture
def initdb(transaction_connection):
    schema = "testing"  # TODO deal with the testing schema
    alert_name = "alert_inverter_zero_power_at_daylight"

    connection, engine = transaction_connection  # noqa

    connection.execute(f"CREATE SCHEMA IF NOT EXISTS {schema};")

    csv_to_sqltable(
        csvpath=ASSETS_DIR / "plant_topic_association.csv",
        conn=connection,
        schema=schema,
        table="plant_topic_association",
        ifexists="replace",
    )
    csv_to_sqltable(
        csvpath=ASSETS_DIR / f"{alert_name}.csv",
        conn=connection,
        schema=schema,
        table=alert_name,
        ifexists="replace",
    )
    csv_to_sqltable(
        csvpath=ASSETS_DIR / f"{alert_name}_status.csv",
        conn=connection,
        schema=schema,
        table=f"{alert_name}_status",
        ifexists="replace",
    )

    yield connection, schema


@pytest.fixture
def reassociate_plant_topic(initdb):
    conn, schema = initdb

    csv_to_sqltable(
        csvpath=ASSETS_DIR / "plant_topic_association_one_empty.csv",
        conn=conn,
        schema=schema,
        table="plant_topic_association",
        ifexists="replace",
    )


@pytest.fixture
def get_secrets():
    novu_base_url = settings.novu_base_url
    api_key = settings.novu_api_key

    return novu_base_url, api_key


def test___notify_alarms__pre_config():
    config = settings.db_url
    assert config
    assert isinstance(config, str)


def _test__notify_alert__base():
    alertdf = pd.DataFrame({})
    dbapi = settings.db_url  # dbapi = plantmonitor_db when run by airflow
    schema = "dbt_lucia"  # TODO deal with the testing schema
    alert_name = "alert_test"
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        expected = pd.read_sql_table(
            table_name="alerts_status", con=conn, schema=schema
        )
        result = refresh_notification_table(conn, schema, alertdf, alert_name)
        assert_frame_equal(result, expected)


# TODO figure out what this is suposed to do and pass it
#
def _test__notify_alert__onealert():
    dbapi = settings.db_url  # dbapi = plantmonitor_db when run by airflow
    schema = "dbt_lucia"  # TODO deal with the testing schema
    alert_name = "alert_inverter_zero_power_at_daylight"
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        # with conn.begin() as session:
        conn.execute(f"DROP TABLE IF EXISTS {schema}.{alert_name}_status;")
        conn.execute(f"DROP TABLE IF EXISTS {schema}.{alert_name}_historic;")
        alertdf = pd.read_sql_table(
            table_name="alertdf__onealert", con=conn, schema=schema
        )
        expected = alertdf.drop(columns=["time", "daylight_start", "daylight_end"])
        alertdf, result = refresh_notification_table(conn, schema, alertdf, alert_name)
        result.drop(columns=["notification_time"], inplace=True)
        assert_frame_equal(result.reset_index(), expected.reset_index())
        # session.rollback()


# TODO mock the novu api for a speed up and leave only one integration test
def test__notify_alert__onealert__alerted(initdb):
    conn, schema = initdb

    alert_name = "alert_inverter_zero_power_at_daylight"

    alertdf = pd.read_sql_table(table_name=alert_name, con=conn, schema=schema)
    alertdf, result = refresh_notification_table(conn, schema, alertdf, alert_name)

    assert len(result) == 1
    assert result.iloc[0]["is_alarmed"] == True
    assert result.iloc[0]["plant_name"] == "Alcolea"


def csv_to_sqltable(csvpath, conn, schema, table, ifexists):
    df = pd.read_csv(csvpath)
    df.to_sql(table, con=conn, schema=schema, if_exists=ifexists, index=False)


# This is an integration test. Check if you recieved the notification.
# NOTE: notifies testing_topic which has no subscribors. Subscribe to it if you want to get the test notifications.
def test__evaluate_and_notify_alarm__notify_one_alert(initdb, get_secrets):
    conn, schema = initdb
    alert_name = "alert_inverter_zero_power_at_daylight"
    novu_base_url, api_key = get_secrets

    notified = evaluate_and_notify_alarm(
        conn,
        novu_base_url,
        api_key,
        schema,
        alert_name,
        to_notify=True,
        default_topic_ids=["testing_topic"],
    )

    expected = ["testing_topic", "testing_topic"]
    assert notified == expected


def test__evaluate_and_notify_alarm__skip_other_plant(
    initdb, reassociate_plant_topic, get_secrets
):
    conn, schema = initdb
    alert_name = "alert_inverter_zero_power_at_daylight"
    novu_base_url, api_key = get_secrets

    notified = evaluate_and_notify_alarm(
        conn,
        novu_base_url,
        api_key,
        schema,
        alert_name,
        to_notify=True,
        default_topic_ids=["testing_topic"],
    )

    expected = ["testing_topic", "empty_topic"]
    assert notified == expected
