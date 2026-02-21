# BUIP Repository Makefile
# This Makefile provides targets for common development tasks, security checks, and repository management

.PHONY: help install lint validate security clean all test apply-rulesets check-secrets

# Default target - show help
help:
	@echo "BUIP Repository Makefile"
	@echo "======================="
	@echo ""
	@echo "Available targets:"
	@echo "  help              - Show this help message"
	@echo "  install           - Install all dependencies (Node.js, Python)"
	@echo "  lint              - Lint markdown files"
	@echo "  validate          - Validate repository structure"
	@echo "  check-secrets     - Scan for accidentally committed secrets and sensitive data"
	@echo "  security          - Run all security checks"
	@echo "  test              - Run all validation and security tests"
	@echo "  all               - Run install, lint, validate, and security"
	@echo "  clean             - Clean temporary files and caches"
	@echo "  apply-rulesets    - Display instructions for applying GitHub rulesets"
	@echo ""
	@echo "Security targets:"
	@echo "  check-keys        - Check for private keys in repository"
	@echo "  check-tokens      - Check for API tokens and secrets"
	@echo "  check-emails      - Check for email addresses that might be sensitive"
	@echo "  check-perms       - Check file permissions"
	@echo ""
	@echo "Documentation:"
	@echo "  See README.md for usage information"
	@echo "  See POLICY.md for contribution guidelines and security policies"
	@echo "  See .github/IMPLEMENTATION_GUIDE.md for workflow and ruleset setup"

# Install dependencies
install:
	@echo "Installing dependencies..."
	@if [ -f "package.json" ]; then \
		echo "Installing Node.js dependencies..."; \
		npm install; \
	else \
		echo "No package.json found, skipping Node.js dependencies"; \
	fi
	@if [ -f "requirements.txt" ]; then \
		echo "Installing Python dependencies..."; \
		pip install -r requirements.txt; \
	else \
		echo "No requirements.txt found, skipping Python dependencies"; \
	fi
	@echo "✓ Installation complete"

# Lint markdown files
lint:
	@echo "Linting markdown files..."
	@command -v markdownlint >/dev/null 2>&1 || { \
		echo "Installing markdownlint-cli..."; \
		npm install -g markdownlint-cli; \
	}
	@markdownlint '**/*.md' --ignore node_modules --ignore .git || true
	@echo "✓ Markdown linting complete"

# Validate repository structure
validate:
	@echo "Validating repository structure..."
	@echo ""
	@echo "Checking for required files..."
	@test -f README.md && echo "✓ README.md exists" || echo "⚠ WARNING: README.md not found"
	@test -f LICENSE && echo "✓ LICENSE exists" || echo "⚠ WARNING: LICENSE not found"
	@test -f PRIVACY.md && echo "✓ PRIVACY.md exists" || echo "⚠ WARNING: PRIVACY.md not found"
	@test -f POLICY.md && echo "✓ POLICY.md exists" || echo "⚠ WARNING: POLICY.md not found"
	@test -f .gitignore && echo "✓ .gitignore exists" || echo "⚠ WARNING: .gitignore not found"
	@test -f Makefile && echo "✓ Makefile exists" || echo "⚠ WARNING: Makefile not found"
	@echo ""
	@echo "Counting BUIP files..."
	@buip_count=$$(ls -1 [0-9][0-9][0-9].md 2>/dev/null | wc -l); \
	echo "Found $$buip_count BUIP files"
	@echo ""
	@echo "Checking GitHub configuration..."
	@test -d .github/workflows && echo "✓ GitHub workflows directory exists" || echo "⚠ WARNING: .github/workflows not found"
	@test -d .github/rulesets && echo "✓ GitHub rulesets directory exists" || echo "⚠ WARNING: .github/rulesets not found"
	@echo ""
	@echo "✓ Repository structure validation complete"

