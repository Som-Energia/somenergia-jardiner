from sqlalchemy.engine import Transaction

def get_alarms(conn: Transaction):
    alarms = conn.execute('select * from alarm_status').fetchall()
    return alarms

# vim: et sw=4 ts=4
