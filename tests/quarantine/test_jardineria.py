import pytest
from sqlalchemy import create_engine


@pytest.fixture(scope="session")
def engine():
    return create_engine("postgresql://localhost/test_database")


def test___notify_alarms__pre_config():
    config = get_dbapi("pre")
    assert config
    assert isinstance(config, str)
