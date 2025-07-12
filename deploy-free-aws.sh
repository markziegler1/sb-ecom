#!/bin/bash

# Free AWS Serverless Deployment Script
# Hosts ecom.com with frontend + backend for minimal cost

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 Deploying to AWS (Free/Low-Cost Setup)...${NC}"

# Check if Serverless Framework is installed
if ! command -v serverless &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Serverless Framework...${NC}"
    npm install -g serverless
fi

# Check if AWS CLI is configured
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not configured. Please run:${NC}"
    echo "aws configure"
    exit 1
fi

# Build the application
echo -e "${YELLOW}📦 Building application...${NC}"
./mvnw clean package -DskipTests

# Deploy to AWS
echo -e "${YELLOW}🚀 Deploying to AWS Lambda...${NC}"
serverless deploy --stage prod

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Register domain 'ecom.com' in Route 53"
echo "2. Update CloudFront distribution with your domain"
echo "3. Upload frontend files to S3 bucket"
echo "4. Set up SSL certificate in AWS Certificate Manager"

# Get deployment outputs
echo -e "${YELLOW}📊 Deployment outputs:${NC}"
serverless info --stage prod 