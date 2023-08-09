import pytest
from sqlalchemy import create_engine

from jardiner import get_dbapi


@pytest.fixture(scope="session")
def engine():
    return create_engine("postgresql://localhost/test_database")


def test___notify_alarms__pre_config():
    config = get_dbapi("pre")
    assert config
    assert isinstance(config, str)
