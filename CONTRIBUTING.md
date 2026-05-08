# Contributing to gDRstyle

## Commit messages

We follow the [Conventional Commits](https://www.conventionalcommits.org/) convention.
This allows automated tooling to generate `NEWS.md` entries and determine version bumps.

### Format

```
<type>: <short description>
```

The description should be lowercase, imperative, and without a trailing period.

### Types

| Type | When to use |
|------|-------------|
| `feat` | New feature or exported function |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `docs` | Documentation only (roxygen, vignettes, README) |
| `test` | Adding or updating tests |
| `chore` | Version bump, NEWS.md update, CI config, build tooling |
| `ci` | Changes to GitHub Actions / GitLab CI pipelines |

### Examples

```
feat: add cyclocomp_linter to default linter config
fix: correct version comparison in checkPackage
refactor: extract note validation into separate function
docs: update CONTRIBUTING with commit conventions
chore: bump version to 1.11.3 and update NEWS.md
ci: add auto-changelog reusable workflow
```

### What happens if you don't follow the convention

A non-blocking CI check will flag the PR title if it does not match the format above.
The check is informational only — it will not block merging.
The auto-changelog workflow uses the actual diff (not commit messages) to generate
`NEWS.md` entries, so the changelog will be correct regardless.

## Version bumping

Versions follow [Semantic Versioning](https://semver.org/):

- **patch** (`X.Y.Z+1`): bug fixes, docs, refactoring, CI changes
- **minor** (`X.Y+1.0`): new features, new exported functions
- **major** (`X+1.0.0`): breaking changes to the public API

The `auto-changelog` CI workflow bumps the version and updates `NEWS.md` automatically
when a PR does not already include those changes.

## Style

All R code must pass `gDRstyle::lintPkgDirs()`. Key rules:

- Line length: max 120 characters
- No pipe operators (`%>%` or `|>`) — use base R syntax
- Use `paste0()` instead of `paste(..., sep = "")`
- Use `seq_len(n)` instead of `1:n`, `seq_along(x)` instead of `1:length(x)`
- All exported functions must have `@author` in their roxygen skeleton
