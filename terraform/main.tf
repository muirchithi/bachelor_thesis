#Caller identity
data "aws_caller_identity" "current" {}

#Get Endpoint and save to file
data "aws_iot_endpoint" "user" {
  endpoint_type = "iot:Data-ATS"
}

#Wait for necessary iam roles to be created before continuing
resource "time_sleep" "wait_15_seconds" {
  depends_on = [aws_iam_role.cloud_formation_to_events_role]

  create_duration = "30s"
}



