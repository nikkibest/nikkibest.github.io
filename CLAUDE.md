# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a GitHub Pages site using Jekyll with the `jekyll-theme-minimal` theme. The site serves as a personal résumé and project showcase for nikkibest.github.io.

## Development Commands

### Local Development
```bash
# Install Jekyll and dependencies (first time setup)
gem install bundler jekyll

# Create Gemfile if it doesn't exist
bundle init
bundle add jekyll
bundle add github-pages  # For GitHub Pages compatibility

# Serve the site locally
bundle exec jekyll serve

# Serve with live reload and drafts
bundle exec jekyll serve --livereload --drafts
```

The site will be available at `http://localhost:4000`

### Building
```bash
# Build the site (output to _site/)
bundle exec jekyll build

# Build with specific environment
JEKYLL_ENV=production bundle exec jekyll build
```

## Project Structure

- `_config.yml` - Jekyll configuration (theme, site title, description)
- `README.md` - GitHub repository description
- Content files (`.md` or `.html`) go in the root or organized in folders
- `_posts/` - Blog posts in `YYYY-MM-DD-title.md` format (create as needed)
- `_layouts/` - Custom layouts override theme defaults (create as needed)
- `_includes/` - Reusable content snippets (create as needed)
- `_site/` - Generated static site (gitignored, do not edit)

## Theme Information

Using `jekyll-theme-minimal`. To customize:
- Override theme files by creating matching files in the local directory structure
- View theme source: https://github.com/pages-themes/minimal
- Add custom CSS in `assets/css/style.scss` with front matter

## GitHub Pages Deployment

This site automatically deploys via GitHub Pages when pushed to the `main` branch. No manual deployment needed.
