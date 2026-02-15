# Repository Policies

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Contribution Guidelines](#contribution-guidelines)
- [BUIP Submission Process](#buip-submission-process)
- [Review and Voting Process](#review-and-voting-process)
- [Security Policy](#security-policy)
- [Branch Protection](#branch-protection)
- [Licensing](#licensing)
- [Maintenance](#maintenance)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of background, identity, or experience level.

### Expected Behavior

- Be respectful and considerate in communication
- Focus on constructive feedback
- Accept differing viewpoints professionally
- Prioritize the community's best interests

### Unacceptable Behavior

- Harassment, discrimination, or personal attacks
- Trolling, insulting comments, or inflammatory language
- Publishing others' private information
- Any conduct that violates professional standards

### Enforcement

Violations will result in:
1. Warning
2. Temporary ban from repository
3. Permanent ban for repeated or severe violations

## Contribution Guidelines

### How to Contribute

1. **Forum Discussion**: Post your proposal at https://bitco.in/forum/forums/bitcoin-unlimited.15/
2. **Proposal Review**: Work with maintainers on proposal number and copy-editing
3. **Formal Submission**: Submit as a pull request with the assigned BUIP number
4. **Member Voting**: BU members vote on the proposal

### Pull Request Requirements

- Clear, descriptive commit messages
- One BUIP per pull request
- Follow the existing BUIP format and numbering
- Include all required sections (Abstract, Motivation, Specification, etc.)
- Pass all automated checks

### Commit Message Format

```
[BUIP-XXX] Brief description

Detailed explanation of changes if needed.
```

## BUIP Submission Process

### Proposal Format

Each BUIP must include:

1. **Header**: Number, Title, Author, Created date, Status
2. **Abstract**: Brief summary (2-3 sentences)
3. **Motivation**: Why this proposal is needed
4. **Specification**: Technical details and implementation
5. **Rationale**: Design decisions and alternatives considered
6. **Backward Compatibility**: Impact on existing systems
7. **Implementation**: Reference implementation or plan

### Numbering System

- BUIPs are numbered sequentially (001, 002, 003, etc.)
- Numbers are assigned by maintainers
- Do not choose your own BUIP number

### Status Values

- **Draft**: Initial proposal, open for discussion
- **Proposed**: Formal submission, ready for voting
- **Passed**: Approved by BU member vote
- **Rejected**: Not approved by vote
- **Withdrawn**: Withdrawn by author
- **Closed**: Closed without resolution

## Review and Voting Process

### Quorum and Majority

Per the Bitcoin Unlimited Articles (Article 2):
- Requires a majority of BU member votes
- Must meet quorum requirements
- See: https://www.bitcoinunlimited.info/resources/BUarticles.pdf

### Review Timeline

1. **Initial Review**: 1-2 weeks for maintainer feedback
2. **Public Discussion**: Minimum 2 weeks for community input
3. **Voting Period**: As defined by BU governance
4. **Final Decision**: Announced on forum and repository

### Maintainer Responsibilities

- Review proposals for completeness and clarity
- Assign BUIP numbers
- Facilitate voting process
- Merge approved proposals
- Maintain repository integrity

## Security Policy

### Reporting Vulnerabilities

**DO NOT** open public issues for security vulnerabilities.

Instead:
1. Email maintainers directly (see README for contacts)
2. Use encrypted communication if possible
3. Provide detailed description and proof of concept
4. Allow reasonable time for fix before disclosure

### Security Response

- Acknowledgment within 48 hours
- Initial assessment within 7 days
- Fix timeline based on severity
- Coordinated disclosure with reporter

### Supported Versions

Security updates apply to:
- Current proposals under active development
- Referenced implementations
- Repository infrastructure

## Branch Protection

### Main Branch Protection

The following protections are enforced on main/master branches:

#### Required Checks

- All CI/CD workflows must pass
- Markdown linting must succeed
- Structure validation must pass

#### Review Requirements

- At least 1 approval from maintainers required
- Changes cannot be force-pushed
- Commits must be signed (recommended)

#### Restrictions

- Only maintainers can merge to protected branches
- Require pull request reviews before merging
- Dismiss stale reviews on new commits
- Require linear history (no merge commits)

### Pull Request Process

1. Create feature branch from main
2. Make changes and commit
3. Open pull request with clear description
4. Respond to review feedback
5. Await maintainer approval
6. Automated merge after approval and checks

## Licensing

### Repository License

This repository is licensed under the MIT License (see LICENSE file).

### Contribution License

By contributing to this repository:
- You grant rights to use your contribution under the repository license
- You confirm you have the right to submit the contribution
- You understand contributions become part of public record

### Content License

- BUIP content is licensed under MIT License
- Authors retain copyright to their proposals
- Content may be freely used, modified, and distributed with attribution

## Maintenance

### Repository Maintenance

Maintainers are responsible for:
- Reviewing and merging pull requests
- Assigning BUIP numbers
- Maintaining repository structure
- Enforcing policies and guidelines
- Managing CI/CD workflows
- Responding to issues and questions

### Maintenance Schedule

- Pull requests: Reviewed within 1 week
- Issues: Responded to within 3 days
- Security issues: Responded to within 48 hours

### Inactive Proposals

Proposals with no activity for 90 days may be:
- Marked as stale
- Moved to draft status
- Closed after additional 30 days without activity

### Archival

- Approved BUIPs are never deleted
- Historical record is preserved
- Superseded proposals remain accessible with updated status

## Automated Workflows

### CI/CD Policies

- Workflows run on self-hosted runners for security
- All workflows must be reviewed by maintainers
- Workflows require explicit approval for external contributors
- Logs are retained per GitHub's policies

### Dependency Management

- Dependencies are reviewed for security vulnerabilities
- Automated updates via dependabot (if configured)
- Manual review required for major version updates

## Dispute Resolution

### Disagreements

1. Discuss in pull request or issue comments
2. Seek maintainer mediation if needed
3. Follow BU governance processes for formal disputes
4. Community consensus preferred over individual preferences

### Appeal Process

If you disagree with a decision:
1. Present your case clearly with supporting evidence
2. Request review from other maintainers
3. Follow BU governance escalation if needed

## Updates to This Policy

This policy may be updated via pull request. Significant changes require:
- Discussion in an issue or pull request
- Review by maintainers
- Announcement to community

---

*Last Updated: February 2026*

For questions about these policies, please open an issue or contact the repository maintainers.
