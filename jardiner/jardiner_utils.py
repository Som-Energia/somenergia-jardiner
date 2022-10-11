import logging
from dotenv import dotenv_values

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

def get_config(dbapi_argument):
    if dbapi_argument == 'prod':
        return dotenv_values(".env.prod")
    elif dbapi_argument == 'pre':
        return dotenv_values(".env.pre")
    else:
        return dbapi_argument

