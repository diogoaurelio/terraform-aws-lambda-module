variable "aws_region" {
  description = "AWS Region"
}

variable "aws_account_id" {
  description = "AWS Account ID"
}

variable "environment" {
  description = "Environment of the Stack"
  default     = "dev"
}

variable "project" {
  default = "redshift-loader"
}

variable "output_lambda_zip" {
  description = "Name of the .zip file generated before uploading the Lambda"
  default     = "lambda"
}

variable "lambda_zip_file_location" {
  description = "Zip file location"
}

variable "main_lambda_file" {
  description = "Name of the main lambda .py file inside the 'src' folder"
}

variable "lambda_unique_function_name" {
  description = "Name of the lambda .py file"
}

variable "runtime" {
  description = "The languange/engine under which Lambda should run; see https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime"
  default     = "python3.6"
}

variable "handler" {
  description = "The name of the function handler inside the lambda main file"
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds"
  default     = 300
}

variable "memory_size" {
  default = 128
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  default     = true
}

variable "lambda_iam_role_name" {
  description = "Description of the role created for the lambda"
  default     = "lambda-role"
}

variable "lambda_env_vars" {
  type        = "map"
  description = "Environmental variables to expose to Lambda function"
}

variable "lambda_source_dir" {
  description = "Path to find source lambda files"
}

variable "additional_policy" {
  description = "An addional policy document (JSON) to attach to the Lambda function"
  default     = ""
}

variable "attach_policy" {
  description = "Set this to true if using the policy variable"
  default     = false
}

variable "logs_kms_key_arn" {
  description = "ARN to the KMS key which lambda should be using to decrypt and encrypt environmental variables"
}

variable "ssm_param_resource_arn" {
  description = "ARN of SSM parameter to retrieve; for example, DB password"
  default     = "*"
}

variable "lambda_description" {
  default = ""
}

variable "lambda_log_retention_period" {
  description = ""
  default     = 1
}

variable "security_group_ids" {
  description = "Optional variable, use if you want to configure Lambda function to be executed inside a specific VPC"
  type        = "list"
  default     = []
}

variable "subnet_ids" {
  description = "Optional variable, use if you want to configure Lambda function to be executed inside a specific VPC"
  type        = "list"
  default     = []
}

variable "dead_letter_config_target_arn" {
  default = "abc"
}

variable "use_dead_letter_config_target_arn" {
  default = false
}
