resource "aws_cloudtrail" "account" {
  name                          = var.trail["name"]
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn
  depends_on                    = [aws_s3_bucket.trails]
  enable_log_file_validation    = true
  enable_logging                = var.enable_logging
  include_global_service_events = var.trail["include_global_service_events"]
  is_multi_region_trail         = var.is_multi_region_trail
  is_organization_trail         = var.is_organization_trail
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  s3_bucket_name                = aws_s3_bucket.trails.id
  s3_key_prefix                 = var.trail["s3_key_prefix"]
  sns_topic_name                = aws_sns_topic.cloudtrail.name
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.trails.arn}:*"
}


resource "aws_iam_role" "cloudtrail" {
  name               = "${var.trail["name"]}-cloudtrail"
  assume_role_policy = data.aws_iam_policy_document.cloudtrail-assumerole.json
}

data "aws_iam_policy_document" "cloudtrail-assumerole" {
  statement {
    sid    = "AWSCloudTrailAssumeRole201410"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "trails" {
  role   = aws_iam_role.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail.json
}

data "aws_cloudwatch_log_group" "trails" {
  name = "${var.log_group_name}"
}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid    = "AWSCloudTrailCreateLogStream201410"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      data.aws_cloudwatch_log_group.trails.arn
    ]
  }

  statement {
    sid    = "AllowCloudTrailSNSPublish"
    effect = "Allow"
    actions = [
      "sns:Publish",
    ]
    resources = [
      aws_sns_topic.cloudtrail.arn
    ]
  }
}
