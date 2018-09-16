################################################################################
# Lambda KMS key used to encrypt Lambda Environmental Variables
################################################################################

resource "aws_kms_key" "lambda_env_vars_key" {
  description             = "Used to encrypt Lambda function environmental variables"
  is_enabled              = true
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = "30"

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Name        = "${var.lambda_unique_function_name}-lambda-env-vars-key"
  }
}

resource "aws_kms_alias" "lambda_env_vars_key_alias" {
  name          = "alias/${var.environment}-${var.project}-lambda-env-vars-key"
  target_key_id = "${aws_kms_key.lambda_env_vars_key.arn}"
}



data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${var.lambda_source_dir}"
  output_path = "${var.lambda_zip_file_location}"
}

resource "aws_lambda_function" "lambda" {
  # Lambda outside VPC and without DLQ configuration
  count = "${! var.use_dead_letter_config_target_arn && length(var.subnet_ids) == 0 ? 1 : 0}"

  filename         = "${var.lambda_zip_file_location}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${var.environment}-${var.project}-${var.lambda_unique_function_name}"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.lambda_description}"
  handler          = "${var.main_lambda_file}.${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  publish          = "${var.publish}"
  kms_key_arn      = "${aws_kms_key.lambda_env_vars_key.arn}"

  environment {
    variables = "${var.lambda_env_vars}"
  }

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Name        = "${var.lambda_unique_function_name}"
  }
}

resource "aws_lambda_function" "lambda_with_dlq" {
  # Lambda outside VPC and with DLQ configure
  count = "${var.use_dead_letter_config_target_arn && length(var.subnet_ids) == 0 ? 1 : 0}"

  filename         = "${var.lambda_zip_file_location}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${var.environment}-${var.project}-${var.lambda_unique_function_name}"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.lambda_description}"
  handler          = "${var.main_lambda_file}.${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  publish          = "${var.publish}"
  kms_key_arn      = "${aws_kms_key.lambda_env_vars_key.arn}"

  dead_letter_config {
    target_arn = "${var.dead_letter_config_target_arn}"
  }

  environment {
    variables = "${var.lambda_env_vars}"
  }

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Name        = "${var.lambda_unique_function_name}"
  }
}

resource "aws_lambda_function" "lambda_with_vpc" {
  # Lambda inside VPC but without DLQ configuration
  count = "${! var.use_dead_letter_config_target_arn && length(var.subnet_ids) > 0 ? 1 : 0}"

  filename         = "${var.lambda_zip_file_location}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${var.environment}-${var.project}-${var.lambda_unique_function_name}"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.lambda_description}"
  handler          = "${var.main_lambda_file}.${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  publish          = "${var.publish}"
  kms_key_arn      = "${aws_kms_key.lambda_env_vars_key.arn}"

  vpc_config {
    security_group_ids = ["${var.security_group_ids}"]
    subnet_ids         = ["${var.subnet_ids}"]
  }

  environment {
    variables = "${var.lambda_env_vars}"
  }

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Name        = "${var.lambda_unique_function_name}"
  }
}

resource "aws_lambda_function" "lambda_with_vpc_and_dlq" {
  # Lambda inside VPC and with DLQ configuration
  count = "${var.use_dead_letter_config_target_arn && length(var.subnet_ids) > 0 ? 1 : 0}"

  filename         = "${var.lambda_zip_file_location}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  function_name    = "${var.environment}-${var.project}-${var.lambda_unique_function_name}"
  role             = "${aws_iam_role.this.arn}"
  description      = "${var.lambda_description}"
  handler          = "${var.main_lambda_file}.${var.handler}"
  runtime          = "${var.runtime}"
  timeout          = "${var.timeout}"
  memory_size      = "${var.memory_size}"
  publish          = "${var.publish}"
  kms_key_arn      = "${aws_kms_key.lambda_env_vars_key.arn}"

  vpc_config {
    security_group_ids = ["${var.security_group_ids}"]
    subnet_ids         = ["${var.subnet_ids}"]
  }

  dead_letter_config {
    target_arn = "${var.dead_letter_config_target_arn}"
  }

  environment {
    variables = "${var.lambda_env_vars}"
  }

  tags {
    Environment = "${var.environment}"
    Project     = "${var.project}"
    Name        = "${var.lambda_unique_function_name}"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.environment}-${var.project}-${var.lambda_unique_function_name}"
  retention_in_days = "${var.lambda_log_retention_period}"
}
