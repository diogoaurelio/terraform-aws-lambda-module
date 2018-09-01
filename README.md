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
    version = "v0.0.1"
    
    aws_region     = "${var.aws_region}"
    aws_account_id = "${var.account_id}"
    environment    = "${var.environment}"
    project        = "${var.project}"
    
    lambda_unique_function_name = "${var.lambda_unique_function_name}"
    runtime                     = "${var.lambda_runtime}"
    handler                     = "${var.lambda_handler}"
    lambda_iam_role_name        = "${var.lambda_role_name}"
    logs_kms_key_arn            = "${module.logs_bucket.aws_kms_key_arn}"
    
    main_lambda_file  = "${var.redshift_loader_main_lambda_file}"
    lambda_source_dir = "${local.lambda_source_dir}"
    
    lambda_zip_file_location = "${var.lambda_zip_file_localtion}"
    lambda_env_vars          = "${var.lambda_env_vars}"
    
    additional_policy = "${data.aws_iam_policy_document.additional_lambda_policy.json}"
    attach_policy     = true
    
    # configure Lambda function inside a specific VPC
    security_group_ids = ["${var.lamda_security_group}"]
    subnet_ids         = ["${var.lamda_subnet_ids)}"]
    
    # DLQ
    use_dead_letter_config_target_arn = true
    dead_letter_config_target_arn     = "${var.lambda_sns_dql.arn}"
}

```


# Authors/Contributors

See the list of [contributors](https://github.com/diogoaurelio/terraform-aws-lambda-module/graphs/contributors) who participated in this project.
