FROM apache/airflow:2.4.3-python3.8
COPY requirements.txt /

RUN pip install --upgrade pip && pip install --no-cache-dir -r /requirements.txt
