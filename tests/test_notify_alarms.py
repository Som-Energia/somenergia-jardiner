from jardiner.jardiner_utils import get_dbapi


def test___notify_alarms__pre_config():
    config = get_dbapi("pre")
    assert config
    assert isinstance(config, str)
