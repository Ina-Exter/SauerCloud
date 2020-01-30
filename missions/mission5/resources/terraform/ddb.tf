resource "aws_dynamodb_table" "AWSkeys" {
  name           = "AWSkeys-${var.id}"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "User"

  attribute {
    name = "User"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "hades-keys" {
  table_name = aws_dynamodb_table.AWSkeys.name
  hash_key   = aws_dynamodb_table.AWSkeys.hash_key

  item = <<ITEM
{
  "User": {"S": "hades-${var.id}"},
  "AWSKey": {"S": "${aws_iam_access_key.SauerCloud-mission5-iam-admin-hades-keys.id}"},
  "AWSSecretKey": {"S": "${aws_iam_access_key.SauerCloud-mission5-iam-admin-hades-keys.secret}"}
}
ITEM
}
