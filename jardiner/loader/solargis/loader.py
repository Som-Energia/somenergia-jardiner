from pathlib import Path
from typing import List, Optional

import typer
import yaml
from loguru import logger
from pydantic import BaseModel, BaseSettings, Field

from jardiner.settings import settings


class ProductionDevice(BaseModel):
    id: Optional[str] = None
    name: Optional[str] = None
    type: Optional[str] = None
    description: Optional[str] = None
    modelo: Optional[str] = None
    enable: Optional[str] = None
    modmap: Optional[dict] = {}
    protocol: Optional[str] = None


class ProductionPlant(BaseModel):
    id: Optional[str] = None
    name: Optional[str] = None
    description: Optional[str] = None
    enable: Optional[str] = None
    location: Optional[str] = None
    devices: Optional[List[str]] = []

    def load_from_yaml(self, config_path: Path, plant_name: str):
        data = yaml.load(config_path)

        for plant_data in data.plantmonitor:
            if plant_data.enabled and plant_data.name == plant_name:
                self.name = plant_data.name
                self.description = plant_data.description
                for device_data in plant_data.devices:
                    new_device = ProductionDevice()
                    if new_device.load(device_data):
                        self.devices.append(new_device)

        return True


# create tables

# load data

# print environment variables

# task


def task():
    plantname = settings.active_plant

    plant = ProductionPlant()

    apiconfig = envinfo.API_CONFIG

    if not plant.load("conf/modmap.yaml", plantname):
        logger.error("Error loading yaml definition file...")
        sys.exit(-1)

    plant_data = get_plant_reading(plant)

    if not plant_data:
        logger.error("Getting reading from {} failed. Aborting.".format(plantname))
        return

    pony_manager = PonyManager(envinfo.DB_CONF)
    pony_manager.define_all_models()
    pony_manager.binddb()
    ponyStorage = PonyMetricStorage(pony_manager.db)
    apiStorage = ApiMetricStorage(apiconfig)

    logger.info("**** Saving data in database ****")
    logger.debug("plant_data: {}".format(plant_data))
    ponyStorage.insertPlantData(plant_data)

    logger.info("**** Saving data in Api ****")
    result = apiStorage.insertPlantData(plant_data)
    logger.debug("api response: {}".format(result))


# task_meters_erp_to_orm


# task_daily_upload_to_api_meteologica


# task_daily_download_from_api_meteologica


# task_maintenance


# task_daily_download_from_api_solargis
