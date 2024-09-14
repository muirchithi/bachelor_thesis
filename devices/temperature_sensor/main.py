# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import json
import os
import time
import urllib.request
import AWSIoTPythonSDK.MQTTLib as AWSIoTPyMQTT


class TemperatureSensor:
    MESSAGE = None
    TOPIC = None
    myAWSIoTMQTTClient = None

    def __init__(self):
        # Define ENDPOINT, CLIENT_ID, PATH_TO_CERT, PATH_TO_KEY, PATH_TO_ROOT, MESSAGE, TOPIC, STARTINGTEMP and SLEEPTIME
        self.MESSAGE = {
            "state": {
                "reported": {
                    "temp": ""
                }
            }
        }
        self.TOPIC = "$aws/things/temperature_sensor/shadow/update"
        PATH_TO_ENDPOINT = "endpoint.txt"
        CLIENT_ID = "temp_sensor"
        PATH_TO_CERT = "certificate_pem.cert.pem"
        PATH_TO_KEY = "private_key.key"
        PATH_TO_ROOT = "root.pem"

        with open(PATH_TO_ENDPOINT, 'r') as file:
            ENDPOINT = file.read()
        self.myAWSIoTMQTTClient = AWSIoTPyMQTT.AWSIoTMQTTClient(CLIENT_ID)
        self.myAWSIoTMQTTClient.configureEndpoint(ENDPOINT, 8883)
        self.myAWSIoTMQTTClient.configureCredentials(PATH_TO_ROOT, PATH_TO_KEY, PATH_TO_CERT)

    # send new reported temperature to the cloud
    def report_state_to_aws(self, temp: str):
        self.MESSAGE['state']['reported']['temp'] = temp
        self.myAWSIoTMQTTClient.publish(self.TOPIC, json.dumps(self.MESSAGE), 1)
        print(f"Published: {json.dumps(self.MESSAGE)}' to the topic: {self.TOPIC}")

    def user_temp_input_simulation(self):
        user_temp_input = input("Insert measured temperature:")
        self.report_state_to_aws(user_temp_input)

    def start(self):
        print('Starting temperature sensor')
        self.myAWSIoTMQTTClient.connect()
        print('temperature sensor connected')
        #main loop
        while True:
            time.sleep(0.2)
            self.user_temp_input_simulation()

temperature_sensor = TemperatureSensor()
temperature_sensor.start()