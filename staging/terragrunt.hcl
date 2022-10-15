# Indicate where to source the terraform module from.
locals {
  environment_config = read_terragrunt_config("environment_specific.hcl")
  environment_name   = local.environment_config.locals.environment
  region             = local.environment_config.locals.region
  s3_bucket_name     = local.environment_config.locals.s3_bucket_name
  dynamodb_table     = local.environment_config.locals.dynamodb_table
}


#Indicate what region to deploy the resources into
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
    bucket         = "${local.s3_bucket_name}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region}"
    encrypt        = true
    dynamodb_table = "${local.dynamodb_table}"
  }
}

