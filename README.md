Terraform module for Lambda function
====================================

# Intro

Flexible AWS Lambda function module that creates:
- AWS Lambda function (see next to configure optional parameters) with opinionated tagging;
- Zipping of a given directory to push on changes into AWS;
- IAM role for running lambda function and base IAM policy;
- Cloudwatch group for storing Lambda logs

Optional:

- launch (or not) the Lambda function inside a VPC, by providing it a list of subnet(s) and another list of security group(s). 
- provide it with a Dead Letter Queue (DLQ) configuration in order to handle failures, by providing either SNS or SQS ARN.
- provide additional IAM policies to extend Lambda permissions

# Usage

Example usage:

```hcl
module "lambda" {
    source = "github.com/diogoaurelio/terraform-aws-lambda-module"
    version = "v0.0.2"
    
    aws_region     = "eu-west-1"
    aws_account_id = "012345678912"
    environment    = "dev"
    project        = "lambda"
    
    lambda_unique_function_name = "uniquelambda"
    runtime                     = "python3.6"
    handler                     = "handler"
    lambda_iam_role_name        = "uniquelambdarole"
    
    main_lambda_file  = "main"
    
    # These next paths is specific to the one used in blog post series: https://datacenternotes.com/2018/09/01/aws-server-less-data-pipelines-with-terraform-part-1/
    lambda_source_dir = "${path.cwd}/../../../etl/lambda/redshift/src"
    lambda_zip_file_location = "${path.cwd}/../../../etl/lambda/redshift/src/main.zip"
    
    lambda_env_vars          = "${local.lambda_env_vars}"
    
    additional_policy = "${data.aws_iam_policy_document.additional_lambda_policy.json}"
    attach_policy     = true
    
    # configure Lambda function inside a specific VPC
    security_group_ids = ["sg-012345678"]
    subnet_ids         = ["subnet-12345678"]
    
    # DLQ
    use_dead_letter_config_target_arn = true
    dead_letter_config_target_arn     = "${aws_sns_topic.lambda_sns_dql.arn}"
}

# Locals used to specify lambda ENVIRONMENT variables
locals {

  lambda_env_vars = {
    ENVIRONMENT = "${var.environment}"
    REGION      = "${var.aws_region}"
  }
}

# optional additional policy document
data "aws_iam_policy_document" "additional_lambda_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
    ]

    resources = [
      "*",
    ]
  }
}

## SNS topic for lambda failures - Dead Letter Queue (DLQ)
resource "aws_sns_topic" "lambda_sns_dql" {
  name = "lambda-dlq-sns-topic"
}


```


# Authors/Contributors

See the list of [contributors](https://github.com/diogoaurelio/terraform-aws-lambda-module/graphs/contributors) who participated in this project.
