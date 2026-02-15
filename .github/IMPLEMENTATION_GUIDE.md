# Implementation Guide: Workflows and Rulesets

This document provides step-by-step instructions for implementing the new workflows, privacy/policy documentation, and advanced rulesets in the BUIP repository.

## What Has Been Added

### 1. GitHub Actions Workflows

**Location**: `.github/workflows/`

- **install.yml**: Main workflow for dependency installation, markdown linting, and structure validation
  - Configured to run on self-hosted runners with labels `[self-hosted, linux]`
  - Triggers on push/PR to main, master, or develop branches
  - Can be manually triggered via workflow_dispatch

### 2. Privacy and Policy Documentation

**Files**: `PRIVACY.md` and `POLICY.md` (repository root)

- **PRIVACY.md**: Comprehensive privacy policy covering data collection, usage, and user rights
- **POLICY.md**: Repository policies including contribution guidelines, code of conduct, security policy, and maintenance procedures

### 3. Advanced Repository Rulesets

**Location**: `.github/rulesets/`

- **main-branch-protection.json**: Protects main/master branches with PR requirements, status checks, and history protections
- **tag-protection.json**: Protects version and release tags from unauthorized modifications
- **README.md**: Documentation for understanding and managing rulesets

## Implementation Steps

### Step 1: Set Up Self-Hosted Runners

Before the workflows can run, you need to set up self-hosted runners:

1. **Go to Repository Settings**
   - Navigate to: `Settings` → `Actions` → `Runners`
   - Click: `New self-hosted runner`

2. **Choose Runner Type**
   - Operating System: Linux
   - Architecture: x64 (or appropriate for your system)

3. **Download and Configure Runner**
   ```bash
   # Create a directory for the runner
   mkdir actions-runner && cd actions-runner

   # Download the latest runner package (version may vary)
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L \
     https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz

   # Extract the installer
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

   # Configure the runner
   ./config.sh --url https://github.com/kushmanmb-org/BUIP --token YOUR_TOKEN
   ```

4. **Add Required Labels**
   - During configuration, when prompted for labels, enter: `self-hosted,linux`

5. **Install and Start as a Service**
   ```bash
   # Install the service
   sudo ./svc.sh install

   # Start the service
   sudo ./svc.sh start

   # Verify it's running
   sudo ./svc.sh status
   ```

6. **Verify Runner Appears in GitHub**
   - Go back to `Settings` → `Actions` → `Runners`
   - You should see your runner listed as "Idle"

### Step 2: Enable GitHub Actions

If GitHub Actions isn't already enabled:

1. Go to `Settings` → `Actions` → `General`
2. Under "Actions permissions", select: `Allow all actions and reusable workflows`
3. Click `Save`

### Step 3: Apply Repository Rulesets

#### Option A: Via GitHub Web Interface (Recommended)

1. **Navigate to Rulesets**
   - Go to: `Settings` → `Rules` → `Rulesets`

2. **Create Main Branch Protection Ruleset**
   - Click: `New ruleset` → `New branch ruleset`
   - Name: `Main Branch Protection`
   - Enforcement status: `Active`
   - Target branches: Add `main` and `master`
   - Add the following rules:
     - ✓ Require a pull request before merging
       - Required approvals: 1
       - Dismiss stale reviews
       - Require conversation resolution
     - ✓ Require status checks to pass
       - Add checks: `install-dependencies`, `lint-markdown`, `validate-structure`
       - Require branches to be up to date
     - ✓ Block force pushes
     - ✓ Require linear history
     - ✓ Require signed commits (optional, but recommended)
   - Bypass list: Repository administrators
   - Click: `Create`

3. **Create Tag Protection Ruleset**
   - Click: `New ruleset` → `New tag ruleset`
   - Name: `Tag Protection`
   - Enforcement status: `Active`
   - Target tags: Add `v*` and `release-*`
   - Add rules:
     - ✓ Restrict creations
     - ✓ Restrict updates
     - ✓ Restrict deletions
   - Bypass list: Repository administrators
   - Click: `Create`

#### Option B: Via GitHub CLI (Advanced)

If you have the GitHub CLI installed:

```bash
# Install GitHub CLI if needed
# See: https://cli.github.com/

# Authenticate
gh auth login

# Import main branch protection ruleset
gh api repos/kushmanmb-org/BUIP/rulesets \
  --method POST \
  --input .github/rulesets/main-branch-protection.json

# Import tag protection ruleset
gh api repos/kushmanmb-org/BUIP/rulesets \
  --method POST \
  --input .github/rulesets/tag-protection.json
```

#### Option C: Via GitHub API

Using curl:

```bash
# Set your GitHub token
export GITHUB_TOKEN="your_token_here"

# Create main branch protection ruleset
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d @.github/rulesets/main-branch-protection.json \
  https://api.github.com/repos/kushmanmb-org/BUIP/rulesets

# Create tag protection ruleset
curl -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d @.github/rulesets/tag-protection.json \
  https://api.github.com/repos/kushmanmb-org/BUIP/rulesets
```

### Step 4: Verify Installation

