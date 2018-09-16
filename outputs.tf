output "lambda_zip_id" {
  value = "${data.archive_file.lambda_zip.id}"
}

output "lambda_zip_sha" {
  value = "${data.archive_file.lambda_zip.output_sha}"
}

output "aws_lambda_function_name" {
  value = "${element(concat(aws_lambda_function.lambda.*.function_name, aws_lambda_function.lambda_with_dlq.*.function_name, aws_lambda_function.lambda_with_vpc.*.function_name, aws_lambda_function.lambda_with_vpc_and_dlq.*.function_name), 0)}"
}

output "aws_lambda_function_arn" {
  value = "${element(concat(aws_lambda_function.lambda.*.arn, aws_lambda_function.lambda_with_dlq.*.arn, aws_lambda_function.lambda_with_vpc.*.arn, aws_lambda_function.lambda_with_vpc_and_dlq.*.arn), 0)}"
}

output "aws_lambda_function_kms_key_arn" {
  value = "${element(concat(aws_lambda_function.lambda.*.kms_key_arn, aws_lambda_function.lambda_with_dlq.*.kms_key_arn, aws_lambda_function.lambda_with_vpc.*.kms_key_arn, aws_lambda_function.lambda_with_vpc_and_dlq.*.kms_key_arn), 0)}"
}

//output "aws_lambda_function_environment" {
//  value = "${element(concat(aws_lambda_function.lambda.*.environment, aws_lambda_function.lambda_with_dlq.*.environment, aws_lambda_function.lambda_with_vpc.*.environment, aws_lambda_function.lambda_with_vpc_and_dlq.*.environment), 0)}"
//}

output "aws_lambda_function_filename" {
  value = "${element(concat(aws_lambda_function.lambda.*.filename, aws_lambda_function.lambda_with_dlq.*.filename, aws_lambda_function.lambda_with_vpc.*.filename, aws_lambda_function.lambda_with_vpc_and_dlq.*.filename), 0)}"
}

output "aws_lambda_function_handler" {
  value = "${element(concat(aws_lambda_function.lambda.*.handler, aws_lambda_function.lambda_with_dlq.*.handler, aws_lambda_function.lambda_with_vpc.*.handler, aws_lambda_function.lambda_with_vpc_and_dlq.*.handler), 0)}"
}

output "aws_cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.this.arn}"
}

output "aws_cloudwatch_log_group_name" {
  value = "${aws_cloudwatch_log_group.this.name}"
}

output "aws_cloudwatch_log_group_id" {
  value = "${aws_cloudwatch_log_group.this.id}"
}
