# Feedback Inbox

A small product feedback app used to demonstrate how I work with AI coding agents: define the product, provide durable context, let an agent break a goal into tasks, and inspect the resulting code, tests and review evidence.

**Status:** Feedback Inbox is implemented on `main` (FR-001–FR-008). Load sample data with `bin/rails db:seed` after setup.

## What the app does

Users submit feedback with a title and description, browse an inbox (newest first), assign a category (`bug`, `feature request` or `other`), and filter the list. Data persists in local SQLite across restarts.

This is an independent engineering demo using synthetic data only.

## Why I am building this

I want to show how I turn a short product goal into reviewable software using AI. Requirements, context, scope, validation and review need to be explicit as well as the code.

The walkthrough should take about three minutes. Its evidence is the actual project issue, delegated goals, pull requests and check results.

## Delivery evidence (this run)

| Artifact | Link |
|---|---|
| Project Execution issue | [#2 — Build Feedback Inbox](https://github.com/szymoniwacz/feedback-index-test-2/issues/2) |
| Runtime readiness (goal #4) | [PR #6](https://github.com/szymoniwacz/feedback-index-test-2/pull/6) |
| FR-001 submission | [PR #10](https://github.com/szymoniwacz/feedback-index-test-2/pull/10) (goal [#9](https://github.com/szymoniwacz/feedback-index-test-2/issues/9)) |
| FR-002 browsing | [PR #12](https://github.com/szymoniwacz/feedback-index-test-2/pull/12) (goal [#11](https://github.com/szymoniwacz/feedback-index-test-2/issues/11)) |
| FR-003 categorization | [PR #14](https://github.com/szymoniwacz/feedback-index-test-2/pull/14) (goal [#13](https://github.com/szymoniwacz/feedback-index-test-2/issues/13)) |
| FR-004 filtering | [PR #16](https://github.com/szymoniwacz/feedback-index-test-2/pull/16) (goal [#15](https://github.com/szymoniwacz/feedback-index-test-2/issues/15)) |
| FR-005 persistence | [PR #18](https://github.com/szymoniwacz/feedback-index-test-2/pull/18) (goal [#17](https://github.com/szymoniwacz/feedback-index-test-2/issues/17)) |
| FR-006 invalid requests | [PR #20](https://github.com/szymoniwacz/feedback-index-test-2/pull/20) (goal [#19](https://github.com/szymoniwacz/feedback-index-test-2/issues/19)) |
| FR-007 tests | [PR #22](https://github.com/szymoniwacz/feedback-index-test-2/pull/22) (goal [#21](https://github.com/szymoniwacz/feedback-index-test-2/issues/21)) |
| FR-008 reproducibility | [PR #24](https://github.com/szymoniwacz/feedback-index-test-2/pull/24) (goal [#23](https://github.com/szymoniwacz/feedback-index-test-2/issues/23)) |
| CI on `main` | [Workflow runs](https://github.com/szymoniwacz/feedback-index-test-2/actions/workflows/ci.yml) (`tests/test-adapter.sh` + `bin/rails test`) |

## What I prepared

I used AI assistance to prepare this documentation from my project brief. I own the intended outcome, scope and review decisions.

| Preparation | Where to inspect it |
|---|---|
| Defined the product, users and purpose | [Product context](.ai/project/product-context.md) |
| Set acceptance criteria and recorded unresolved choices | [Project requirements](.ai/docs/project-requirements.md) |
| Kept the demo small with explicit non-goals | [Scope](.ai/project/scope.md) |
| Recorded decisions and their rationale | [Decision log](.ai/project/decisions.md) |
| Prepared a short goal without prescribing child tasks | [Project issue draft](docs/demo-project-issue.md) |
| Reused my workflow through the template adapter | [Workflow setup](docs/setup.md) |

Product task decomposition is intentionally left to Project Executor.

## Planned demonstration

| Run | Mode | What it demonstrates |
|---|---|---|
| Build the application from a Project Execution issue | `self-correcting-review auto-merge` | Task decomposition, implementation, review, correction and eligible automatic squash merges |
| Prepare an independent security checklist from Agent Goal #3 | Default `/execute-goal` | A review-ready PR followed by my review and manual merge |

Project Executor selects and delegates goals. Goal Executor performs eligible merges after validation and self-correcting review. High-risk or otherwise ineligible changes still require human review. The independent standalone goal does not inherit the project's authorization.

Project [#2](https://github.com/szymoniwacz/feedback-index-test-2/issues/2) and goal [#3](https://github.com/szymoniwacz/feedback-index-test-2/issues/3) have separate file ownership and may run concurrently when executor coordination permits. Goal #3 exclusively owns `docs/security-review.md` and always stops for human review.

The [demo guide](docs/demo-guide.md) describes the evidence to capture and how to run the app locally.

## Reusing and improving the workflow

This project is based on [ai-project-template-adapter](https://github.com/szymoniwacz/ai-project-template-adapter). It connects a public project to my private reusable workflow through the `.ai-template` Git submodule.

| Part | Responsibility |
|---|---|
| Private `ai-project-template` | Shared instructions, planning, review and executor procedures |
| Public template adapter | Setup scripts, tool entrypoints and automation loaders |
| This project | Product requirements, decisions, application code and evidence |

I can improve the shared workflow centrally and bring those improvements into this project:

```bash
./scripts/update-ai-workflow.sh
./scripts/ai-workflow-doctor.sh
./scripts/check-workflow-leak.sh
git diff --submodule=log -- .ai-template
```

Setup fetches the configured upstream revision, materializes the workflow locally, and restores **tracked project documentation** over it. Add new project overlay files to Git before running setup again. I review and commit the changed submodule reference explicitly; updates are not silently published.

This updates the private workflow. Changes to public adapter scripts must be reviewed and incorporated separately. Private workflow files must not be committed into this public repository.

## Setup and validation

Application commands (Ruby 3.2.3, Rails 8.0.2, SQLite):

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails test
bin/rails server
```

Then open http://localhost:3000 — the seeded inbox shows synthetic items across categories; use filters and category controls to verify behaviour.

Workflow setup requires read access to the private template:

```bash
./scripts/setup-ai-workflow.sh
./scripts/ai-workflow-doctor.sh
```

Public adapter checks do not require private template access:

```bash
bash tests/test-adapter.sh
./scripts/check-workflow-leak.sh
```

These validate the adapter, not application behaviour. Public readers can inspect project documentation and implementation evidence without private workflow access. Running the application must not require that access.

## Current limits

Brakeman and RuboCop are available locally (`bin/brakeman`, `bin/rubocop`) but are not separate CI jobs to keep checks economical. Demo video recording is optional and not required for project completion.

## License

This project uses the [MIT license](LICENSE), including new application code. The inherited adapter notice is retained.
