from collections import OrderedDict
from sqlalchemy import create_engine
from jardiner.jardiner_utils import get_config


@pytest.fixture(scope="session")
def engine():
    return create_engine("postgresql://localhost/test_database")


def test___notify_alarms__pre_config():
    config = get_alarms('pre')
    assert config
    assert type(config) is OrderedDict