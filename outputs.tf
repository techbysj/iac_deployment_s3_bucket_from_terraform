# Output the website URLs
output "s3_website_url" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.static_website_config.website_endpoint
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = aws_cloudfront_distribution.website_distribution.domain_name
}