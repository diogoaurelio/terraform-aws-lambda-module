resource "aws_iam_role" "this" {
  name               = "${var.lambda_iam_role_name}"
  assume_role_policy = "${data.aws_iam_policy_document.this.json}"
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_policy_attachment" "this_logs" {
  name       = "${var.lambda_unique_function_name}"
  roles      = ["${aws_iam_role.this.name}"]
  policy_arn = "${aws_iam_policy.this_logs.arn}"
}

resource "aws_iam_policy" "this_logs" {
  name   = "${aws_iam_role.this.name}"
  policy = "${data.aws_iam_policy_document.this_logs.json}"
}

data "aws_iam_policy_document" "this_logs" {
  statement {
    effect = "Allow"
    sid    = "allowLoggingToCloudWatch"

    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
    ]

    resources = [
      "${aws_cloudwatch_log_group.this.arn}",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:DescribeKey",
      "kms:ListKeys",
      "kms:GenerateDataKey",
    ]

    resources = [
      "${var.kms_key_arn}",
    ]
  }
}

# Possibility to attach another policy document
resource "aws_iam_policy" "this_additional" {
  count = "${var.attach_policy ? 1 : 0}"

  name   = "${var.environment}-${var.project}-${var.lambda_unique_function_name}-policy"
  policy = "${var.additional_policy}"
}

resource "aws_iam_policy_attachment" "this_additional" {
  count = "${var.attach_policy ? 1 : 0}"

  name       = "${var.lambda_unique_function_name}-policy"
  roles      = ["${aws_iam_role.this.name}"]
  policy_arn = "${aws_iam_policy.this_additional.arn}"
}
