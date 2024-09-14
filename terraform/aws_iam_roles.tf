#Create roles
resource "aws_iam_role" "cloud_formation_to_events_role" {
  name        = "CloudFormationToEventsRole"
  description = "Allows CloudFormation to access IoT Events"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "TrustPolicyStatementThatAllowsCloudformationToAssumeTheAttachedRole"
        Principal = {
          Service = "cloudformation.amazonaws.com"
        }
      },{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "iotevents.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role" "core_to_events_role" {
  name = "CoreToEventsRole"
  path = "/service-role/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service : "iot.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role" "iot_events_role" {
  name        = "IoTEventsRole"
  description = "Allows IoT Events to create a detector model"
  path        = "/service-role/"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "TrustPolicyStatementThatAllowsIoTEventsToAssumeTheAttachedRole"
        Principal = {
          Service = "iotevents.amazonaws.com"
        }
      },
    ]
  })
}

#Attach policies to roles
resource "aws_iam_role_policy_attachment" "att_core_to_events_policy" {
  role       = aws_iam_role.core_to_events_role.name
  policy_arn = aws_iam_policy.core_to_events_policy.arn

}
resource "aws_iam_role_policy_attachment" "att_iot_events_cloud_formation_full_access_policy" {
  role       = aws_iam_role.cloud_formation_to_events_role.name
  policy_arn = aws_iam_policy.iot_events_full_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "att_iot_events_full_access_policy" {
  role       = aws_iam_role.iot_events_role.name
  policy_arn = aws_iam_policy.iot_events_full_access_policy.arn
}
resource "aws_iam_role_policy_attachment" "att_iot_publish_policy" {
  role       = aws_iam_role.iot_events_role.name
  policy_arn = aws_iam_policy.iot_publish_policy.arn
}
resource "aws_iam_role_policy_attachment" "att_pass_role_policy" {
  role       = aws_iam_role.cloud_formation_to_events_role.name
  policy_arn = aws_iam_policy.pass_role_policy.arn
}