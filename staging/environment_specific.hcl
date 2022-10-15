#Environment specific propeties
locals {
    client         = "geekcell"
    environment    = "staging"
    provider       = "aws"
    region         = "us-east-1"
    azs            = ["us-east-1a", "us-east-1b"]
    s3_bucket_name = "${local.client}-terraform-state-${local.environment}-45468"
    dynamodb_table = "${local.environment}-lock-table"
}

