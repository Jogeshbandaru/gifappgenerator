aws ecr create-repository --repository-name cat-gif-generator
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com
docker build -t cat-gif-generator .
docker tag cat-gif-generator:latest <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/cat-gif-generator:latest
docker push <aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/cat-gif-generator:latest
