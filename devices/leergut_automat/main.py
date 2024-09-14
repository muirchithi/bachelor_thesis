# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import json
import os
import time
import urllib.request
import AWSIoTPythonSDK.MQTTLib as AWSIoTPyMQTT

# Define ENDPOINT, CLIENT_ID, PATH_TO_CERT, PATH_TO_KEY, PATH_TO_ROOT, MESSAGE, TOPIC, and RANGE
PATH_TO_ENDPOINT = "endpoint.txt"
CLIENT_ID_SUBSCRIBE = "leergut_automat_subscribe"
CLIENT_ID_PUBLISH = "leergut_automat_publish"
PATH_TO_CERT = "certificate_pem.cert.pem"
PATH_TO_KEY = "private_key.key"
PATH_TO_ROOT = "root.pem"

MESSAGE = {
    "state": {
        "reported": {
            "state": ""
        }
    }
}

REPORT_TOPIC = "$aws/things/leergut_automat/shadow/update"

with open(PATH_TO_ENDPOINT, 'r') as file:
    ENDPOINT = file.read()

myAWSIoTMQTTClientPublish = AWSIoTPyMQTT.AWSIoTMQTTClient(CLIENT_ID_PUBLISH)
myAWSIoTMQTTClientPublish.configureEndpoint(ENDPOINT, 8883)
myAWSIoTMQTTClientPublish.configureCredentials(PATH_TO_ROOT, PATH_TO_KEY, PATH_TO_CERT)

def report_state_to_aws(state: str):
    MESSAGE['state']['reported']['state'] = state
    myAWSIoTMQTTClientPublish.publish(REPORT_TOPIC, json.dumps(MESSAGE), 1)
    print(f"Published: '{json.dumps(MESSAGE)}' to the topic {REPORT_TOPIC} ")
    if state == "idle":
        time.sleep(60)
        report_state_to_aws("full")
    if state == "full":
        user_input = input("Confirm leergut automat was emtied (yes):")
        user_input = user_input.lower()
        if user_input == "yes":
            report_state_to_aws("idle")
        else:
            print("Wronger user input")
            report_state_to_aws("full")


def start():
    print('Starting Leergut Automat')
    myAWSIoTMQTTClientPublish.connect()
    print('Leergut Automat connected')
    report_state_to_aws("idle")

start()
