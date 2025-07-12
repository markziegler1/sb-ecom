#!/bin/bash

# GitHub Only Deployment - $0/month
# Everything on GitHub, no other services needed

set -e

echo "🚀 Deploying to GitHub Pages (Free!)"

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not a git repository. Please run:"
    echo "git init"
    echo "git remote add origin https://github.com/your-username/your-repo.git"
    exit 1
fi

# Rename the static file to index.html
if [ -f "index-github.html" ]; then
    echo "📝 Renaming static file to index.html..."
    mv index-github.html index.html
fi

# Add all files
echo "📦 Adding files to git..."
git add .

# Commit changes
echo "💾 Committing changes..."
git commit -m "Add static eCommerce site for GitHub Pages"

# Push to GitHub
echo "🚀 Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployment complete!"
echo ""
echo "🎯 NEXT STEPS:"
echo ""
echo "1. Go to your GitHub repository"
echo "2. Click 'Settings'"
echo "3. Scroll down to 'Pages'"
echo "4. Under 'Source', select 'Deploy from a branch'"
echo "5. Select 'main' branch"
echo "6. Click 'Save'"
echo ""
echo "🎉 Your site will be live at:"
echo "https://your-username.github.io/your-repo-name"
echo ""
echo "💡 Pro tip: This is completely free and runs entirely on GitHub!" 