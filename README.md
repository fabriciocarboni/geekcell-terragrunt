# AWS automation - ECS Fargate Cluster using Terragrunt

## Diagram
diagram here
## Requirements:

Clone this repo:
```
git clone https://github.com/fabriciocarboni/geekcell-terragrunt
cd geekcell-terragrunt
```

Terraform version 1.3.2 ( https://releases.hashicorp.com/terraform/1.3.2/ )
 
```
  wget https://releases.hashicorp.com/terraform/1.3.2/terraform_1.3.2_linux_amd64.zip
  unzip terraform_1.3.2_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm -fr terraform_1.3.2_linux_amd64.zip
```
Terragrunt version 0.39.1 ( https://github.com/gruntwork-io/terragrunt/releases/tag/v0.39.1 )
 
```
  wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.39.1/terragrunt_linux_amd64
  sudo mv terragrunt_linux_amd64 terragrunt
  sudo mv terragrunt /usr/local/bin/
  sudo chmod u+x /usr/local/bin/terragrunt
```
AWS CLI [(https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

## Credentials
In order to start this:

Copy your aws credentials in your terminal so AWSCLI can have access on it as environment variables. Place the credentials within the commas.
```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

## Steps

1) Initialize Terragrunt
```
cd geekcell-terragrunt/staging
terragrunt init
```
2) Execute plan
```
terragrunt run-all plan --terragrunt-non-interactive
```
For the first plan, Terragrunt will ask if it can create the buckets so we assume yes for all questions with `--terragrunt-non-interactive`.

3) Apply
```
terragrunt run-all apply
```