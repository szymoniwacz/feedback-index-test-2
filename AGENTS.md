# Agent Instructions

This is Feedback Inbox, a small product application and AI engineering workflow demonstration. Product context lives in `.ai/project/` and `.ai/docs/project-requirements.md`. Application implementation has not started.

This repository uses a private reusable AI workflow through the `.ai-template` submodule.

If `.ai/README.md` is not available, run `./scripts/setup-ai-workflow.sh` first. If the private workflow cannot be loaded, stop rather than inventing replacement workflow rules.

After setup, `.ai/` is the source of truth for workflow, policies, skills, review rules, Git rules, and automation instructions.

Read `.ai/README.md` first. For end-to-end goals follow `.ai/skills/execute-goal.md`.

Project-specific context is tracked in `.ai/` as an overlay and must not be overwritten by reusable workflow updates.
