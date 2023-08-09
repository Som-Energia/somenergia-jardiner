from pathlib import Path
from typing import Optional

from pydantic import BaseSettings, Field
from sqlalchemy.engine.url import URL


class Settings(BaseSettings):
    active_plant: Optional[str] = Field(None, env="SOM_JARDINER_ACTIVE_PLANT")
    plantmonitor_module_settings: Optional[str] = Field(
        None,
        env="SOM_JARDINER_PLANTMONITOR_MODULE_SETTINGS",
    )
    db_user: str = Field(..., env="SOM_JARDINER_DB_USER")
    db_password: str = Field(..., env="SOM_JARDINER_DB_PASSWORD")
    db_dbname: str = Field(..., env="SOM_JARDINER_DB_DBNAME")
    db_port: str = Field(..., env="SOM_JARDINER_DB_PORT")
    db_host: str = Field(..., env="SOM_JARDINER_DB_HOST")
    db_schema: str = Field(..., env="SOM_JARDINER_DB_SCHEMA")

    novu_base_url: Optional[str] = Field(None, env="SOM_JARDINER_NOVU_BASE_URL")
    novu_api_key: Optional[str] = Field(None, env="SOM_JARDINER_NOVU_API_KEY")

    @property
    def db_url(self) -> URL:
        return URL(
            drivername="postgresql",
            username=self.db_user,
            password=self.db_password,
            host=self.db_host,
            port=self.db_port,
            database=self.db_dbname,
        )

    class Config:
        env_file = Path(__file__).parent.parent / ".env"
        env_file_encoding = "utf-8"


settings = Settings()

if __name__ == "__main__":
    print(settings)
