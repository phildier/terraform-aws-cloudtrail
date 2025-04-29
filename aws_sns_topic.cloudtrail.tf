resource "aws_sns_topic" "cloudtrail" {
  name_prefix       = "cloudtrail"
  kms_master_key_id = aws_kms_key.cloudtrail.arn
}

resource "aws_sns_topic_policy" "cloudtrail" {
  arn = aws_sns_topic.cloudtrail.arn

  policy = data.aws_iam_policy_document.cloudtrail_sns_policy.json
}

data "aws_iam_policy_document" "cloudtrail_sns_policy" {
  statement {
    sid = "AllowAccount"
    actions = [
      "SNS:GetTopicAttributes",
      "SNS:SetTopicAttributes",
      "SNS:AddPermission",
      "SNS:RemovePermission",
      "SNS:DeleteTopic",
      "SNS:Subscribe",
      "SNS:ListSubscriptionsByTopic",
      "SNS:Publish"
    ]
    principals {
      type        = "AWS"
      identifiers = [local.account_root_arn]
    }
    resources = [aws_sns_topic.cloudtrail.arn]
  }

  statement {
    sid = "AllowCloudTrail"
    actions = [
      "SNS:Publish"
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    resources = [aws_sns_topic.cloudtrail.arn]
  }
}
