#!/bin/bash

# Super Simple Deployment Script
# Gets your eCommerce site online in 5 minutes

set -e

echo "🚀 Deploying your eCommerce site..."

# Build the application
echo "📦 Building your Spring Boot app..."
./mvnw clean package -DskipTests

echo ""
echo "✅ Build complete!"
echo ""
echo "🎯 NEXT STEPS:"
echo ""
echo "1. Go to https://railway.app"
echo "2. Sign up with GitHub"
echo "3. Click 'New Project' → 'Deploy from GitHub repo'"
echo "4. Select this repository"
echo "5. Railway will automatically deploy your app"
echo ""
echo "6. Go to https://netlify.com"
echo "7. Sign up with GitHub"
echo "8. Drag and drop the 'index.html' file to deploy"
echo ""
echo "9. Update the API_URL in index.html with your Railway URL"
echo ""
echo "🎉 Your site will be live in 5 minutes!"
echo ""
echo "💡 Pro tip: Railway automatically creates a PostgreSQL database for you!" 