#Create detector model
resource "aws_cloudformation_stack" "backautomat_detector_model_stack" {
  depends_on   = [time_sleep.wait_15_seconds]
  name         = "BackautomatDetectorModelStack"
  iam_role_arn = aws_iam_role.cloud_formation_to_events_role.arn

  template_body = <<STACK
{
    "AWSTemplateFormatVersion": "2010-09-09",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "6174c346-ae3e-4e97-b5ae-caa1a4cd4b12": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 185,
                    "y": 47
                },
                "z": 0,
                "embeds": [],
                "dependson": [
                    "3c8aff24-b601-4dab-a2dc-ffd8f8d00bfe"
                ]
            },
            "3c8aff24-b601-4dab-a2dc-ffd8f8d00bfe": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 160,
                    "y": 150
                },
                "z": 0,
                "embeds": []
            }
        }
    },
    "Resources": {
        "BackautomatInput": {
            "Type": "AWS::IoTEvents::Input",
            "Properties": {
                "InputName": "backautomat_input",
                "InputDescription": "Input from the backautomat",
                "InputDefinition": {
                    "Attributes": [
                        {
                            "JsonPath": "state.reported.state"
                        }
                    ]
                }
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "3c8aff24-b601-4dab-a2dc-ffd8f8d00bfe"
                }
            }
        },
        "BackautomatDetectorModel": {
            "Type": "AWS::IoTEvents::DetectorModel",
            "Properties": {
                "DetectorModelDefinition": {
                    "States": [
                        {
                            "StateName": "idle",
                            "OnInput": {
                                "Events": [],
                                "TransitionEvents": [
                                    {
                                        "EventName": "goToRunning",
                                        "Condition": "$input.backautomat_input.state.reported.state == \"running\"",
                                        "Actions": [],
                                        "NextState": "running"
                                    }
                                ]
                            },
                            "OnEnter": {
                                "Events": []
                            },
                            "OnExit": {
                                "Events": []
                            }
                        },
                        {
                            "StateName": "running",
                            "OnInput": {
                                "Events": [],
                                "TransitionEvents": [
                                    {
                                        "EventName": "goToFinished",
                                        "Condition": "$input.backautomat_input.state.reported.state==\"finished\"",
                                        "Actions": [],
                                        "NextState": "finished"
                                    }
                                ]
                            },
                            "OnEnter": {
                                "Events": []
                            },
                            "OnExit": {
                                "Events": []
                            }
                        },
                        {
                            "StateName": "finished",
                            "OnInput": {
                                "Events": [],
                                "TransitionEvents": [
                                    {
                                        "EventName": "true",
                                        "Condition": "true",
                                        "Actions": [],
                                        "NextState": "idle"
                                    }
                                ]
                            },
                            "OnEnter": {
                                "Events": [
                                    {
                                        "EventName": "Backautomat_send_email",
                                        "Condition": "true",
                                        "Actions": [
                                            {
                                                "Sns": {
                                                    "TargetArn": "arn:aws:sns:eu-central-1:274167473874:Backautomat",
                                                    "Payload": {
                                                        "ContentExpression": "'Backautomat finished, returning to idle'",
                                                        "Type": "STRING"
                                                    }
                                                }
                                            }
                                        ]
                                    }
                                ]
                            },
                            "OnExit": {
                                "Events": []
                            }
                        }
                    ],
                    "InitialStateName": "idle"
                },
                "DetectorModelDescription": "Detector Model of the backautomat",
                "DetectorModelName": "Backautomat",
                "EvaluationMethod": "BATCH",
                "RoleArn": "arn:aws:iam::274167473874:role/service-role/IoTEventsRole"
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "6174c346-ae3e-4e97-b5ae-caa1a4cd4b12"
                }
            },
              "DependsOn": "BackautomatInput"
        }
    }
}
STACK
}

