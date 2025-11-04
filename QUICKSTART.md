# Quick Start: Deploy Your Penguin App

I've set up everything you need! Here are the two deployment methods:

---

## Option 1: Automated Deployment (Easiest) 🚀

### Step 1: Install Quarto
```bash
# Check if installed
quarto --version

# If not installed, download from:
# https://quarto.org/docs/get-started/
# Or on Ubuntu:
sudo apt install quarto
```

### Step 2: Run Deployment Script
```bash
cd /home/kiennm/Cancer_Epigenetics_Study
./deploy.sh
```

This script will:
- ✅ Install Quarto Shinylive extension
- ✅ Build your website to `docs/` folder
- ✅ Initialize git and commit files
- ✅ Show you next steps

### Step 3: Push to GitHub

Create a new repo at: https://github.com/new

Then run (replace YOUR_USERNAME):
```bash
git remote add origin https://github.com/YOUR_USERNAME/penguin-analysis.git
git branch -M main
git push -u origin main
```

### Step 4: Enable GitHub Pages

1. Go to your repo → **Settings** → **Pages**
2. Source: **main** branch
3. Folder: **/docs**
4. Click **Save**

**Done!** Visit: `https://YOUR_USERNAME.github.io/penguin-analysis/`

---

## Option 2: Manual Quarto Rendering

If you want more control:

### Step 1: Install Extension
```bash
cd /home/kiennm/Cancer_Epigenetics_Study
quarto add quarto-ext/shinylive --no-prompt
```

### Step 2: Render Single Document
```bash
# Just the app page
quarto render penguins-app.qmd

# Preview it
quarto preview penguins-app.qmd
```

### Step 3: Render Entire Website
```bash
# Build full site
quarto render

# Preview locally
quarto preview
```

The app will open in your browser at `http://localhost:XXXX`

---

## Files I Created For You

### Core Files
- ✅ `penguins-app.qmd` - Quarto doc with embedded Shinylive app
- ✅ `_quarto.yml` - Website configuration
- ✅ `index.qmd` - Home page
- ✅ `about.qmd` - About page

### Documentation
- ✅ `DEPLOYMENT.md` - Detailed deployment guide
- ✅ `QUICKSTART.md` - This file
- ✅ `deploy.sh` - Automated deployment script

### Configuration
- ✅ `.gitignore` - Git ignore rules

---

## What You'll Get

A complete Quarto website with:

📱 **Home Page** (`index.qmd`)
- Overview of your project
- Links to apps

🐧 **Interactive App** (`penguins-app.qmd`)
- Embedded Shinylive Shiny app
- Runs in browser (no server!)
- Data exploration tools

ℹ️ **About Page** (`about.qmd`)
- Project information
- Technology stack
- Dataset details

---

## Testing Locally

### Preview Before Deploying
```bash
cd /home/kiennm/Cancer_Epigenetics_Study

# Start preview server
quarto preview

# Opens at: http://localhost:XXXX
# Auto-reloads when you edit files
```

### Test Just the App
```bash
# Render and open
quarto render penguins-app.qmd
xdg-open penguins-app.html
```

---

## Customization Tips

### Change Website Theme
Edit `_quarto.yml`:
```yaml
format:
  html:
    theme: flatly  # Try: cosmo, flatly, minty, pulse, etc.
```

### Add More Pages
1. Create new `.qmd` file
2. Add to `_quarto.yml` navbar
3. Run `quarto render`

### Embed Your Own App
In any `.qmd` file:
````markdown
```{shinylive-r}
#| standalone: true

library(shiny)
# Your Shiny app code here...
```
````

---

## Troubleshooting

### "Quarto not found"
Install from: https://quarto.org/

### "Extension not installed"
```bash
quarto add quarto-ext/shinylive --no-prompt
```

### App not rendering
Check you have:
```yaml
filters:
  - shinylive
```
In your `_quarto.yml` or document YAML header.

### GitHub Pages not working
1. Wait 2-3 minutes after pushing
2. Check Settings → Pages shows "Your site is published"
3. Verify `/docs` folder is committed
4. Check browser console for errors

---

## Next Steps

1. **Run the deployment script**: `./deploy.sh`
2. **Create GitHub repo**: https://github.com/new
3. **Push your code**: Follow the script's instructions
4. **Enable Pages**: Settings → Pages → /docs folder
5. **Share your app!** 🎉

---

## Need Help?

Check these files:
- `DEPLOYMENT.md` - Detailed guide
- `README.md` - Project overview
- Quarto docs: https://quarto.org/docs/websites/

---

**You're all set!** Run `./deploy.sh` to get started! 🚀