# Check for private keys (CRITICAL - will fail if found)
check-keys:
	@echo "Checking for private keys..."
	@if grep -rE "BEGIN.*PRIVATE KEY" --include="*.md" --include="*.txt" --include="*.key" --include="*.pem" . 2>/dev/null | grep -v ".github/security-patterns.yml"; then \
		echo "❌ ERROR: Private key found in repository!"; \
		echo "Private keys should NEVER be committed to version control."; \
		echo "Please remove the private key immediately and rotate it."; \
		exit 1; \
	else \
		echo "✓ No private keys found"; \
	fi

# Check for API tokens and secrets
check-tokens:
	@echo "Checking for API tokens and secrets..."
	@findings=0; \
	if grep -rE 'gh[ps]_[a-zA-Z0-9]{36,}' --include="*.md" --include="*.txt" --include="*.yml" --include="*.yaml" --include="*.json" . 2>/dev/null | grep -v ".github/security-patterns.yml"; then \
		echo "❌ ERROR: GitHub token detected!"; \
		findings=$$((findings + 1)); \
	fi; \
	if grep -rE '(api[_-]?key|token|password|secret)["\s:=]+[a-zA-Z0-9_-]{20,}' --include="*.md" --include="*.txt" --include="*.yml" --include="*.yaml" . 2>/dev/null | grep -v ".github/security-patterns.yml" | grep -v "POLICY.md"; then \
		echo "⚠ WARNING: Potential secrets found - please review"; \
		findings=$$((findings + 1)); \
	fi; \
	if [ $$findings -eq 0 ]; then \
		echo "✓ No obvious tokens or secrets found"; \
	else \
		echo "Found $$findings potential security issues - please review"; \
	fi

# Check for email addresses that might be sensitive
check-emails:
	@echo "Checking for email addresses..."
	@if grep -rEh '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' --include="*.md" . 2>/dev/null | \
	   grep -v -E '(example\.(com|org|net)|github\.com|bitcoinunlimited\.(info|net|org)|bitco\.in|noreply\.github\.com)' | head -5; then \
		echo "⚠ WARNING: Email addresses found - verify they should be public"; \
	else \
		echo "✓ No concerning email addresses found"; \
	fi

# Check file permissions
check-perms:
	@echo "Checking file permissions..."
	@echo ""
	@echo "Checking for executable files..."
	@executable_files=$$(find . -type f -executable -not -path "./.git/*" -not -path "./node_modules/*" 2>/dev/null || true); \
	if [ -n "$$executable_files" ]; then \
		echo "⚠ WARNING: Executable files found:"; \
		echo "$$executable_files"; \
	else \
		echo "✓ No unexpected executable files found"; \
	fi
	@echo ""
	@echo "Checking for world-writable files..."
	@unusual_perms=$$(find . -type f \( -perm -002 -o -perm -020 \) -not -path "./.git/*" 2>/dev/null || true); \
	if [ -n "$$unusual_perms" ]; then \
		echo "⚠ WARNING: Files with unusual permissions found:"; \
		echo "$$unusual_perms"; \
	else \
		echo "✓ File permissions look good"; \
	fi

# Scan for accidentally committed secrets (comprehensive check)
check-secrets: check-keys check-tokens
	@echo ""
	@echo "Additional security checks..."
	@echo ""
	@echo "Checking .gitignore coverage..."
	@if [ -f ".gitignore" ]; then \
		echo "✓ .gitignore file exists"; \
		echo "Verifying key patterns are in .gitignore:"; \
		grep -q "*.key" .gitignore && echo "  ✓ *.key pattern found" || echo "  ⚠ *.key pattern not found"; \
		grep -q "*.pem" .gitignore && echo "  ✓ *.pem pattern found" || echo "  ⚠ *.pem pattern not found"; \
		grep -q ".env" .gitignore && echo "  ✓ .env pattern found" || echo "  ⚠ .env pattern not found"; \
		grep -q "secret" .gitignore && echo "  ✓ secret pattern found" || echo "  ⚠ secret pattern not found"; \
	else \
		echo "❌ ERROR: .gitignore file not found!"; \
	fi
	@echo ""
	@echo "Checking for sensitive file extensions..."
	@sensitive_files=$$(find . -type f \( -name "*.key" -o -name "*.pem" -o -name "*.p12" -o -name "*.pfx" -o -name ".env" -o -name "wallet.dat" \) -not -path "./.git/*" 2>/dev/null || true); \
	if [ -n "$$sensitive_files" ]; then \
		echo "❌ ERROR: Sensitive files found in repository:"; \
		echo "$$sensitive_files"; \
		echo "These files should be removed and added to .gitignore!"; \
		exit 1; \
	else \
		echo "✓ No sensitive file types found"; \
	fi
	@echo ""
	@echo "✓ Secret scanning complete"

