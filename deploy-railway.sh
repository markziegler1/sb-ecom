#!/bin/bash

# Railway Deployment Script
# Ultra-low cost production deployment

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Deploying to Railway (Ultra-Low Cost)...${NC}"

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Railway CLI...${NC}"
    npm install -g @railway/cli
fi

# Build the application
echo -e "${YELLOW}📦 Building application...${NC}"
./mvnw clean package -DskipTests

# Login to Railway (if not already logged in)
echo -e "${YELLOW}🔐 Logging into Railway...${NC}"
railway login

# Deploy to Railway
echo -e "${YELLOW}🚀 Deploying to Railway...${NC}"
railway up

echo -e "${GREEN}✅ Deployment complete!${NC}"
echo -e "${YELLOW}🌐 Your app is now live on Railway!${NC}"
echo -e "${YELLOW}📊 Monitor at: https://railway.app/dashboard${NC}" 