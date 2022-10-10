FROM python:3.8-slim-buster

RUN apt-get update
RUN apt-get install -y wget
RUN wget https://raw.githubusercontent.com/Som-Energia/somenergia-jardiner/main/requirements.txt

RUN pip3 install -r requirements.txt