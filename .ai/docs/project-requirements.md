# Feedback Inbox requirements

## Purpose and current stage

Build a small feedback inbox to demonstrate AI assisted software delivery from a short project goal. This document is the source of truth for acceptance criteria. FR-001–FR-008 are implemented on `main`, including reproducible demo documentation and sample data.

The user wants the agent to choose the implementation task breakdown. Do not preassign child tasks or manufacture execution evidence.

**Active stack profile:** [ruby-rails](../stack-profiles/ruby-rails.md) (Ruby 3.2.3, Rails 8.0.2, SQLite).

## Users and first useful version

A demo user submits synthetic product feedback, reads an inbox, categorizes an item and filters the list. A reviewer inspects the requirements, real issues, code, tests and review evidence.

## Functional requirements

| ID | Requirement | Acceptance |
|---|---|---|
| FR-001 | Submit feedback with a title and description | Valid input creates one item; blank fields are rejected with readable errors and preserved input |
| FR-002 | Browse feedback | Newest items appear first with a deterministic tie break; title, description, category and creation time are visible |
| FR-003 | Assign or change a category | Only `bug`, `feature request` and `other` are accepted; uncategorized submissions start as `other`; changes survive reload; a failed change leaves the submission form usable |
| FR-004 | Filter by category | Each category shows only its own items; All restores the full list; an empty result is explained |
| FR-005 | Persist local feedback | Created items and changed categories survive a real process restart using the same database |
| FR-006 | Handle invalid requests | Reject unsupported category values and missing items without corrupting stored data; the user can recover and continue |
| FR-007 | Provide meaningful tests | Cover valid submission, validation, categorization, category filtering and persistence at appropriate boundaries |
| FR-008 | Make the demo reproducible | Document actual setup, run and test commands; provide a small synthetic sample dataset |

Categories are a manual triage tool. No LLM integration is needed inside the application.

## Inputs and outputs

Inputs are a feedback title, description, category and filter selection. Outputs are a rendered inbox, submission and category controls, confirmation or validation errors. Storage details and length limits will be recorded during runtime bootstrap.

## Quality and boundaries

Keep implementation small and understandable. Use labelled controls, keyboard access, readable errors, escaped user text and server-side validation. Do not introduce credentials, personal information or real customer data. Use synthetic examples only.

Non-goals: authentication, organizations, voting, comments, attachments, email, analytics, automatic categorization, semantic search, microservices and production hosting. A decision to expose the app publicly requires revisiting access and abuse controls first.

Acceptance requires passing meaningful application checks and a manual submit, categorize, filter and reload walkthrough. No performance or reliability measurements are claimed before measurement.

## Acceptance details

These define observable behaviour, not a task breakdown or prescribed implementation.

- After an invalid category update, display the error, preserve stored data and the active filter, and allow a subsequent valid new submission. Test the rendered submission form's action/method as well as the resulting request. Creation and editing must retain their distinct purposes after errors.
- Each repeated category control has a unique ID and an explicitly associated label. Verify this with multiple items and keyboard interaction.
- Verify ordering with tied timestamps and filtering for each allowed category, All and empty results.
- Persistence evidence must cross a real process boundary against the same isolated file-backed database, or document a repeatable manual stop/start check. Clearing a query cache is only a database reload check, not restart evidence.
- Verify the end-to-end flow in a browser once implemented: submit, invalid input and recovery, recategorize, filter, restart and reopen. Record the commit and results; do not claim checks that could not run.
- FR-008 includes keeping README, AGENTS.md, product context, this requirements document, roadmap and demo guide consistent with the delivered state. Update relevant documents as goals land and do a final consistency pass before project completion.
- Final delivery evidence links to this repository's actual goals, PRs and checks, including sample data and documentation work. A separate rehearsal must never be presented as this run.
- Record CI events and actual checks accurately. Adapter checks do not prove application behaviour. Do not imply that lint or security scans passed unless they ran. Keep CI economical; explain omitted checks and use local validation where appropriate.
- Capture a screenshot or short recording when possible. Recording the edited presentation and human approval of the independent checklist are not prerequisites for completing the product project.

## Workflow evidence

The project issue states the outcome. Project Executor selects scoped goals; implementation PRs retain their link to those goals. Record actual checks, review findings and human decisions. The first demo uses a Project Execution issue in `self-correcting-review auto-merge` mode; eligible delegated goals may be squash-merged after their checks and review pass. Independent security checklist goal #3 uses default `/execute-goal` and stops for human review and manual merge. Neither run is started by this bootstrap. Do not start execution merely because an issue was created.

### Independent execution boundaries

Project #2 owns the application and its project documentation, excluding `docs/security-review.md`. Goal #3 owns only that checklist, uses a separate branch and isolated workspace, and stops at human review. It does not inherit project auto-merge authorization. Neither run waits for the other run's deliverable. They may proceed concurrently only when the canonical executor coordination rules allow it; do not bypass locks.

Before starting either run, merge bootstrap PR #1 and verify private workflow access and the appropriate automation triggers. Product runtime bootstrap and unresolved implementation decisions are part of project #2's execution, not prerequisites for creating or authorizing that issue. The product readiness gate still applies before product behaviour is implemented. The documentation-only goal can proceed from the accepted requirements without a running application.

