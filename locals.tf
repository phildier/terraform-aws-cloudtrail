locals {
  account_id       = data.aws_caller_identity.current.account_id
  account_root_arn = "arn:aws:iam::${local.account_id}:root"
  trails_bucket    = "trails-${data.aws_caller_identity.current.account_id}"
  logging = {
    target_bucket = "s3accesslogging-${data.aws_caller_identity.current.account_id}"
    target_prefix = "trails"
  }
}
