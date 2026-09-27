# Feedback Inbox

A small product feedback app used to demonstrate how I work with AI coding agents: define the product, provide durable context, let an agent break a goal into tasks, and inspect the resulting code, tests and review evidence.

**Status:** project definition prepared. The application and recorded demonstration have not been implemented yet.

## What the app will do

Users will submit feedback, browse an inbox, assign a category (`bug`, `feature request` or `other`), and filter the list. The scope is deliberately small so that the engineering process is easy to follow.

This is an independent engineering demo using synthetic data.

## Why I am building this

I want to show how I turn a short product goal into reviewable software using AI. Requirements, context, scope, validation and review need to be explicit as well as the code.

The walkthrough should take about three minutes. Its evidence will be the actual project issue, delegated goals, pull requests and check results.

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

These are planned demonstrations. The repository owner starts each run explicitly after merging the bootstrap and verifying workflow access and automation triggers. Project #2 establishes runtime readiness before implementing the app; documentation goal #3 can proceed without the app. Creating an issue does not start a run.

Project [#2](https://github.com/szymoniwacz/feedback-index-test-2/issues/2) and goal [#3](https://github.com/szymoniwacz/feedback-index-test-2/issues/3) have separate file ownership and may run concurrently when executor coordination permits. Goal #3 exclusively owns `docs/security-review.md` and always stops for human review.

The [demo guide](docs/demo-guide.md) describes the evidence to capture. No successful execution, CI run or review correction is claimed until it actually happens.

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

Application setup and run commands will be added when the application exists. The selected stack is Ruby on Rails with SQLite and server-rendered HTML, for a local-only demo with synthetic data and no authentication. Project #2 selects compatible runtime versions and records verified commands during bootstrap.

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

These validate the adapter, not application behaviour. Public readers can inspect project documentation and eventual implementation evidence without private workflow access. Running the application must not require that access.

## Current limits

Application implementation, runtime versions, application commands and the recorded demo remain to be completed. Cloud automation access and triggers need verification for this repository. Documentation preparation does not establish application or automation readiness.

## License

This project uses the [MIT license](LICENSE), including new application code. The inherited adapter notice is retained.
