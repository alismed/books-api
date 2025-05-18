variable "region" {
  description = "The AWS region to deploy the infrastructure"
  type        = string
}

variable "profile" {
  description = "The AWS profile to use for authentication"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "dynamodb_table_billing_mode" {
  description = "The billing mode for the DynamoDB table"
  type        = string
  default     = "PROVISIONED"
}

variable "dynamodb_table_read_capacity" {
  description = "The read capacity for the DynamoDB table"
  type        = number
  default     = 5
}

variable "dynamodb_table_write_capacity" {
  description = "The write capacity for the DynamoDB table"
  type        = number
  default     = 5
}

variable "dynamodb_table_hash_key" {
  description = "The hash key for the DynamoDB table"
  type        = string
  default     = "book_id"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "The handler for the Lambda function"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "lambda_runtime" {
  description = "The runtime for the Lambda function"
  type        = string
  default     = "python3.13"
}

variable "lambda_memory_size" {
  description = "The memory size for the Lambda function"
  type        = number
  default     = 128
}

variable "lambda_timeout" {
  description = "The timeout for the Lambda function"
  type        = number
  default     = 15
}
