# GitHub Deployment Steps

Your website is ready! Follow these steps to deploy:

## Step 1: Create GitHub Repository

1. Go to: https://github.com/new
2. **Repository name**: `penguin-analysis` (or choose your own name)
3. **Description**: "Palmer Penguins interactive analysis with Shinylive and Quarto"
4. **Visibility**: Public
5. **DO NOT** check "Initialize this repository with a README"
6. Click **Create repository**

## Step 2: Connect Your Local Repository to GitHub

Replace `YOUR_USERNAME` with your GitHub username and `REPO_NAME` with the repository name you chose:

```bash
cd /home/kiennm/Cancer_Epigenetics_Study
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git branch -M main
git push -u origin main
```

Example (if your username is `xvdope-ki0n-nguy0n0m0nh` and repo is `penguin-analysis`):
```bash
git remote add origin https://github.com/xvdope-ki0n-nguy0n0m0nh/penguin-analysis.git
git branch -M main
git push -u origin main
```

## Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** → **Pages** (in left sidebar)
3. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
4. Click **Save**
5. Wait 2-3 minutes for deployment

## Step 4: Access Your Live Website

Your website will be available at:
```
https://YOUR_USERNAME.github.io/REPO_NAME/
```

Example:
```
https://xvdope-ki0n-nguy0n0m0nh.github.io/penguin-analysis/
```

## Pages on Your Website

Once deployed, you can access:
- **Home page**: `https://YOUR_USERNAME.github.io/REPO_NAME/`
- **Interactive Penguin App**: `https://YOUR_USERNAME.github.io/REPO_NAME/penguins-app.html`
- **About page**: `https://YOUR_USERNAME.github.io/REPO_NAME/about.html`
- **Quick Start Guide**: `https://YOUR_USERNAME.github.io/REPO_NAME/QUICKSTART.html`
- **Deployment Guide**: `https://YOUR_USERNAME.github.io/REPO_NAME/DEPLOYMENT.html`

## Troubleshooting

### If git push asks for authentication:
- You may need to use a Personal Access Token (PAT) instead of password
- Create one at: https://github.com/settings/tokens
- Or use GitHub CLI: `gh auth login`

### If you get "remote origin already exists":
```bash
git remote remove origin
# Then run the git remote add command again
```

## Making Updates

After making changes to your Quarto files:

```bash
# Rebuild the website
quarto render

# Commit and push changes
git add .
git commit -m "Update website content"
git push
```

Your changes will appear on GitHub Pages in 2-3 minutes!
