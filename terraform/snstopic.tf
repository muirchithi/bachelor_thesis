resource "aws_sns_topic" "backautomat_sns_topic" {
  name = "backautomat_sns_topic"
}

resource "aws_sns_topic" "freezer_sns_topic" {
  name = "freezer_sns_topic"
}

resource "aws_sns_topic" "leergut_automat_sns_topic" {
  name = "leergut_automat_sns_topic"
}

resource "aws_sns_topic_policy" "backautomat_sns_topic_policy" {
  arn = aws_sns_topic.backautomat_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_policy_document.json
}

resource "aws_sns_topic_policy" "freezer_sns_topic_policy" {
  arn = aws_sns_topic.freezer_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_policy_document.json
}

resource "aws_sns_topic_policy" "leergut_automat_sns_topic_policy" {
  arn = aws_sns_topic.leergut_automat_sns_topic.arn
  policy = data.aws_iam_policy_document.sns_policy_document.json
}

#subscriptions
resource "aws_sns_topic_subscription" "subscription_backautomat" {
  topic_arn = aws_sns_topic.backautomat_sns_topic.arn
  protocol = "email"
  endpoint = "DennisKlug1yt@gmail.com"
}
resource "aws_sns_topic_subscription" "subscription_freezer" {
  topic_arn = aws_sns_topic.freezer_sns_topic.arn
  protocol = "email"
  endpoint = "DennisKlug1yt@gmail.com"
}
resource "aws_sns_topic_subscription" "subscription_leergut_automat" {
  topic_arn = aws_sns_topic.leergut_automat_sns_topic.arn
  protocol = "email"
  endpoint = "DennisKlug1yt@gmail.com"
}

data "aws_iam_policy_document" "sns_policy_document" {
  policy_id = "__default_policy_ID"
  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission"
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "274167473874"
      ]
    }

    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "*"]
    }

    resources = [
      "*"
    ]

    sid = "__default_statement_ID"
  }
}