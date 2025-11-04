# Managing R Packages with renv

This guide shows you how to use `renv` to manage R package dependencies in your project.

## What is renv?

`renv` creates an isolated, reproducible R package environment for your project. It:
- Installs packages locally in your project (not system-wide)
- Tracks package versions in `renv.lock`
- Makes your project reproducible on other machines

## Current Status

✅ renv is **initialized** in this project
- `renv.lock` - Package version lockfile
- `.Rprofile` - Automatically activates renv when you start R
- `renv/` folder - Local package library

## Common renv Commands

### 1. Update renv.lock with Currently Installed Packages

After installing new packages, update the lockfile:

```r
# In R console:
renv::snapshot()
```

This scans your R scripts, finds all used packages, and saves their versions to `renv.lock`.

### 2. Install Packages

```r
# Install packages normally:
install.packages("ggplot2")
install.packages(c("dplyr", "tidyr", "shiny"))

# Or use pak (faster):
pak::pkg_install("ggplot2")

# Then snapshot to save to renv.lock:
renv::snapshot()
```

### 3. Restore Packages from renv.lock

When someone else clones your repo or you work on a new machine:

```r
# Restore all packages from renv.lock:
renv::restore()
```

### 4. Check Package Status

```r
# See what packages are out of sync:
renv::status()
```

### 5. Update Specific Package

```r
# Update a package to the latest version:
install.packages("ggplot2")
renv::snapshot()

# Or update all packages:
renv::update()
```

### 6. Remove Unused Packages

```r
# Remove packages not used in your code:
renv::clean()
```

## Quick Start: Update Your Project Now

Open R in your project and run:

```r
# 1. Check status
renv::status()

# 2. If packages are missing from renv.lock, snapshot them:
renv::snapshot()

# 3. Check what's tracked:
renv::dependencies()
```

## Workflow Example

```r
# Install new package
install.packages("readr")

# Use it in your code
library(readr)
data <- read_csv("data.csv")

# Save to renv.lock
renv::snapshot()

# Commit renv.lock to git
# (in terminal) git add renv.lock
# (in terminal) git commit -m "Add readr package"
```

## Your Project Packages

Based on your code, you should have these packages in renv:

- **shiny** - For interactive web apps
- **ggplot2** - For data visualization  
- **palmerpenguins** - For penguin dataset
- **dplyr** - For data manipulation
- **languageserver** - For VS Code R support
- **pak** - For fast package installation
- **rsconnect** - For deploying Shiny apps
- **shinylive** - For WebAssembly Shiny apps

## Important Notes

### Auto-activation
When you open R in this project, renv automatically activates (via `.Rprofile`)

### Git Integration
Always commit these files:
- `renv.lock` - Package versions (commit this!)
- `.Rprofile` - Activates renv (commit this!)
- `renv/activate.R` - Activation script (commit this!)

DON'T commit:
- `renv/library/` - Package binaries (ignored by .gitignore)
- `renv/staging/` - Temporary files (ignored by .gitignore)

### Troubleshooting

**Problem**: "renv not activated"
```r
# Solution:
source("renv/activate.R")
```

**Problem**: "Package not found"
```r
# Solution: Restore from lockfile
renv::restore()
```

**Problem**: "Snapshot doesn't include my packages"
```r
# Make sure you use library() in your scripts:
library(ggplot2)  # renv detects this

# Then snapshot:
renv::snapshot()
```

## VS Code Terminal

You can run renv commands in VS Code's R Terminal:
1. Open R terminal (Ctrl+Shift+`)
2. Type R commands directly
3. Or use R extension's "Run Selection" feature

## More Information

- Documentation: https://rstudio.github.io/renv/
- Cheat sheet: https://rstudio.github.io/renv/articles/renv.html
