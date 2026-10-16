# Gulzar2 reusable CI/CD workflows

Copy `.github/workflows/*.yml` into `common/.github/workflows/`. These are starter templates and require project-specific validation before production.

- `kotlin-ci.yml`: build/test Kotlin source.
- `python-ci.yml`: install/test Python source.
- `publish-kotlin-package.yml`: publish versioned Maven artifacts to GitHub Packages on `v*` tags.
- `publish-python-package.yml`: publish public Python packages to PyPI on `v*` tags. Uses a project-scoped `PYPI_API_TOKEN`; trusted publishing can replace token auth after validating the reusable-workflow OIDC identity.
- `docker-build-publish.yml`: build/push service image to GHCR and expose image/digest outputs.
- `deploy.yml`: protected `production` environment, SSH rollout of an immutable digest, health check and rollback hook.

## Required follow-up
1. Use immutable full commit SHAs for third-party actions according to org policy.
2. Configure Gradle `maven-publish` to use `githubPackagesUsername` / `githubPackagesPassword`, and confirm package coordinates/versioning. Grant consumer repos package read access.
3. Set up public PyPI projects and project-scoped tokens for each Python library.
4. Pin exact published package versions in each service. Rewrite service Dockerfiles to install published packages rather than copy sibling repos.
5. Caller workflows must use `Gulzar-TechlogixIT/common/.github/workflows/<file>@<protected-tag-or-SHA>` and explicitly pass required inputs/secrets.
6. Docker build context must contain all required files; do not use sibling repo files as dependencies.
7. Configure Compose to consume the image variable(s) passed during deployment. For multi-service deployment, pass and pin every service image digest, not only one image.
8. Implement and test `/opt/gulzar2/rollback.sh` to restore previous known-good image digests and verify health.
9. Configure a protected GitHub Environment named `production` with required reviewers. Tag-based deployment is additionally guarded by `refs/tags/v*`.
10. Prefer pre-verified SSH host keys over trusting `ssh-keyscan` output; use a self-hosted deployment runner if the host is private-network-only.
11. Validate YAML with `actionlint`, run a test release, and rehearse rollback before production.
