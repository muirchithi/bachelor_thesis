# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0

import json
import os
import time
import urllib.request
import AWSIoTPythonSDK.MQTTLib as AWSIoTPyMQTT


#Define ENDPOINT, CLIENT_ID, PATH_TO_CERT, PATH_TO_KEY, PATH_TO_ROOT, MESSAGE, TOPIC, and RANGE
PATH_TO_ENDPOINT = "endpoint.txt"
CLIENT_ID_SUBSCRIBE = "freezer_subscribe"
CLIENT_ID_PUBLISH = "freezer_publish"
PATH_TO_CERT = "certificate_pem.cert.pem"
PATH_TO_KEY = "private_key.key"
PATH_TO_ROOT = "root.pem"
SUBSCRIBE_TOPIC = "$aws/things/freezer/shadow/update/delta"

MESSAGE = {
    "state": {
        "reported": {
            "state": ""
        }
    }
}
REPORT_TOPIC = "$aws/things/freezer/shadow/update"

with open(PATH_TO_ENDPOINT, 'r') as file:
    ENDPOINT = file.read()

myAWSIoTMQTTClientSubscribe = AWSIoTPyMQTT.AWSIoTMQTTClient(CLIENT_ID_SUBSCRIBE)
myAWSIoTMQTTClientSubscribe.configureEndpoint(ENDPOINT, 8883)
myAWSIoTMQTTClientSubscribe.configureCredentials(
    PATH_TO_ROOT, PATH_TO_KEY, PATH_TO_CERT)

myAWSIoTMQTTClientPublish = AWSIoTPyMQTT.AWSIoTMQTTClient(CLIENT_ID_PUBLISH)
myAWSIoTMQTTClientPublish.configureEndpoint(ENDPOINT, 8883)
myAWSIoTMQTTClientPublish.configureCredentials(
    PATH_TO_ROOT, PATH_TO_KEY, PATH_TO_CERT)    

def report_state_to_aws(state: str):
    MESSAGE['state']['reported']['state'] = state
    myAWSIoTMQTTClientPublish.publish(REPORT_TOPIC, json.dumps(MESSAGE), 1)
    print(f"Published: '{json.dumps(MESSAGE)}' to the topic: {REPORT_TOPIC}")

def handle_change(client, userdate, message):
    json_object = json.loads(message.payload)
    state = json_object["state"]["state"]
    print(f"Switching state to {state}")
    report_state_to_aws(state)

def start():
    print('Starting Freezer')
    myAWSIoTMQTTClientSubscribe.connect()
    myAWSIoTMQTTClientSubscribe.subscribe(SUBSCRIBE_TOPIC, 1, handle_change)
    myAWSIoTMQTTClientPublish.connect()
    print('Freezer connected')
    report_state_to_aws("idle")
    while True:
        time.sleep(0.5)

start()