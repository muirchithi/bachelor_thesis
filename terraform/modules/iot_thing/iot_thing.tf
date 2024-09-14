#Get Endpoint and save to file
resource "local_file" "endpoint" {
  content  = var.aws_endpoint_address
  filename = "../devices/${var.thing_name}/endpoint.txt"
}

#Get rootca and save to file
data "http" "rootca" {
  url = "https://www.amazontrust.com/repository/AmazonRootCA1.pem"
}
resource "local_file" "rootca_file" {
  content  = data.http.rootca.body
  filename = "../devices/${var.thing_name}/root.pem"
}

#Thing:
resource "aws_iot_thing" "thing" {
  name = var.thing_name

  attributes = {
    Sensor = var.is_sensor
    Actor  = var.is_actor
  }
}

#Certificate:
resource "aws_iot_certificate" "cert" {
  active = true
}

#Export certificates
resource "local_file" "private_key" {
  content  = aws_iot_certificate.cert.private_key
  filename = "../devices/${var.thing_name}/private_key.key"
}
resource "local_file" "certificate_pem" {
  content  = aws_iot_certificate.cert.certificate_pem
  filename = "../devices/${var.thing_name}/certificate_pem.cert.pem"
}
resource "local_file" "public_key" {
  content  = aws_iot_certificate.cert.public_key
  filename = "../devices/${var.thing_name}/public_key.key"
}

#Attach certificate to thing
resource "aws_iot_thing_principal_attachment" "att_cert_to_thing" {
  principal = aws_iot_certificate.cert.arn
  thing     = aws_iot_thing.thing.name
}

#Policy:
resource "aws_iot_policy" "actor_policy" {
  # Policy only applicable if thing is an actor
  count = var.is_actor ? 1 : 0
  name  = "policy_actor_${aws_iot_thing.thing.name}"


  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["iot:Connect"]
        Effect   = "Allow"
        Resource = "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:client/*" #client id: arn:aws:iot:us-east-1:123456789012:client/myClientId
      },
      {
        Action   = ["iot:Publish"]
        Effect   = "Allow"
        Resource = "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:topic/$aws/things/${aws_iot_thing.thing.name}/shadow/update" #topic string: arn:aws:iot:us-east-1:123456789012:topic/myTopicName
      },
      {
        Action = ["iot:UpdateThingShadow"]
        Effect = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}",
        "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}/shadow"]
        # thing name and shadow name: arn:aws:iot:us-east-1:123456789012:thing/thingOne   and   arn:aws:iot:us-east-1:123456789012:thing/thingOne/shadowOne
      },
      {
        Action = ["iot:GetThingShadow"]
        Effect = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}",
        "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}/shadow"]
        # same as above
      },
      {
        Action   = ["iot:Receive"]
        Effect   = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:topic/$aws/things/${aws_iot_thing.thing.name}/shadow/update/delta"]
        #arn:aws:iot:us-east-1:123456789012:topic/myTopicName
      },
      {
        Action   = ["iot:Subscribe"]
        Effect   = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:topicfilter/$aws/things/${aws_iot_thing.thing.name}/shadow/update/delta"]
        #arn:aws:iot:us-east-1:123456789012:topicfilter/myTopicFilter
      }
    ]
  })
}

#Policy:
resource "aws_iot_policy" "sensor_policy" {
  # Policy only applicable if thing is a sensor
  count = var.is_sensor ? 1 : 0
  name  = "policy_sensor_${aws_iot_thing.thing.name}"


  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["iot:Connect"]
        Effect   = "Allow"
        Resource = "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:client/*" #client id: arn:aws:iot:us-east-1:123456789012:client/myClientId
      },
      {
        Action   = ["iot:Publish"]
        Effect   = "Allow"
        Resource = "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:topic/$aws/things/${aws_iot_thing.thing.name}/shadow/update" #topic string: arn:aws:iot:us-east-1:123456789012:topic/myTopicName
      },
      {
        Action = ["iot:UpdateThingShadow"]
        Effect = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}",
        "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}/shadow"]
        # thing name and shadow name: arn:aws:iot:us-east-1:123456789012:thing/thingOne   and   arn:aws:iot:us-east-1:123456789012:thing/thingOne/shadowOne
      },
      {
        Action = ["iot:GetThingShadow"]
        Effect = "Allow"
        Resource = ["arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}",
        "arn:aws:iot:${var.aws_region}:${var.aws_account_id}:thing/${aws_iot_thing.thing.name}/shadow"]
        # same as above
      }
    ]
  })
}

#Attach policy
resource "aws_iot_policy_attachment" "att_actor_policy" {
  # Policy only applicable if thing is an actor
  count  = var.is_actor ? 1 : 0
  policy = aws_iot_policy.actor_policy[0].name
  target = aws_iot_certificate.cert.arn
}

resource "aws_iot_policy_attachment" "att_sensor_policy" {
  # Policy only applicable if thing is a sensor
  count  = var.is_sensor ? 1 : 0
  policy = aws_iot_policy.sensor_policy[0].name
  target = aws_iot_certificate.cert.arn
}



#Create rule
resource "aws_iot_topic_rule" "thing_to_events" {
  # Rule only applicable if thing is a sensor
  count = var.is_sensor ? 1 : 0

  enabled     = true
  name        = "${aws_iot_thing.thing.name}_to_events"
  sql         = "SELECT * FROM '$aws/things/${aws_iot_thing.thing.name}/shadow/update/accepted'"
  sql_version = "2016-03-23"

  iot_events {
    input_name = "${aws_iot_thing.thing.name}_input"
    role_arn   = var.core_to_events_role_arn
  }
}
