from collections import OrderedDict
from jardiner.jardiner_utils import get_dbapi
from scripts.notify_alert import refresh_notification_table
import sqlalchemy
import pandas as pd
from pandas.testing import assert_frame_equal

def test___notify_alarms__pre_config():
    config = get_dbapi('pre')
    assert config
    assert type(config) is str

def test__notify_alert__base():
    
    alertdf = pd.DataFrame({})
    dbapi = get_dbapi('pre') # dbapi = plantmonitor_db when run by airflow
    schema = 'dbt_lucia' # TODO deal with the testing schema
    alert_name = 'alert_test'
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        expected = pd.read_sql_table(table_name='alerts_status', con=conn, schema=schema)
        result = refresh_notification_table(conn, schema, alertdf, alert_name)
        assert_frame_equal(result,expected)
        
def test__notify_alert__onealert():
    
    dbapi = get_dbapi('pre') # dbapi = plantmonitor_db when run by airflow
    schema = 'dbt_lucia' # TODO deal with the testing schema
    alert_name = 'alert_test'
    db_engine = sqlalchemy.create_engine(dbapi)
    with db_engine.begin() as conn:
        alertdf = pd.read_sql_table(table_name='alertdf__onealert', con=conn, schema=schema)
        expected = alertdf
        result = refresh_notification_table(conn, schema, alertdf, alert_name)
        assert_frame_equal(result, expected)