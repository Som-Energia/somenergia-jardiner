import pandas as pd
from sqlalchemy.engine import Transaction


def get_alarms(conn: Transaction):
    alarms = pd.read_sql_table(
        "alarm_everything_today_vs_yesterday",
        conn,
        schema="dbt_prod",
    )
    return alarms.to_dict()


# vim: et sw=4 ts=4
