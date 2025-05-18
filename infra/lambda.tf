resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Service" : "lambda.amazonaws.com"
      },
      "Action" : "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "DynamoDBAccessPolicy" {
  name        = "DynamoDBAccessPolicy"
  description = "DynamoDBAccessPolicy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWrite*",
            "dynamodb:CreateTable",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
          ],
          "Resource" : [
            "arn:aws:dynamodb:*:*:table/Books_Table"
          ],
          "Effect" : "Allow"
        }
      ]
    }
  )
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy_attachment" "lambda_dynamodb_access" {
  name       = "lambda_dynamodb_access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.DynamoDBAccessPolicy.arn
}

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "../app/src/"
  output_path = "../app/target/app.zip"
}

resource "aws_lambda_function" "book_lambda_function" {
  filename      = "../app/target/app.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.lambda_runtime
  handler       = var.lambda_handler
  memory_size   = var.lambda_memory_size
  timeout       = var.lambda_timeout

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }
}


resource "aws_cloudwatch_log_group" "book_lambda_function_cloudwatch" {
  name              = "/aws/lambda/${aws_lambda_function.book_lambda_function.function_name}"
  retention_in_days = 3
}