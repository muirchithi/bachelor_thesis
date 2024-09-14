FROM python:3

COPY . /device

WORKDIR /device

RUN pip install AWSIoTPythonSDK

CMD [ "python", "./main.py"]