resource "aws_cloudformation_stack" "leergut_automat_detector_model_stack" {
  depends_on = [
    time_sleep.wait_15_seconds]
  name = "LeergutAutomatDetectorModelStack"
  iam_role_arn = aws_iam_role.cloud_formation_to_events_role.arn
  template_body = <<STACK
{
    "AWSTemplateFormatVersion": "2010-09-09",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "55dfc17f-b0dd-4096-9b3a-2d4fd58fac35": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 180,
                    "y": 60
                },
                "z": 0,
                "embeds": [],
                "dependson": [
                    "0391ab49-fcf8-41ae-882a-07afd9e1d295"
                ]
            },
            "0391ab49-fcf8-41ae-882a-07afd9e1d295": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 186,
                    "y": 156.00000001490116
                },
                "z": 0,
                "embeds": []
            },
            "7596bf51-b7e8-430d-8e8e-a37391d65e31": {
                "source": {
                    "id": "55dfc17f-b0dd-4096-9b3a-2d4fd58fac35"
                },
                "target": {
                    "id": "0391ab49-fcf8-41ae-882a-07afd9e1d295"
                },
                "z": 1
            }
        }
    },
    "Resources": {
        "LeergutAutomatDetectorModel": {
            "Type": "AWS::IoTEvents::DetectorModel",
            "Properties": {
    "DetectorModelDefinition": {
        "States": [
            {
                "StateName": "idle",
                "OnInput": {
                    "Events": [],
                    "TransitionEvents": [
                        {
                            "EventName": "reached_capacity",
                            "Condition": "$input.leergut_automat_input.state.reported.state == \"full\"",
                            "Actions": [],
                            "NextState": "full"
                        }
                    ]
                },
                "OnEnter": {
                    "Events": []
                },
                "OnExit": {
                    "Events": []
                }
            },
            {
                "StateName": "full",
                "OnInput": {
                    "Events": [],
                    "TransitionEvents": [
                        {
                            "EventName": "emptied",
                            "Condition": "$input.leergut_automat_input.state.reported.state == \"empty\"",
                            "Actions": [],
                            "NextState": "idle"
                        }
                    ]
                },
                "OnEnter": {
                    "Events": [
                        {
                            "EventName": "sendMessage",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "Sns": {
                                        "TargetArn": "arn:aws:sns:eu-central-1:274167473874:leergut_automat_sns_topic",
                                        "Payload": {
                                            "ContentExpression": "'Leergut automat reached capacity'",
                                            "Type": "STRING"
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                "OnExit": {
                    "Events": []
                }
            }
        ],
        "InitialStateName": "idle"
    },
    "DetectorModelDescription": "Detectormodel of the leergut_automat",
    "DetectorModelName": "leergut_automat_detectormodel",
    "EvaluationMethod": "BATCH",
    "RoleArn": "arn:aws:iam::274167473874:role/service-role/IoTEventsRole"
},
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "55dfc17f-b0dd-4096-9b3a-2d4fd58fac35"
                }
            },
            "DependsOn": [
                "LeergutAutomatInput"
            ]
        },
        "LeergutAutomatInput": {
            "Type": "AWS::IoTEvents::Input",
            "Properties": {
                "InputName": "leergut_automat_input",
                "InputDescription": "Input from the leergut_automat",
                "InputDefinition": {
                    "Attributes": [
                        {
                            "JsonPath": "state.reported.state"
                        }
                    ]
                }
            },
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "0391ab49-fcf8-41ae-882a-07afd9e1d295"
                }
            }
        }
    }
}
STACK
}

