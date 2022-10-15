locals {
  environment_config = read_terragrunt_config(find_in_parent_folders("environment_specific.hcl"))
  service            = "ecr"
  tag                = "v0.0.1"
  environment        = local.environment_config.locals.environment
  region             = local.environment_config.locals.region
  s3_bucket_name     = "${local.environment_config.locals.client}-${local.environment}-${local.service}-4658"
  dynamodb_table     = "${local.environment}-${local.service}-lock-table"
  repository_name    = "demo-nginx-app"
}


#calls the specific module VPC in a external repo
terraform {
  source = "git::git@github.com:fabriciocarboni/geekcell-iac.git//modules/aws_ecr?ref=${local.tag}"
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

inputs = {
  repository_name = "${local.repository_name}"
}