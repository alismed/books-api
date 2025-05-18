locals {
  json_data = file("${path.module}/dynamodb_items.json")
  books     = jsondecode(local.json_data)
}

resource "aws_dynamodb_table_item" "seed_items" {
  for_each   = local.books
  table_name = aws_dynamodb_table.books_table.name
  hash_key   = aws_dynamodb_table.books_table.hash_key
  item       = jsonencode(each.value)

  depends_on = [aws_dynamodb_table.books_table]
}