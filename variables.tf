variable "region" {
    description = "The AWS Region where resources will be created"
    type = string
    default= "us-east-1"
}

variable "bucket_name" {
    description = "The name of the s3 bucket to be created"
    type = string
    default= "iac-s3-live"

}