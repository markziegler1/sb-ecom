#!/bin/bash

# Enterprise-Grade Deployment Script
# This script deploys the application to AWS ECS with proper configuration

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="sb-ecom"
AWS_REGION="us-east-1"
ECR_REPOSITORY="sb-ecom-repo"
ECS_CLUSTER="sb-ecom-cluster"
ECS_SERVICE="sb-ecom-service"
TASK_DEFINITION="sb-ecom-task"

echo -e "${GREEN}🚀 Starting Enterprise Deployment...${NC}"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker is not running. Please start Docker first.${NC}"
    exit 1
fi

# Build the application
echo -e "${YELLOW}📦 Building application...${NC}"
./mvnw clean package -DskipTests

# Build Docker image
echo -e "${YELLOW}🐳 Building Docker image...${NC}"
docker build -t $APP_NAME .

# Get AWS account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# Create ECR repository if it doesn't exist
echo -e "${YELLOW}📦 Creating ECR repository...${NC}"
aws ecr create-repository --repository-name $ECR_REPOSITORY --region $AWS_REGION 2>/dev/null || echo "Repository already exists"

# Login to ECR
echo -e "${YELLOW}🔐 Logging into ECR...${NC}"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Tag and push image
echo -e "${YELLOW}📤 Pushing image to ECR...${NC}"
docker tag $APP_NAME:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY:latest

# Update ECS service
echo -e "${YELLOW}🔄 Updating ECS service...${NC}"
aws ecs update-service --cluster $ECS_CLUSTER --service $ECS_SERVICE --force-new-deployment --region $AWS_REGION

# Wait for deployment to complete
echo -e "${YELLOW}⏳ Waiting for deployment to complete...${NC}"
aws ecs wait services-stable --cluster $ECS_CLUSTER --services $ECS_SERVICE --region $AWS_REGION

echo -e "${GREEN}✅ Deployment completed successfully!${NC}"

# Get service URL
echo -e "${YELLOW}🌐 Getting service URL...${NC}"
SERVICE_URL=$(aws elbv2 describe-load-balancers --region $AWS_REGION --query 'LoadBalancers[?contains(LoadBalancerName, `sb-ecom`)].DNSName' --output text)

if [ ! -z "$SERVICE_URL" ]; then
    echo -e "${GREEN}🎉 Your application is available at: https://$SERVICE_URL${NC}"
else
    echo -e "${YELLOW}⚠️  Service URL not found. Check your load balancer configuration.${NC}"
fi

echo -e "${GREEN}📊 Monitor your application at: https://console.aws.amazon.com/ecs/home?region=$AWS_REGION#/clusters/$ECS_CLUSTER/services${NC}" 