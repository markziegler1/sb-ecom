#!/bin/bash

# Add eCommerce page to existing GitHub Pages site
# This adds the eCommerce page to your existing https://markziegler1.github.io/

set -e

echo "🚀 Adding eCommerce page to your existing GitHub Pages site..."

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please run:"
    echo "git init"
    echo "git remote add origin https://github.com/markziegler1/sb-ecom.git"
    exit 1
fi

# Add the eCommerce page
echo "📝 Adding ecommerce.html to your site..."

# Add all files
echo "📦 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Add eCommerce page to existing GitHub Pages site"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ eCommerce page added to your site!"
echo ""
echo "🎉 Your eCommerce store is now live at:"
echo "https://markziegler1.github.io/ecommerce.html"
echo ""
echo "💡 You can also add a link to it from your main page (index.html)"
echo ""
echo "📋 To add a link to your main page, add this HTML:"
echo '<a href="ecommerce.html">🛍️ Visit My eCommerce Store</a>' 