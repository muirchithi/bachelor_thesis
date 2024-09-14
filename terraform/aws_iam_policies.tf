#Create policies
#Creates iam policy to allow a service to pass a role to another service
resource "aws_iam_policy" "pass_role_policy" {
  name        = "IAMPassRole"
  description = "Allows to pass an IAM role to another AWS service"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : [
          "iam:GetRole",
          "iam:PassRole"
        ],
        Resource : "*"
      }
    ]
  })
}
#Creates iot events policy to allow full access
resource "aws_iam_policy" "iot_events_full_access_policy" {
  name        = "IoTEventsFullAccess"
  description = "Allows full access to the IoT Events service"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : ["iotevents:*", "SNS:*"]
        Resource : "*"#"arn:aws:iotevents:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"
      }
    ]
  })
}
resource "aws_iam_policy" "iot_publish_policy" {
  name        = "IoTPublish"
  description = "Allows access to the IoT Publish service"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect : "Allow",
        Action : "iot:Publish"
        Resource : "arn:aws:iot:${var.aws_region}:${data.aws_caller_identity.current.account_id}:topic/*"
      }

    ]
  })
}

resource "aws_iam_policy" "core_to_events_policy" {
  name = "CoreToEvents"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : "iotevents:BatchPutMessage",
        Resource : "*"
      }
    ]
  })
}