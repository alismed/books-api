resource "aws_apigatewayv2_api" "best_books_api" {
  name          = "best_books_api"
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

resource "aws_apigatewayv2_route" "get_all_books" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "GET /books"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "get_book" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "GET /book"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "post_book" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "POST /book"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "patch_book" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "PATCH /book"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_route" "delete_book" {
  api_id    = aws_apigatewayv2_api.best_books_api.id
  route_key = "DELETE /book"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_cloudwatch_log_group" "api_gw_access_logs" {
  name              = "/aws/apigateway/${aws_apigatewayv2_api.best_books_api.name}-access"
  retention_in_days = 3
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.best_books_api.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_access_logs.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      ip                      = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      httpMethod              = "$context.httpMethod"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      protocol                = "$context.protocol"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.book_lambda_function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.best_books_api.execution_arn}/*/*"
}