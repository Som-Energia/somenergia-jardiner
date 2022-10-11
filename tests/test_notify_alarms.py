from jardiner.notify_alarms import get_config

def test___notify_alarms__pre_config():
    config = get_config('pre')
    assert config