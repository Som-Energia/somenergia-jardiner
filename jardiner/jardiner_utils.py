import logging

from dotenv import dotenv_values

logging.basicConfig(
    level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s"
)


def get_dbapi(dbapi_argument):
    if dbapi_argument == "prod":
        env_dict = dotenv_values(".env.prod")
        return env_dict["plantmonitor_dbapi"]
    elif dbapi_argument == "pre":
        env_dict = dotenv_values(".env.pre")
        return env_dict["plantmonitor_dbapi"]
    elif dbapi_argument == "testing":
        env_dict = dotenv_values(".env.testing")
        return env_dict["plantmonitor_dbapi"]
    else:
        return dbapi_argument
