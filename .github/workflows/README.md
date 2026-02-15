# GitHub Actions Workflows

This directory contains automated workflows for the BUIP repository using GitHub Actions with self-hosted runners.

## Overview

Workflows automate testing, validation, and maintenance tasks for this repository. All workflows are configured to run on self-hosted runners for enhanced security and control.

## Workflows

### Install and Setup (`install.yml`)

**Purpose**: Manages dependency installation and repository validation.

**Triggers**:
- Push to main, master, or develop branches
- Pull requests to main, master, or develop branches
- Manual workflow dispatch

**Jobs**:

1. **install-dependencies**
   - Checks out repository
   - Sets up Node.js and Python environments
   - Installs dependencies (if package files exist)
   - Caches dependencies for faster subsequent runs
   - Runs on: `[self-hosted, linux]`

2. **lint-markdown**
   - Lints all markdown files using markdownlint
   - Ensures consistent markdown formatting
   - Continues on error to not block PRs
   - Depends on: `install-dependencies`
   - Runs on: `[self-hosted, linux]`

3. **validate-structure**
   - Checks for required files (README, LICENSE, PRIVACY, POLICY)
   - Counts BUIP files
   - Validates repository structure
   - Runs on: `[self-hosted, linux]`

## Self-Hosted Runners

This repository uses self-hosted runners with the following labels:
- `self-hosted` - Indicates non-GitHub-hosted runner
- `linux` - Indicates Linux operating system

### Setting Up Self-Hosted Runners

#### Prerequisites
- Linux machine (Ubuntu 20.04+ recommended)
- Docker (optional, for containerized runners)
- Network access to GitHub.com
- Sufficient disk space and memory

#### Installation Steps

1. **Navigate to Repository Settings**
   ```
   Settings → Actions → Runners → New self-hosted runner
   ```

2. **Download and Configure Runner**
   ```bash
   # Create directory
   mkdir actions-runner && cd actions-runner

   # Download latest runner package
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
     https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

   # Extract
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

   # Configure
   ./config.sh --url https://github.com/kushmanmb-org/BUIP --token YOUR_TOKEN
   ```

3. **Add Runner Labels**
   ```bash
   # During configuration, add labels: self-hosted,linux
   ```

4. **Start Runner as Service**
   ```bash
   # Install service
   sudo ./svc.sh install

   # Start service
   sudo ./svc.sh start

   # Check status
   sudo ./svc.sh status
   ```

#### Using Docker for Runners

```dockerfile
# Dockerfile for self-hosted runner
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    curl \
    git \
    jq \
    nodejs \
    npm \
    python3 \
    python3-pip

# Install runner and configure as needed
# See GitHub documentation for details
```

### Runner Security

- Runners execute untrusted code from pull requests
- Use isolated environments (containers, VMs)
- Restrict runner access to sensitive resources
- Regularly update runner software
- Monitor runner logs for suspicious activity
- Use separate runners for public vs. private repositories

### Runner Maintenance

- **Updates**: Runners auto-update by default
- **Monitoring**: Check runner status in repository settings
- **Logs**: Located in `_diag` directory in runner installation
- **Cleanup**: Old workflow logs are automatically cleaned up

## Workflow Development

### Adding New Workflows

1. Create a new `.yml` file in this directory
2. Follow the existing workflow structure
3. Use self-hosted runner labels: `runs-on: [self-hosted, linux]`
4. Test on a feature branch before merging
5. Document the workflow in this README

### Workflow Best Practices

1. **Security**
   - Use specific action versions (e.g., `@v4`, not `@latest`)
   - Review third-party actions before use
   - Limit permissions using `permissions` key
   - Use secrets for sensitive data

2. **Efficiency**
   - Cache dependencies
   - Use job dependencies (`needs`) appropriately
   - Set reasonable timeouts
   - Clean up temporary files

3. **Reliability**
   - Handle errors gracefully
   - Use `continue-on-error` where appropriate
   - Test workflows thoroughly
   - Monitor workflow runs

### Example: Adding a New Workflow

```yaml
name: My New Workflow

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  my-job:
    name: My Job Name
    runs-on: [self-hosted, linux]
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      
      - name: Do something
        run: |
          echo "Hello from self-hosted runner!"
```

## Debugging Workflows

### Viewing Workflow Runs

1. Go to **Actions** tab in repository
2. Select the workflow
3. Click on a specific run to see details
4. Expand job steps to see logs

### Re-running Failed Workflows

1. Open the failed workflow run
2. Click "Re-run jobs" → "Re-run failed jobs"
3. Or "Re-run all jobs" to run everything again

### Enabling Debug Logging

Add repository secrets:
- `ACTIONS_RUNNER_DEBUG`: `true` (for runner debug logs)
- `ACTIONS_STEP_DEBUG`: `true` (for step debug logs)

### Common Issues

**Runner Offline**
- Check runner service status: `sudo ./svc.sh status`
- Check network connectivity
- Verify runner token hasn't expired

**Workflow Not Triggering**
- Verify trigger conditions (branches, paths)
- Check workflow file syntax (use `yamllint`)
- Ensure workflow file is on the target branch

**Job Failing on Runner**
- Check runner has required dependencies
- Verify sufficient disk space and memory
- Review job logs for specific errors

## Workflow Permissions

Workflows have the following permissions by default:
- **Read**: Repository contents
- **Write**: Issues, pull requests, checks

For additional permissions, specify in workflow file:

```yaml
permissions:
  contents: read
  issues: write
  pull-requests: write
  checks: write
```

## Caching

Workflows use GitHub Actions cache to speed up builds:

- **Node.js**: `~/.npm` and `node_modules`
- **Python**: `~/.cache/pip`
- **Cache Keys**: Based on lock file hashes

Cache is automatically invalidated when dependencies change.

## Status Badges

Add workflow status badges to README:

```markdown
![Install and Setup](https://github.com/kushmanmb-org/BUIP/actions/workflows/install.yml/badge.svg)
```

## Secrets Management

Sensitive data should be stored as repository secrets:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add name and value
4. Use in workflows: `${{ secrets.SECRET_NAME }}`

**Never** commit secrets to the repository.

## Monitoring and Alerts

- Workflow failures send notifications to repository admins
- Configure additional notifications in repository settings
- Use third-party monitoring tools for advanced alerting

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
- [Workflow Syntax](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [Security Hardening](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)

---

For questions about workflows, please open an issue or contact repository maintainers.
