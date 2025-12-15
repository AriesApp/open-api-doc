# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Note**: Check `CLAUDE.local.md` for local configuration (related project paths, etc.) if it exists.

## Project Overview

This repository contains the **WaiverForever OpenAPI documentation**, hosted at https://docs.waiverforever.com/. It is the API documentation for the AriesApp/qs3 project's `openapi/` API.

The documentation is built using [Slate](https://github.com/slatedocs/slate), a Ruby-based static documentation generator.

## Development Commands

### Local Development
```bash
# Install dependencies (requires Ruby 2.5+)
gem install bundler
bundle install

# Start local development server (http://localhost:4567)
bundle exec middleman server
```

### Build
```bash
# Build static files to ./build directory
bundle exec middleman build
```

### Docker Build
```bash
# Build Docker image (uses multi-stage build with Ruby + lighttpd)
docker build -t open-api-doc .
```

## Architecture

### Documentation Source
- `source/index.html.md` - Main API documentation file (Markdown with YAML frontmatter)
- `source/includes/` - Additional markdown files to include
- `source/stylesheets/` - CSS/SCSS styles
- `source/javascripts/` - JavaScript assets
- `source/images/` - Image assets

### Configuration
- `config.rb` - Middleman configuration (markdown engine, syntax highlighting, build settings)
- `Gemfile` - Ruby dependencies

### Deployment
- **Production**: Merges to `master` trigger deploy via CircleCI (`./deploy.sh`)
- **Development K8s**: Manual approval workflow via CircleCI + Skaffold
- `.kustomize/` - Kubernetes deployment manifests
- `skaffold.yaml` - Skaffold configuration for K8s deployments

### Markdown Features
The documentation uses Redcarpet markdown with:
- Fenced code blocks with syntax highlighting (Rouge)
- Tables and strikethrough
- Code samples in multiple languages (cURL, Node.js, Ruby, Python)

## API Documentation Structure

The API docs follow this organization:
1. Introduction and authentication
2. Webhook configuration (signatures, dynamic/static webhooks)
3. API endpoints grouped by resource (Auth, Templates, Waivers, etc.)
4. Schema definitions
