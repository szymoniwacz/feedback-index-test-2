# Project decisions

| Date | Decision | Rationale and status |
|---|---|---|
| 2026-09-27 | Use Feedback Inbox | Selected in the project discussion; small and understandable product behaviour |
| 2026-09-27 | Use `ai-project-template-adapter` | User requested adapter reuse and an explanation of workflow updates |
| 2026-09-27 | Keep reusable workflow private and product context public | Preserve the adapter's separation and leak checks |
| 2026-09-27 | Keep the project issue short | User wants the agent to perform task decomposition |
| 2026-09-27 | Describe evidence honestly | Distinguish completed preparation from future execution |
| 2026-09-27 | MIT for the project and new application code | Explicitly confirmed by Szymon |
| 2026-09-27 | Demonstrate two execution modes | Project run with eligible automatic squash merges and independent security-checklist goal #3 with human review and manual merge; concurrent where executor coordination permits |
| 2026-09-27 | Linux adapter CI for this demo | No native platform application is in scope; one runner avoids an unnecessary matrix |

## Implementation baseline

| Decision | Rationale / responsibility |
|---|---|
| Ruby on Rails, SQLite, server-rendered HTML | Accepted for this demo following the owner's review-fix instruction on 2026-09-27 |
| Local-only execution, synthetic data, no authentication | Accepted bounded demo; public hosting remains out of scope |
| Runtime versions and compatible dependencies | Implementing agent selects, verifies and records these during project #2 bootstrap within the accepted stack |

Do not ask the owner to reconfirm these baseline choices. Escalate material departures under the canonical workflow. Runtime validation and automation verification remain required before product implementation.
