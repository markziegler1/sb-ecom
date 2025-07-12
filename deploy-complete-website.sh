#!/bin/bash

# Deploy Complete Website to GitHub Pages
# This creates a fully functional website with multiple pages

set -e

echo "🚀 Deploying Complete Website to GitHub Pages..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please run:"
    echo "git init"
    echo "git remote add origin https://github.com/markziegler1/sb-ecom.git"
    exit 1
fi

# Copy website files to root
echo "📝 Setting up website files..."
if [ -d "website" ]; then
    cp -r website/* .
    rm -rf website
fi

# Add all files
echo "📦 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Add complete website with multiple pages"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Complete website deployed!"
echo ""
echo "🎉 Your website is now live at:"
echo "https://markziegler1.github.io/sb-ecom/"
echo ""
echo "📋 Website Pages:"
echo "- Homepage: https://markziegler1.github.io/sb-ecom/"
echo "- About: https://markziegler1.github.io/sb-ecom/about.html"
echo "- eCommerce Store: https://markziegler1.github.io/sb-ecom/ecommerce.html"
echo ""
echo "💡 Features included:"
echo "✅ Professional homepage with services and projects"
echo "✅ About page with skills and experience"
echo "✅ Contact form (frontend only)"
echo "✅ eCommerce store with products"
echo "✅ Responsive design for all devices"
echo "✅ Navigation between all pages"
echo ""
echo "🔧 To enable GitHub Pages:"
echo "1. Go to https://github.com/markziegler1/sb-ecom/settings/pages"
echo "2. Select 'Deploy from a branch'"
echo "3. Choose 'main' branch"
echo "4. Click 'Save'"
echo ""
echo "🌐 Your complete website will be live in 2-3 minutes!" 