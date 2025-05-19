output "aws_region" {
  description = "The AWS region where the resources are created"
  value       = var.region
}

output "table_name" {
  value = aws_dynamodb_table.books_table.name
}

output "table_arn" {
  value = aws_dynamodb_table.books_table.arn
}

output "table_items" {
  value = aws_dynamodb_table_item.seed_items
}

output "seeded_items_count" {
  description = "Number of items seeded in the DynamoDB table"
  value       = length(aws_dynamodb_table_item.seed_items)
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = try(aws_lambda_function.book_lambda_function.arn, "")
}

output "lambda_function_name" {
  description = "The name of the Lambda Function"
  value       = try(aws_lambda_function.book_lambda_function.function_name, "")
}

output "lambda_function_version" {
  description = "Latest published version of Lambda Function"
  value       = try(aws_lambda_function.book_lambda_function.version, "")
}

output "lambda_function_last_modified" {
  description = "The date Lambda Function resource was last modified"
  value       = try(aws_lambda_function.book_lambda_function.last_modified, "")
}

output "aws_apigatewayv2_api_id" {
  description = "The ID of the API Gateway"
  value       = try(aws_apigatewayv2_api.best_books_api.id, "")
}

output "aws_apigatewayv2_api_name" {
  description = "The name of the API Gateway"
  value       = try(aws_apigatewayv2_api.best_books_api.name, "")
}

output "aws_apigatewayv2_api_endpoint" {
  description = "The endpoint of the API Gateway"
  value       = try(aws_apigatewayv2_api.best_books_api.api_endpoint, "")
}

output "aws_apigatewayv2_api_stage" {
  description = "The stage of the API Gateway"
  value       = try(aws_apigatewayv2_stage.default.id, "")
}

output "aws_apigatewayv2_routes" {
  description = "The routes of the API Gateway"
  value = [
    aws_apigatewayv2_route.get_all_books.id,
    aws_apigatewayv2_route.get_book.id,
    aws_apigatewayv2_route.post_book.id,
    aws_apigatewayv2_route.patch_book.id,
    aws_apigatewayv2_route.delete_book.id,
  ]
}

output "aws_api_gateway_stage_deployment_id" {
  description = "The ID of the API Gateway Stage Deployment"
  value       = aws_apigatewayv2_stage.default.deployment_id
}

output "aws_api_gateway_stage_api_id" {
  description = "The ID of the API Gateway Stage API"
  value       = aws_apigatewayv2_stage.default.api_id
}

output "api_gateway_url" {
  value = aws_apigatewayv2_api.best_books_api.api_endpoint
}

output "aws_apigatewayv2_integration_id" {
  description = "The ID of the API Gateway integration"
  value       = try(aws_apigatewayv2_integration.lambda_integration.id, "")
}

output "aws_apigatewayv2_integration_uri" {
  description = "The URI of the API Gateway integration"
  value       = try(aws_apigatewayv2_integration.lambda_integration.integration_uri, "")
}

output "aws_apigatewayv2_integration_type" {
  description = "The type of the API Gateway integration"
  value       = try(aws_apigatewayv2_integration.lambda_integration.integration_type, "")
}