resource "aws_cloudformation_stack" "freezer_detector_model_stack" {
  depends_on = [
    time_sleep.wait_15_seconds]
  name = "FreezerDetectorModelStack"
  iam_role_arn = aws_iam_role.cloud_formation_to_events_role.arn
  template_body = <<STACK
  {
    "AWSTemplateFormatVersion": "2010-09-09",
    "Metadata": {
        "AWS::CloudFormation::Designer": {
            "1d09b342-fb6d-4c5a-a214-38d9bb999e6d": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 146,
                    "y": 53
                },
                "z": 0,
                "dependson": [
                    "c0b0532d-c4c7-48a6-a1ae-b7cbe3210b28"
                ]
            },
            "c0b0532d-c4c7-48a6-a1ae-b7cbe3210b28": {
                "size": {
                    "width": 60,
                    "height": 60
                },
                "position": {
                    "x": 146,
                    "y": 162
                },
                "z": 0
            },
            "53cfd1b3-32bf-40c2-a061-04398c8923b0": {
                "source": {
                    "id": "1d09b342-fb6d-4c5a-a214-38d9bb999e6d"
                },
                "target": {
                    "id": "c0b0532d-c4c7-48a6-a1ae-b7cbe3210b28"
                },
                "z": 1
            }
        }
    },
    "Resources": {
        "FreezerDetectorModel": {
            "Type": "AWS::IoTEvents::DetectorModel",
            "Properties": {
    "DetectorModelDefinition": {
        "States": [
            {
                "StateName": "idle",
                "OnInput": {
                    "Events": [],
                    "TransitionEvents": [
                        {
                            "EventName": "goToCooling",
                            "Condition": "$input.temperature_sensor_input.state.reported.temp >-13",
                            "Actions": [],
                            "NextState": "cooling"
                        }
                    ]
                },
                "OnEnter": {
                    "Events": [{
                            "EventName": "SendMessageToFreezer",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "IotTopicPublish": {
                                        "MqttTopic": "$aws/things/freezer/shadow/update",
                                        "Payload": {
                                            "ContentExpression": "'{\"state\": {\n        \"desired\": {\n            \"state\": \"idle\"\n        }\n    }\n}'",
                                            "Type": "STRING"
                                        }
                                    }
                                }
                            ]
                        }]
                },
                "OnExit": {
                    "Events": []
                }
            },
            {
                "StateName": "cooling",
                "OnInput": {
                    "Events": [],
                    "TransitionEvents": [
                        {
                            "EventName": "goToIdle",
                            "Condition": "$input.temperature_sensor_input.state.reported.temp <=-13",
                            "Actions": [
                                {
                                    "ClearTimer": {
                                        "TimerName": "Freezer_timer"
                                    }
                                }
                            ],
                            "NextState": "idle"
                        },
                        {
                            "EventName": "Freezer_timelimit_reached",
                            "Condition": "timeout('Freezer_timer')",
                            "Actions": [],
                            "NextState": "untitled_state_2"
                        }
                    ]
                },
                "OnEnter": {
                    "Events": [
                        {
                            "EventName": "Freezer_timer",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "SetTimer": {
                                        "TimerName": "Freezer_timer",
                                        "Seconds": 600
                                    }
                                }
                            ]
                        },
                        {
                            "EventName": "SendMessageToFreezer",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "IotTopicPublish": {
                                        "MqttTopic": "$aws/things/freezer/shadow/update",
                                        "Payload": {
                                            "ContentExpression": "'{\n\"state\": {\n        \"desired\": {\n            \"state\": \"cooling\"\n        }\n    }\n}'",
                                            "Type": "STRING"
                                        }
                                    }
                                }
                            ]
                        }
                    ]
                },
                "OnExit": {
                    "Events": []
                }
            },
            {
                "StateName": "untitled_state_2",
                "OnInput": {
                    "Events": [],
                    "TransitionEvents": [
                        {
                            "EventName": "true",
                            "Condition": "true",
                            "Actions": [],
                            "NextState": "cooling"
                        }
                    ]
                },
                "OnEnter": {
                    "Events": [
                        {
                            "EventName": "Freezer_send_mail",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "Sns": {
                                        "TargetArn": "arn:aws:sns:eu-central-1:274167473874:Freezer",
                                        "Payload": {
                                            "ContentExpression": "'Freezer has been running for more than x (10) minutes'",
                                            "Type": "STRING"
                                        }
                                    }
                                }
                            ]
                        },
                        {
                            "EventName": "Freezer_timer_destroy",
                            "Condition": "true",
                            "Actions": [
                                {
                                    "ClearTimer": {
                                        "TimerName": "Freezer_timer"
                                    }
                                }
                            ]
                        }
                    ]
                },
                "OnExit": {
                    "Events": []
                }
            }
        ],
        "InitialStateName": "idle"
    },
    "DetectorModelDescription": "DetectorModel of the freezer",
    "DetectorModelName": "Freezer_Detector_model",
    "EvaluationMethod": "BATCH",
    "RoleArn": "arn:aws:iam::274167473874:role/service-role/IoTEventsRole"
},
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "1d09b342-fb6d-4c5a-a214-38d9bb999e6d"
                }
            },
            "DependsOn": [
                "TemperatureSensor"
            ]
        },
        "TemperatureSensor": {
            "Type": "AWS::IoTEvents::Input",
            "Properties": {
                "InputName": "temperature_sensor_input",
                "InputDescription": "Input from the temperature_sensor",
                "InputDefinition": {
                    "Attributes": [
                        {
                            "JsonPath": "state.reported.temp"
                        }
                    ]
                }},
            "Metadata": {
                "AWS::CloudFormation::Designer": {
                    "id": "c0b0532d-c4c7-48a6-a1ae-b7cbe3210b28"
                }
            }
        }
    }
}
STACK
}
