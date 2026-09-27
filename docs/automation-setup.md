# Cloud Automation Setup

## Purpose

Cloud automation must use the same private workflow revision and the same materialized `.ai/` runtime as local agents. The public adapter never embeds Project Executor or Goal Executor logic.

## Required access

An automation run needs:

1. read/write access to the target repository as required by the private workflow,
2. read access to the private `szymoniwacz/ai-project-template` repository,
3. a workspace where the target repository can initialize its `.ai-template` submodule,
4. provider credentials stored as runtime secrets or equivalent external configuration.

Never commit a private-repository token, deploy key, or generated credential.

## Runtime bootstrap

At the beginning of a run, before any repository mutation or remote write:

1. read the appropriate public loader from the target repository default branch,
2. ensure `.ai-template` can be initialized,
3. run `./scripts/setup-ai-workflow.sh` when `.ai/README.md` is not already materialized,
4. verify the required private executor files exist under `.ai/automation/`,
5. delegate to the private executor runtime,
6. fail closed if any of the above cannot be completed.

Reusable materialized private workflow files under `.ai/` are workspace state only and must not be committed. Allowlisted project-owned `.ai/` documents remain tracked and are maintained by the project.

## Project Executor loader

Use:

```text
docs/ai-workflow/project-executor-loader.md
```

The saved/live automation prompt should remain a small loader that reads this public file from the target default branch, then follows it. Do not paste Project Executor state-machine logic into the public prompt.

## Goal Executor loader

Use:

```text
docs/ai-workflow/goal-executor-loader.md
```

Again, the public automation prompt loads the private runtime rather than duplicating it.

## Trigger configuration

The adapter deliberately does not duplicate private trigger, authorization, review, or merge rules.

After private workflow setup, use the production-setup documents materialized from `ai-project-template`, including the Project Executor and Goal Executor automation setup documents, as the source of truth for provider trigger configuration.

This keeps public loader behavior stable while the private workflow can evolve independently.

## Verification

Before enabling production automation for a generated repository:

1. run `./scripts/setup-ai-workflow.sh` locally,
2. run `./scripts/ai-workflow-doctor.sh`,
3. run `./scripts/check-workflow-leak.sh`,
4. configure the cloud environment with read access to the private submodule,
5. run a disposable automation invocation and verify the private runtime loads,
6. verify reusable materialized private workflow files are not present in the resulting Git diff,
7. only then enable normal Project Executor / Goal Executor triggers.

## Failure behavior

Private workflow unavailable means STOP. The automation must not infer a replacement workflow from README files, public loaders, chat history, or previous runs.

## Rehearsal repository verification

Target: `szymoniwacz/feedback-index-test-2`. Bootstrap PR #1, Project Execution #2 and independent Agent Goal #3 all belong to this repository.

A Git mirror copies Git history and refs, not installed-app permissions, automation repository filters, secrets, branch rules or merge settings. Before posting execution commands:

1. Merge this repository's bootstrap PR #1 and verify its default-branch CI.
2. In the actual executor environment, verify target-repository write access and private-template read access, then run setup, doctor and the leak check.
3. Verify both external executor configurations target this exact repository and load their public loaders from its default branch. Use the canonical production-setup documents for required events and filters.
4. Check that repository rules and available merge methods permit the intended eligible squash merges; preserve canonical review and authorization requirements.
5. Perform the disposable runtime-load verification described above and record the result. Do not use project #2 or goal #3 as a smoke test or post their execution commands during bootstrap verification.

Connector access and adapter CI do not verify the external executor's credentials or triggers. Until these checks are performed in that environment, automation readiness remains unverified.
