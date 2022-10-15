locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
  service            = "vpc"
  tag                = "v0.0.1"
  environment        = local.environment_config.locals.environment
  region             = local.environment_config.locals.region
  s3_bucket_name     = "${local.environment_config.locals.client}-${local.environment}-${local.service}"
  dynamodb_table     = "${local.environment}-${local.service}-lock-table"
}


#calls the specific module VPC from external repo
terraform {
  source = "git::git@github.com:fabriciocarboni/geekcell-iac.git//modules/aws_vpc?ref=${local.tag}"
}

# Indicate what region to deploy the resources into
generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
    provider "aws" {
    region = "${local.region}"
  }
  EOF
}

# # generate provider
# generate "provider" {
#   path = "provider.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = <<EOF
#     provider "aws" {
#     region = "us-east-1"
#     assume_role {
#         role_arn = "arn:aws:iam::${get_aws_account_id()}:role/terragrunt"
#         }
#     }
#     EOF
# }



remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "${local.s3_bucket_name}"
    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_table}"
  }
}
