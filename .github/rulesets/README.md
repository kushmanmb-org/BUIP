# Repository Rulesets

This directory contains advanced ruleset configurations for protecting branches and tags in this repository.

## Overview

GitHub Rulesets provide fine-grained control over repository protections. These configurations define the rules and restrictions applied to different parts of the repository.

## Rulesets

### Main Branch Protection (`main-branch-protection.json`)

Protects the main/master branches with the following rules:

- **Pull Request Requirements**:
  - Minimum 1 approving review required
  - Stale reviews dismissed on new commits
  - All review threads must be resolved

- **Required Status Checks**:
  - `install-dependencies` - Verify dependency installation
  - `lint-markdown` - Validate markdown formatting
  - `validate-structure` - Check repository structure

- **History Protection**:
  - Branch deletion prevention
  - Force push prevention (non-fast-forward)
  - Linear history requirement
  - Commit signature requirement

### Tag Protection (`tag-protection.json`)

Protects version tags and release tags:

- Prevents tag creation by unauthorized users
- Prevents tag updates
- Prevents tag deletion

Protected tag patterns:
- `v*` - Version tags (e.g., v1.0.0, v2.1.3)
- `release-*` - Release tags (e.g., release-2024-01)

## Bypass Actors

Repository administrators can bypass these rules when necessary for:
- Emergency fixes
- Repository maintenance
- Correcting historical issues

## Applying Rulesets

### Via GitHub Web Interface

1. Go to repository **Settings** → **Rules** → **Rulesets**
2. Click **New ruleset** → **Import a ruleset**
3. Upload the JSON file from this directory
4. Review and activate the ruleset

### Via GitHub API

```bash
# Example using GitHub CLI
gh api repos/{owner}/{repo}/rulesets \
  --method POST \
  --input main-branch-protection.json
```

### Via Terraform

```hcl
resource "github_repository_ruleset" "main_protection" {
  name        = "Main Branch Protection"
  repository  = "BUIP"
  target      = "branch"
  enforcement = "active"

  # ... additional configuration
}
```

## Customization

To customize these rulesets for your needs:

1. Edit the JSON files in this directory
2. Modify the `conditions.ref_name.include` array to change protected branches/tags
3. Add or remove rules in the `rules` array
4. Update `bypass_actors` to change who can bypass rules

## Rule Types

Available rule types include:

- `pull_request` - Require pull request reviews
- `required_status_checks` - Require CI/CD checks to pass
- `creation` - Control creation of branches/tags
- `update` - Control updates to branches/tags
- `deletion` - Prevent deletion
- `non_fast_forward` - Prevent force pushes
- `required_linear_history` - Require linear Git history
- `required_signatures` - Require signed commits

## Best Practices

1. **Test First**: Apply rulesets to a test branch before applying to main
2. **Review Regularly**: Periodically review and update ruleset configurations
3. **Document Changes**: Commit ruleset changes with clear explanations
4. **Monitor Impact**: Watch for any workflow disruptions after applying rulesets
5. **Communicate**: Notify contributors about new or changed protection rules

## Troubleshooting

### Pull Request Can't Be Merged

Check:
- All required status checks have passed
- Required number of approvals obtained
- All review threads resolved
- No conflicting files

### Status Check Not Found

If a required status check is not running:
- Verify the workflow is configured correctly
- Check that the job name matches the ruleset
- Ensure the workflow triggers on the right events

### Bypass Not Working

Ensure:
- Your user account has the required permissions
- Bypass actor configuration is correct
- Repository role matches the ruleset configuration

## Security Considerations

- Rulesets are only as strong as access controls
- Regularly audit bypass actor permissions
- Use signed commits for additional security
- Monitor repository access logs
- Keep rulesets version-controlled

## References

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security/getting-started/securing-your-repository)

---

For questions about rulesets, please open an issue or contact repository maintainers.