Public adapter checks already available:

```bash
bash tests/test-adapter.sh
./scripts/check-workflow-leak.sh
```

Workflow initialization additionally needs private template access. Application commands and the active stack profile do not exist yet and must be established before readiness passes.

## Accepted implementation baseline

Use Ruby on Rails, SQLite and server-rendered HTML for a local-only demo with synthetic data and no authentication. These baseline choices are accepted following the owner's review-fix instruction on 2026-09-27. Project #2 selects compatible runtime versions and dependencies, verifies them in the execution environment, records real commands and selects the matching stack profile. Routine choices within this baseline do not require renewed owner confirmation; material departures follow the canonical escalation policy. Szymon confirmed MIT for the entire project, including new application code.

## Project decision status

`deferred` items below do not block the current documentation task. They must be revisited at their stated trigger; they are not waived for implementation.

| Area | Status | Value / notes | Location / owner / return trigger |
|---|---|---|---|
| Product purpose | decided | Small Feedback Inbox demonstrating AI workflow | Purpose above; user brief |
| Users | decided | Demo user and engineering reviewer | Users above |
| Outcomes | decided | Understandable product and traceable delivery | Functional requirements and workflow evidence |
| Success criteria | decided | Accepted behaviour, real checks and review evidence | FR-001 through FR-008 |
| First useful version | decided | Submit, browse, categorize and filter | Functional requirements |
| Non-goals | decided | Keep a small demo | Quality and boundaries |
| Interfaces | decided | Web UI for the accepted product flows | Functional requirements |
| Inputs and outputs | decided | Feedback text, category, filter and inbox | Inputs and outputs |
| Architecture shape | decided | Single Rails application with server-rendered HTML | Accepted baseline; implementing agent |
| Boundaries | decided | App independent of the private engineering workflow | README setup and workflow sections |
| Storage and data ownership | decided | Local SQLite containing synthetic data | Accepted baseline; implementing agent |
| Retention and migrations | decided | `bin/rails db:prepare` for dev/test; reset via removing `storage/*.sqlite3` and re-running prepare | README and stack profile |
| Integrations and failure handling | decided | No app integrations; workflow setup fails closed if unavailable | Scope and inherited adapter |
| Authentication and authorization | decided | Local-only unauthenticated demo; no public hosting authorized | Accepted baseline; revisit before public exposure |
| Secrets, privacy, and sensitive data | decided | Synthetic data only; preserve private workflow separation | Quality and boundaries |
| Language, framework, and dependencies | decided | Ruby 3.2.3, Rails 8.0.2, Bundler; SQLite via `database.yml` | `.ruby-version`, `Gemfile.lock`, stack profile |
| Environments and deployment | decided | Local execution; production hosting out of scope | README setup; Kamal files are Rails defaults only |
| Configuration | decided | Standard Rails 8 config; credentials master key gitignored | `config/` |
| Logging, monitoring, and errors | deferred | Readable errors required for product UI; app logging defaults only | Product goals |
| Tests, lint, typecheck, performance | decided | `bin/rails test`; RuboCop/Brakeman locally; CI runs adapter + `bin/rails test` | `.github/workflows/ci.yml` |
| Scale, reliability, and cost | decided | Small synthetic demo; no availability SLA or paid app services | Scope |
| Supported platforms and compatibility | decided | Linux dev/CI; local browser for future UI demo | Verified in goal #4 environment |
| Accessibility and localization | decided | English interface; labelled keyboard-accessible controls | Quality and boundaries |
| Compliance, backup, and recovery | not-applicable | Disposable synthetic local demo; revisit if real data is introduced | Scope |
| Branching, CI, release, and rollback | decided | PR-only CI (adapter + Rails test); project auto-merge on eligible goals | This repository |
| License, ownership, and documentation expectations | decided | Szymon owns project decisions; MIT confirmed for all project code; maintain setup and validation documentation | LICENSE, README and decision log |

## Project readiness

| Check | Result | Notes |
|---|---|---|
| Definition coverage complete | Yes | Every decision area classified |
| No `blocking-question` remains | Yes | Future choices explicitly deferred for documentation stage |
| All `deferred` items have reason and return trigger | Yes | Remaining deferred items tied to product behaviour |
| Template customization complete | Yes | Project documents and Rails scaffold present |
| Stack profile selected or marked N/A | Yes | Active profile: ruby-rails |
| Real project commands recorded | Yes | README, stack profile, and verified local runs |
| Root README describes the product | Yes | Includes honest current state |
| `AGENTS.md` describes repository role | Yes | Thin entrypoint retained |
| Bootstrap markers removed | Yes | Supplied project placeholders replaced |
| License and ownership decided | Yes | MIT explicitly confirmed by Szymon |
| CI, branch rules, and approvals decided | Yes | Adapter contract + economical Rails test job on PRs |
| Project ready for first product task | Yes | Runtime bootstrap complete; proceed with FR-scoped goals |

This gate passes for product behaviour work. FR-001–FR-008 are implemented and tested on `main`.