1. **Check Workflow Status**
   - Go to the `Actions` tab
   - You should see the "Install and Setup" workflow
   - If there's a recent push, check if it ran successfully

2. **Verify Rulesets**
   - Go to `Settings` → `Rules` → `Rulesets`
   - Confirm both rulesets are listed and active

3. **Test Protection**
   - Try to push directly to main (should be blocked)
   - Create a test PR and verify required checks run

### Step 5: Update Repository Settings (Optional)

Consider updating these additional settings:

1. **Branch Settings**
   - Go to `Settings` → `Branches`
   - Set default branch if needed

2. **Security Settings**
   - Go to `Settings` → `Code security and analysis`
   - Enable: Dependabot alerts
   - Enable: Dependabot security updates
   - Enable: Code scanning (CodeQL)

3. **Collaboration Settings**
   - Go to `Settings` → `Collaborators and teams`
   - Review and update access permissions

## Testing the Implementation

### Test 1: Workflow Execution

1. Make a small change (e.g., update README.md)
2. Push to a feature branch
3. Open a pull request
4. Verify the workflow runs on your self-hosted runner
5. Check that all three jobs complete successfully

### Test 2: Branch Protection

1. Try to push directly to main branch (should fail)
2. Try to merge a PR without approvals (should be blocked)
3. Try to merge a PR with failing checks (should be blocked)

### Test 3: Tag Protection

1. Try to create a tag matching `v*` pattern (e.g., `v1.0.0`)
2. Verify only authorized users can create/modify tags

## Troubleshooting

### Workflows Not Running

**Problem**: Workflows don't execute after push/PR

**Solutions**:
- Verify GitHub Actions is enabled in repository settings
- Check if self-hosted runner is online and idle
- Ensure workflow file syntax is correct (should be validated already)
- Check Actions tab for error messages

### Runner Not Available

**Problem**: Runner shows as offline

**Solutions**:
```bash
# Check runner service status
sudo ./svc.sh status

# If stopped, restart it
sudo ./svc.sh start

# Check logs
cat _diag/*.log
```

### Ruleset Not Enforcing

**Problem**: Branch protection rules aren't being enforced

**Solutions**:
- Verify ruleset enforcement is set to "Active"
- Check that branch patterns match correctly
- Ensure you're not in the bypass actors list (unless intended)
- Wait a few minutes for changes to propagate

### Status Checks Not Found

**Problem**: Required status checks don't appear

**Solutions**:
- Ensure workflow has run at least once on the target branch
- Verify job names match exactly in workflow and ruleset
- Check that workflow triggers include the right branches

## Maintenance

### Regular Tasks

1. **Update Runner Software**
   - Runners auto-update by default
   - Manually update: `sudo ./svc.sh stop && ./config.sh remove && ./config.sh ... && sudo ./svc.sh start`

2. **Review Workflow Logs**
   - Check Actions tab regularly for failures
   - Investigate and fix any persistent issues

3. **Update Rulesets**
   - Review protection rules quarterly
   - Adjust as repository needs change
   - Document changes in this file

4. **Monitor Runner Resources**
   - Check disk space: `df -h`
   - Check memory usage: `free -h`
   - Scale runners if needed

### Updating Workflows

To update workflows:

1. Edit the workflow file in `.github/workflows/`
2. Test on a feature branch first
3. Open a PR for review
4. Merge after approval and testing

### Updating Rulesets

To update rulesets:

1. Edit the JSON file in `.github/rulesets/`
2. Re-apply via GitHub UI, CLI, or API
3. Test the changes
4. Document the update

## Security Considerations

### Self-Hosted Runner Security

- ⚠️ **Important**: Self-hosted runners execute code from pull requests
- Use isolated environments (containers, VMs, separate machines)
- Don't use the same runners for public and private repositories
- Regularly update runner software and host OS
- Monitor runner logs for suspicious activity
- Restrict network access from runner machines

### Secret Management

- Store sensitive data in GitHub Secrets
- Never commit secrets to the repository
- Rotate secrets regularly
- Use environment-specific secrets

### Access Control

- Limit who can modify workflows
- Require approval for workflow runs from first-time contributors
- Use CODEOWNERS file for sensitive directories
- Regular audit of repository access

## Support and Contact

For questions or issues with this implementation:

1. Check this guide and the README files in `.github/workflows/` and `.github/rulesets/`
2. Review GitHub documentation:
   - [GitHub Actions](https://docs.github.com/en/actions)
   - [Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
   - [Repository Rulesets](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets)
3. Open an issue in the repository
4. Contact repository maintainers

## Next Steps

After completing this implementation:

1. ✅ Set up at least one self-hosted runner
2. ✅ Verify workflows run successfully
3. ✅ Apply repository rulesets
4. ✅ Test branch protection
5. ✅ Review and update PRIVACY.md if needed
6. ✅ Review and update POLICY.md if needed
7. ✅ Communicate changes to contributors
8. ✅ Update README.md to mention new policies and workflows

---

*Implementation completed: February 2026*
*Maintainer: Repository Administrators*
