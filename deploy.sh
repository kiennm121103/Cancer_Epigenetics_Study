#!/bin/bash

# Deployment Script for Penguin Shiny App
# This script helps deploy your app to GitHub Pages

echo "🚀 Cancer Epigenetics Study - Deployment Script"
echo "================================================"
echo ""

# Check if we're in the right directory
if [ ! -f "deploy_app/app.R" ]; then
    echo "❌ Error: deploy_app/app.R not found"
    echo "Please run this script from the project root directory"
    exit 1
fi

echo "✓ Project directory verified"
echo ""

# Step 1: Check if Quarto is installed
echo "📦 Checking dependencies..."
if command -v quarto &> /dev/null; then
    echo "✓ Quarto is installed ($(quarto --version))"
else
    echo "⚠️  Quarto not found. Please install from: https://quarto.org/"
    echo "Or run: sudo apt install quarto"
    exit 1
fi

# Step 2: Install Quarto Shinylive extension
echo ""
echo "📥 Installing Quarto Shinylive extension..."
quarto add quarto-ext/shinylive --no-prompt
echo "✓ Extension installed"

# Step 3: Render Quarto website
echo ""
echo "🔨 Building website..."
quarto render
echo "✓ Website built to docs/"

# Step 4: Initialize git if needed
echo ""
if [ ! -d ".git" ]; then
    echo "📁 Initializing git repository..."
    git init
    echo "✓ Git initialized"
else
    echo "✓ Git already initialized"
fi

# Step 5: Stage files
echo ""
echo "📝 Staging files for commit..."
git add .gitignore
git add docs/
git add deploy_app/
git add *.qmd
git add _quarto.yml
git add README.md
git add DEPLOYMENT.md
echo "✓ Files staged"

# Step 6: Commit
echo ""
echo "💾 Creating commit..."
git commit -m "Deploy: Penguin Analysis app with Quarto and Shinylive" || echo "Nothing to commit or already committed"

# Step 7: Instructions for GitHub
echo ""
echo "================================================"
echo "✅ Local build complete!"
echo ""
echo "📋 Next steps to deploy to GitHub Pages:"
echo ""
echo "1. Create a new repository on GitHub:"
echo "   https://github.com/new"
echo ""
echo "2. Run these commands (replace YOUR_USERNAME):"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/penguin-analysis.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "3. Enable GitHub Pages:"
echo "   - Go to Settings → Pages"
echo "   - Source: main branch"
echo "   - Folder: /docs"
echo "   - Click Save"
echo ""
echo "4. Wait 2-3 minutes, then visit:"
echo "   https://YOUR_USERNAME.github.io/penguin-analysis/"
echo ""
echo "================================================"
echo ""
echo "📄 For detailed instructions, see DEPLOYMENT.md"
echo ""
