provider "aws" {
    region = var.region #use variable for region
}

resource "aws_s3_bucket" "static_website_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Static Website Bucket"
    Environment = "production"
  }
}

# Disable public access block to allow website hosting
resource "aws_s3_bucket_public_access_block" "static_website_pab" {
    bucket = aws_s3_bucket.static_website_bucket.id
    
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
}

# Configure bucket for website hosting
resource "aws_s3_bucket_website_configuration" "static_website_config" {
    bucket = aws_s3_bucket.static_website_bucket.id

    index_document {
        suffix = "index.html"
    }
    error_document {
        key = "error.html"
    }
}

# Allow public read access for website content
# amazonq-ignore-next-line
resource "aws_s3_bucket_policy" "static_website_policy" {
    bucket = aws_s3_bucket.static_website_bucket.id
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Sid       = "AllowCloudFrontAccess"
                Effect    = "Allow"
                Principal = {
                    Service = "cloudfront.amazonaws.com"
                }
                Action    = "s3:GetObject"
                Resource  = "${aws_s3_bucket.static_website_bucket.arn}/*"
                Condition = {
                    StringEquals = {
                        "AWS:SourceArn" = aws_cloudfront_distribution.website_distribution.arn
                    }
                }
            }
        ]
    })
    
    depends_on = [aws_s3_bucket_public_access_block.static_website_pab]
}


