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
    sid    = "AllowCloudTrail"
    effect = "Allow"
    actions = [
      "sns:*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.cloudtrail.arn]
    }
    resources = [aws_sns_topic.cloudtrail.arn]
  }
}
