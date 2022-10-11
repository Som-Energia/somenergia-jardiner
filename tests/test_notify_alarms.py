from collections import OrderedDict
from jardiner.jardiner_utils import get_config

def test___notify_alarms__pre_config():
    config = get_config('pre')
    assert config
    assert type(config) is OrderedDict