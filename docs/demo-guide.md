# Demo guide

| Approximate time | Show | Explain |
|---|---|---|
| 0:00 to 0:30 | README and project goal | Product outcome and demo purpose |
| 0:30 to 1:00 | Requirements and decisions | Context prepared before implementation |
| 1:00 to 1:45 | Actual issue and delegated goals | How the agent divided the outcome |
| 1:45 to 2:30 | One project PR, checks and eligible auto-merge | What was reviewed and corrected, if anything |
| 2:30 to 3:00 | Working app, separate goal PR and update mechanism | Human review boundary and workflow reuse |

This is an edited walkthrough of a real run, not a claim that execution takes three minutes.

After execution, record actual URLs for the project issue, delegated goals, representative PR, validation and human review. Add a screenshot or short recording of the implemented app. Distinguish local checks from CI.

Do not manufacture failed tests or review findings. If the run has no correction cycle, say so. Record any real execution pause and its resolution.

Before starting either run, merge bootstrap PR #1, initialize the private workflow, run its doctor and leak check, and verify automation access and triggers. Project #2 owns runtime bootstrap, real commands and the product readiness gate before implementing product behaviour. Goal #3 can prepare its checklist from the requirements without waiting for application code. Creating an issue alone does not authorize execution.

## Two runs

| Run | Owner comment after readiness | Expected stopping point |
|---|---|---|
| Project Execution | `/execute-project self-correcting-review auto-merge` | Eligible goals are reviewed, validated and squash-merged; ineligible goals escalate |
| Independent security checklist goal #3 | `/execute-goal` | Review-ready PR; Szymon reviews and merges |

Project Executor delegates; Goal Executor performs eligible merges. This does not require enabling GitHub's delayed auto-merge queue.

The human-review example is [goal #3](https://github.com/szymoniwacz/feedback-index-test-2/issues/3): a short security checklist in `docs/security-review.md`. Project [#2](https://github.com/szymoniwacz/feedback-index-test-2/issues/2) must not modify that file. Each run uses an isolated workspace and branch. Start both independently if canonical coordination permits; respect locks if the executor serializes work.

Review the checklist for relevance, correct links, accurate private-workflow boundaries and honest status labels. Do not insert deliberate defects to manufacture review feedback. The human reviewer may request real improvements, then merge manually.

After product implementation, verify the browser flow and real restart persistence against the acceptance details in [requirements](../.ai/docs/project-requirements.md). Local quick start:

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open http://localhost:3000, submit an item, change a category, filter, and restart the server to confirm persistence (see `test/integration/restart_persistence_test.rb` for the automated restart check). Update delivery status and evidence throughout project documentation before announcing project completion.

Record the owner's actual trigger comments and resulting merge evidence. The commands above are reference text, not execution authorization.

For this rehearsal, verify the repository-specific checks in [automation setup](automation-setup.md#rehearsal-repository-verification). A Git mirror does not copy automation configuration or credentials.
