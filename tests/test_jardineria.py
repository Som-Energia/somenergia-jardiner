from collections import OrderedDict
from sqlalchemy import create_engine
from jardiner import get_dbapi
from jardiner import get_alarms
import pytest

@pytest.fixture(scope="session")
def engine():
    return create_engine("postgresql://localhost/test_database")


def test___notify_alarms__pre_config():
    config = get_dbapi('pre')
    assert config
    assert type(config) is str