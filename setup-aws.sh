#!/bin/bash

# AWS Infrastructure Setup Script
# This script creates all necessary AWS resources for production deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration - CHANGE THESE VALUES
AWS_REGION="us-east-1"
PROJECT_NAME="sb-ecom"
DB_PASSWORD="YourSecurePassword123!"  # CHANGE THIS!
JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"

echo -e "${GREEN}🚀 Setting up AWS Infrastructure for eCommerce Platform...${NC}"

# Check AWS CLI
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI not found. Please install it first:${NC}"
    echo "https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html"
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo -e "${RED}❌ AWS credentials not configured. Please run:${NC}"
    echo "aws configure"
    exit 1
fi

echo -e "${GREEN}✅ AWS CLI configured${NC}"

# Get AWS Account ID
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo -e "${YELLOW}📋 AWS Account ID: $AWS_ACCOUNT_ID${NC}"

# 1. Create ECR Repository
echo -e "${YELLOW}📦 Creating ECR repository...${NC}"
aws ecr create-repository --repository-name $PROJECT_NAME --region $AWS_REGION 2>/dev/null || echo "Repository already exists"

# 2. Create RDS PostgreSQL Database
echo -e "${YELLOW}🗄️ Creating RDS PostgreSQL database...${NC}"
aws rds create-db-instance \
  --db-instance-identifier $PROJECT_NAME-db \
  --db-instance-class db.t3.micro \
  --engine postgres \
  --master-username sb_ecom_user \
  --master-user-password "$DB_PASSWORD" \
  --allocated-storage 20 \
  --storage-type gp2 \
  --backup-retention-period 7 \
  --enable-performance-insights \
  --region $AWS_REGION 2>/dev/null || echo "Database already exists"

# 3. Create ElastiCache Redis
echo -e "${YELLOW}🔴 Creating ElastiCache Redis...${NC}"
aws elasticache create-replication-group \
  --replication-group-id $PROJECT_NAME-redis \
  --replication-group-description "Redis for eCommerce" \
  --node-type cache.t3.micro \
  --num-cache-clusters 1 \
  --region $AWS_REGION 2>/dev/null || echo "Redis already exists"

# 4. Create ECS Cluster
echo -e "${YELLOW}🐳 Creating ECS cluster...${NC}"
aws ecs create-cluster --cluster-name $PROJECT_NAME-cluster --region $AWS_REGION 2>/dev/null || echo "Cluster already exists"

# 5. Create Application Load Balancer
echo -e "${YELLOW}⚖️ Creating Application Load Balancer...${NC}"
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=is-default,Values=true" --query 'Vpcs[0].VpcId' --output text --region $AWS_REGION)
SUBNET_IDS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query 'Subnets[0:2].SubnetId' --output text --region $AWS_REGION)

aws elbv2 create-load-balancer \
  --name $PROJECT_NAME-alb \
  --subnets $SUBNET_IDS \
  --security-groups $(aws ec2 describe-security-groups --filters "Name=group-name,Values=default" --query 'SecurityGroups[0].GroupId' --output text --region $AWS_REGION) \
  --region $AWS_REGION 2>/dev/null || echo "Load balancer already exists"

# 6. Store secrets in Parameter Store
echo -e "${YELLOW}🔐 Storing secrets in Parameter Store...${NC}"
aws ssm put-parameter --name "/$PROJECT_NAME/prod/database/password" --value "$DB_PASSWORD" --type "SecureString" --region $AWS_REGION 2>/dev/null || echo "Database password already stored"
aws ssm put-parameter --name "/$PROJECT_NAME/prod/jwt/secret" --value "$JWT_SECRET" --type "SecureString" --region $AWS_REGION 2>/dev/null || echo "JWT secret already stored"

echo -e "${GREEN}✅ AWS Infrastructure setup complete!${NC}"
echo -e "${YELLOW}⏳ Waiting for database to be available...${NC}"

# Wait for database to be available
aws rds wait db-instance-available --db-instance-identifier $PROJECT_NAME-db --region $AWS_REGION

# Get database endpoint
DB_ENDPOINT=$(aws rds describe-db-instances --db-instance-identifier $PROJECT_NAME-db --query 'DBInstances[0].Endpoint.Address' --output text --region $AWS_REGION)
echo -e "${GREEN}✅ Database endpoint: $DB_ENDPOINT${NC}"

# Get Redis endpoint
REDIS_ENDPOINT=$(aws elasticache describe-replication-groups --replication-group-id $PROJECT_NAME-redis --query 'ReplicationGroups[0].NodeGroups[0].PrimaryEndpoint.Address' --output text --region $AWS_REGION 2>/dev/null || echo "Redis not ready yet")

if [ "$REDIS_ENDPOINT" != "None" ] && [ "$REDIS_ENDPOINT" != "" ]; then
    echo -e "${GREEN}✅ Redis endpoint: $REDIS_ENDPOINT${NC}"
else
    echo -e "${YELLOW}⚠️ Redis endpoint not ready yet. Check AWS Console.${NC}"
fi

# Get Load Balancer DNS
ALB_DNS=$(aws elbv2 describe-load-balancers --names $PROJECT_NAME-alb --query 'LoadBalancers[0].DNSName' --output text --region $AWS_REGION 2>/dev/null || echo "Load balancer not ready yet")

if [ "$ALB_DNS" != "None" ] && [ "$ALB_DNS" != "" ]; then
    echo -e "${GREEN}✅ Load Balancer DNS: $ALB_DNS${NC}"
else
    echo -e "${YELLOW}⚠️ Load balancer not ready yet. Check AWS Console.${NC}"
fi

echo -e "${GREEN}🎉 AWS Infrastructure setup complete!${NC}"
echo -e "${YELLOW}📋 Next steps:${NC}"
echo "1. Update your application configuration with the endpoints above"
echo "2. Run: ./deploy.sh"
echo "3. Monitor in AWS Console: https://console.aws.amazon.com/ecs/home?region=$AWS_REGION" 