# Run all security checks
security: check-secrets check-emails check-perms
	@echo ""
	@echo "═══════════════════════════════════════"
	@echo "Security scan complete!"
	@echo "═══════════════════════════════════════"
	@echo ""
	@echo "Remember:"
	@echo "  • Never commit private keys or credentials"
	@echo "  • Use environment variables for sensitive config"
	@echo "  • Review .gitignore regularly"
	@echo "  • Enable GitHub secret scanning"
	@echo "  • See POLICY.md for security guidelines"

# Run all tests
test: lint validate security
	@echo ""
	@echo "═══════════════════════════════════════"
	@echo "All tests complete!"
	@echo "═══════════════════════════════════════"

# Run everything
all: install lint validate security
	@echo ""
	@echo "═══════════════════════════════════════"
	@echo "All tasks complete!"
	@echo "═══════════════════════════════════════"

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@rm -rf node_modules 2>/dev/null || true
	@rm -rf .cache 2>/dev/null || true
	@rm -rf __pycache__ 2>/dev/null || true
	@rm -rf *.pyc 2>/dev/null || true
	@rm -rf .pytest_cache 2>/dev/null || true
	@rm -rf .tox 2>/dev/null || true
	@rm -rf dist 2>/dev/null || true
	@rm -rf build 2>/dev/null || true
	@rm -rf *.egg-info 2>/dev/null || true
	@find . -name ".DS_Store" -delete 2>/dev/null || true
	@find . -name "Thumbs.db" -delete 2>/dev/null || true
	@find . -name "*.tmp" -delete 2>/dev/null || true
	@echo "✓ Cleanup complete"

# Display instructions for applying GitHub rulesets
apply-rulesets:
	@echo "GitHub Rulesets Application Instructions"
	@echo "========================================"
	@echo ""
	@echo "This repository includes pre-configured rulesets for enhanced security:"
	@echo ""
	@echo "1. Main Branch Protection (.github/rulesets/main-branch-protection.json)"
	@echo "   - Requires pull request reviews"
	@echo "   - Requires status checks to pass"
	@echo "   - Prevents force pushes and requires linear history"
	@echo "   - Requires commit signatures"
	@echo ""
	@echo "2. Tag Protection (.github/rulesets/tag-protection.json)"
	@echo "   - Protects version tags (v*)"
	@echo "   - Protects release tags (release-*)"
	@echo "   - Prevents unauthorized tag modifications"
	@echo ""
	@echo "To apply these rulesets:"
	@echo ""
	@echo "Option A - GitHub Web Interface (Recommended):"
	@echo "  1. Go to: Settings → Rules → Rulesets"
	@echo "  2. Click: New ruleset"
	@echo "  3. Follow the configuration in .github/rulesets/README.md"
	@echo ""
	@echo "Option B - GitHub CLI:"
	@echo "  gh api repos/\$${OWNER}/\$${REPO}/rulesets --method POST --input .github/rulesets/main-branch-protection.json"
	@echo "  gh api repos/\$${OWNER}/\$${REPO}/rulesets --method POST --input .github/rulesets/tag-protection.json"
	@echo ""
	@echo "For detailed instructions, see:"
	@echo "  • .github/rulesets/README.md"
	@echo "  • .github/IMPLEMENTATION_GUIDE.md"
	@echo ""
	@echo "Security best practices:"
	@echo "  • Review rulesets before applying"
	@echo "  • Test on a non-production branch first"
	@echo "  • Ensure CI/CD workflows are configured"
	@echo "  • Communicate changes to contributors"
