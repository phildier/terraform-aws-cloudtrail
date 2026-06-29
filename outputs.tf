output "service_account" {
  description = "CloudTrail service principal."
  value       = "cloudtrail.amazonaws.com"
}
output "trail" {
  value = aws_cloudtrail.account
}
output "bucket" {
  value = aws_s3_bucket.trails
}
output "kms" {
  value = aws_kms_key.cloudtrail
}
output "log_group" {
  value = aws_cloudwatch_log_group.trails
}
