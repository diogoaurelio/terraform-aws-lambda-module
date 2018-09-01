Terraform module for Lambda function
====================================

Flexible AWS Lambda function module that creates:
- AWS Lambda function (see next to configure optional parameters) with opinionated tagging;
- Zipping of a given directory to push on changes into AWS;
- IAM role for running lambda function and base IAM policy;
- Cloudwatch group for storing Lambda logs

Optional:

- launch (or not) the Lambda function inside a VPC, by providing it a list of subnet(s) and another list of security group(s). 
- provide it with a Dead Letter Queue (DLQ) configuration in order to handle failures, by providing either SNS or SQS ARN.
- provide additional IAM policies to extend Lambda permissions


# Authors/Contributors

See the list of [contributors](https://github.com/diogoaurelio//graphs/contributors) who participated in this project.
