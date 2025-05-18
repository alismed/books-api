output "table_name" {
  value = aws_dynamodb_table.books_table.name
}

output "table_arn" {
  value = aws_dynamodb_table.books_table.arn
}

output "table_items" {
  value = aws_dynamodb_table_item.seed_items
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
