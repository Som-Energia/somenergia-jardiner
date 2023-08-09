import pandas as pd
from sqlalchemy.engine import Transaction


def get_alarms(conn: Transaction):
    # alarms = conn.execute('select * from prod.alarm_everything_today_vs_yesterday').fetchall()
    alarms = pd.read_sql_table(
        "alarm_everything_today_vs_yesterday", conn, schema="prod"
    )
    return alarms.to_dict()


# vim: et sw=4 ts=4
