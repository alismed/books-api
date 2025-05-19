# AWS Serverless API with authentication

This project implements a serverless REST API using AWS Lambda and API Gateway for managing a book collection. The API is secured with authentication and deployed using Infrastructure as Code (Terraform). It provides endpoints for retrieving, updating, and deleting books, with data persistence handled through DynamoDB.

Key features:
- Serverless architecture using AWS Lambda
- RESTful API endpoints via API Gateway
- Authentication and authorization
- Infrastructure as Code using Terraform
- Automated testing and CI/CD pipeline

## Requirements

### Local Development
- Python >= 3.12
- AWS CLI configured
- Terraform CLI

### AWS Resources
- AWS Account with appropriate permissions
- S3 Bucket for Terraform state

## Setup Instructions

### 1. AWS Configuration
```shell
# Configure AWS CLI credentials
aws configure
```

### 2. Application Setup

Run linting checks with flake8 to ensure code quality and style consistency:

```shell
flake8 app/
```

Run tests locally

```shell
# 
python -m pytest --cov=app app/test/

# 
python -m pytest app/test/
```

### Testing Actions Locally

1. Install Act:
```bash
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

2. Setup test environment:
```bash
# Create test directory if not exists
mkdir -p .act

# Create env file with credentials
echo "AWS_ACCESS_KEY_ID=test" > .act/.env
echo "AWS_SECRET_ACCESS_KEY=test" >> .act/.env
echo "AWS_DEFAULT_REGION=us-east-1" >> .act/.env

# Create pull request event simulation
cat > .act/pull_request.json << EOF
{
  "pull_request": {
    "number": 1,
    "body": "Test PR",
    "head": {
      "ref": "feature/test"
    }
  }
}
EOF
```

3. Run test workflow:
```bash
# List available workflows
act -l

# Run workflow with pull request event
act pull_request -e .act/pull_request.json

# Run specific workflow
act -W .github/workflows/main.yaml \
    -e .act/pull_request.json \
    --secret-file .act/.env \
    --container-architecture linux/amd64

# Run with verbose output
act -v pull_request -e .act/pull_request.json --secret-file .act/.env
```

## Testing api after deploy

Get the variables in the terraform output

```shell
# Get all books
curl -X GET "https://<api-id>.execute-api.<region>.amazonaws.com/books"

# Get a specific book
curl -X GET "https://<api-id>.execute-api.<region>.amazonaws.com/book?book_id=1"

# Update a specific book
curl -X PATCH "https://<api-id>.execute-api.<region>.amazonaws.com/book" \
  -H "Content-Type: application/json" \
  -d '{"book_id": "1", "update_key": "title", "update_value": "New Title"}'

# Delete a specific book
curl -X DELETE "https://<api-id>.execute-api.<region>.amazonaws.com/book" \
  -H "Content-Type: application/json" \
  -d '{"book_id": "1"}'
```
