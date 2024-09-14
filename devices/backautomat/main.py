# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import json
import os
import time
import urllib.request
import AWSIoTPythonSDK.MQTTLib as AWSIoTPyMQTT

#Define ENDPOINT, CLIENT_ID, PATH_TO_CERT, PATH_TO_KEY, PATH_TO_ROOT, MESSAGE, TOPIC, and RANGE
PATH_TO_ENDPOINT = "endpoint.txt"
CLIENT_ID_SUBSCRIBE = "backautomat_subscribe"
CLIENT_ID_PUBLISH = "backautomat_publish"
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
REPORT_TOPIC = "$aws/things/backautomat/shadow/update"

with open(PATH_TO_ENDPOINT, 'r') as file:
    ENDPOINT = file.read()

myAWSIoTMQTTClientPublish = AWSIoTPyMQTT.AWSIoTMQTTClient(CLIENT_ID_PUBLISH)
myAWSIoTMQTTClientPublish.configureEndpoint(ENDPOINT, 8883)
myAWSIoTMQTTClientPublish.configureCredentials(
    PATH_TO_ROOT, PATH_TO_KEY, PATH_TO_CERT)

def report_state_to_aws(state: str):
    MESSAGE['state']['reported']['state'] = state
    myAWSIoTMQTTClientPublish.publish(REPORT_TOPIC, json.dumps(MESSAGE), 1)
    print(f"Published:  '{json.dumps(MESSAGE)}' to the topic: {REPORT_TOPIC}")  

def start():
    print('Starting Backautomat')
    myAWSIoTMQTTClientPublish.connect()
    print('Backautomat connected')
    report_state_to_aws("idle")
    while True:
        time.sleep(0.5)
        user_text =  input("Which state to report?:")
        user_text = user_text.lower()
        if user_text in ["idle","running","finished"]:
            report_state_to_aws(user_text)
        else:
            print("Wrong user input please choose between: idle, running, finished")

start()