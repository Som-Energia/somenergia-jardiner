import datetime as dt

from pydantic import BaseModel, Field

from jardiner.models.enums import SimelCorbeFileType

# ---------------------------------------------------------------------------- #
#                                  Base models                                 #
# ---------------------------------------------------------------------------- #


class BaseFileTypeDescription(BaseModel):
    name: SimelCorbeFileType = Field(
        ...,
        description="Name of the file type",
    )

    filename_regex: str = Field(
        ...,
        description="Regex to match the file name",
    )

    filename_log_table_name: str = Field(
        ...,
        description="Name of the table with the log of inserted files",
    )

    file_separator: str = Field(
        None,
        description="Separator of the file, if any",
    )


class BaseFileType(BaseModel):
    file_description: BaseFileTypeDescription


class BaseFileLog(BaseModel):
    id: int = Field(..., description="Unique identifier")
    filename: str = Field(..., description="Name of the file")
    st_size: dt.datetime = Field(..., description="Size in bytes using os.stat")
    st_atime: dt.datetime = Field(
        ..., description="Last accessed time according to os.stat"
    )
    st_mtime: dt.datetime = Field(
        ..., description="Last modified time according to os.stat"
    )
    st_ctime: dt.datetime = Field(
        ..., description="Last status change time, according to os.stat"
    )
    file_type: SimelCorbeFileType = Field(
        ..., description="Name of the type of the file, e.g. simel_f5d"
    )
    filename_date: dt.datetime = Field(..., description="Parsed date from filename")
    origin_path: str = Field(
        ..., description="Path to file in NAS where the file was found"
    )
    error_msg: str = Field(..., description="Error message, if any")
    inserted_at: dt.datetime = Field(
        ..., description="Timestamp of insertion into the database"
    )


# ---------------------------------------------------------------------------- #
#                                     MHCIL                                    #
# ---------------------------------------------------------------------------- #


class MHCILFileDescription(BaseFileTypeDescription):
    """Description of the MHCIL file name format.

    Example file name:
        MHCIL_CC_YYYY_RR_AAAAMMDD.v
    Where:

    - CC:Tipo de fichero
    - Periodo de publicación:
        - HD: valores de cierre diario
        - H2: valores de cierre de mes m-1
        - H3: valores de cierre de mes m-3
        - HP: valores de cierre provisional
        - HC: valores de cierre definitivo
    - YYYY: Código de participante
    - RR: Tipo de receptor del fichero:
        - P1: participante 1
        - P2: participante 2
        - A1: representante
    - AAAAMMDD: Fecha a la que corresponden los datos
    - v: Versión del fichero
    """

    # https://regex101.com/r/wNH33F/1

    name: SimelCorbeFileType = SimelCorbeFileType.simel_mhcil
    filename_regex: str = r"^MHCIL_H[23PCD]_\d{4}_A[12]_(\d{8})\.\d$"
    filename_log_table_name: str = "simel_mhcil_files_log"
    file_separator: str = ";"


class MHCILFileType(BaseFileType):
    cil: str = Field(...)
    year: int = Field(...)
    month: int = Field(...)
    day: int = Field(...)
    hour: int = Field(...)
    is_summer: bool = Field(...)
    energy_kwh: float = Field(...)
    reactive_energy_2_kvarh: float = Field(...)
    reactive_energy_3_kvarh: float = Field(...)
    measurement_type: str = Field(...)

    file_description: MHCILFileDescription = MHCILFileDescription.construct()

    class Config:
        orm_mode = True


class MHCILFileLog(BaseFileLog):
    class Config:
        orm_mode = True
