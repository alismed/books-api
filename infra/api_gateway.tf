resource "aws_apigatewayv2_api" "best_books_api" {
  name          = "visitors_count_api"
  description   = "This is the REST API for Best Books"
  protocol_type = "HTTP"

  cors_configuration {
    allow_credentials = false
    allow_headers     = []
    allow_methods = [
      "GET",
      "OPTIONS",
      "POST",
    ]
    allow_origins = [
      "*",
    ]
    expose_headers = []
    max_age        = 0
  }

  tags = merge(
    #  module.common.tags,
    {
      description = "API for Best Books"
    }
  )
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.best_books_api.id
  integration_method     = "POST"
  integration_type       = "AWS_PROXY"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.book_lambda_function.invoke_arn
}
/*
resource "aws_apigatewayv2_route" "best_books_api" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "GET /visitors_count"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
*/
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.best_books_api.id
  name        = "$default"
  auto_deploy = true
}