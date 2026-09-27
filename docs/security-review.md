# Feedback Inbox — security review checklist

**Baseline:** requirements and adapter docs at commit `41452c4751e010cb8c1450c16f3fab902f3cd50d` on `main`.  
**Scope:** pre-implementation review from [project requirements](../.ai/docs/project-requirements.md) and [scope](../.ai/project/scope.md). This is not a penetration test or code audit; application code does not exist yet.

**Legend:** **Req** = documented requirement; **Assumption** = accepted baseline not yet verified in running software; **Check** = verification to perform when the app exists.

---

## 1. Untrusted feedback (XSS and HTML injection)

| | |
|---|---|
| **Risk** | Titles and descriptions are user-controlled. Rendering them unsafely could execute script in a reviewer’s browser or break the UI. |
| **Safeguard (Req)** | Escape user text in views; use labelled controls and readable errors ([requirements](../.ai/docs/project-requirements.md) — quality and boundaries). |
| **Verification (Check)** | Submit strings such as `<script>alert(1)</script>`, event handlers, and HTML entities; confirm they appear as literal text in the inbox and after category changes and filter changes. Repeat after process restart. |

---

## 2. Server-side input and category validation

| | |
|---|---|
| **Risk** | Missing or client-only validation could accept invalid categories, corrupt data, or leave the app in a bad state after errors. |
| **Safeguard (Req)** | Reject blank title/description; accept only `bug`, `feature request`, and `other`; handle missing items without corrupting stored data (FR-001, FR-003, FR-006). |
| **Verification (Check)** | Exercise invalid submissions, unsupported category values, and updates to non-existent items via the UI and direct HTTP requests; confirm stored rows unchanged, errors are readable, and a valid submission still works afterward. |

---

## 3. Secrets and sensitive data

| | |
|---|---|
| **Risk** | Committing credentials, using real customer data, or logging secrets would expose the demo or the owner’s environment. |
| **Safeguard (Req)** | Synthetic feedback only; no credentials or PII in the product scope ([scope](../.ai/project/scope.md)). |
| **Verification (Check)** | Inspect repo and runtime config for API keys and `.env` leaks; confirm sample data is obviously synthetic; ensure logs do not print full request bodies with secrets if logging is added later. |

---

## 4. Private workflow boundary (repository adapter)

| | |
|---|---|
| **Risk** | Publishing copied private workflow files would leak reusable instructions; confusing tracked vs materialized paths could cause accidental commits of private content. |
| **Safeguard (Req)** | Public repo tracks `.gitmodules`, the `.ai-template` gitlink, and allowlisted project-owned `.ai/**` overlay (e.g. project docs, requirements). Materialized private template content under `.ai/` (except tracked overlay), `.agents/`, and `.cursor/commands/` must stay untracked and local ([repository specification](repository-specification.md), [setup](setup.md)). |
| **Verification (Check)** | Run `./scripts/check-workflow-leak.sh` before pushes; confirm `git status` does not stage materialized workflow files; submodule access remains private while only the gitlink is public. |

---

## 5. Unauthenticated local use

| | |
|---|---|
| **Risk** | A network-exposed instance without auth allows anyone to read or poison demo data; local-only assumptions fail if the app is bound to non-loopback interfaces. |
| **Safeguard (Req)** | Local-only demo with no authentication; public hosting is out of scope until access and abuse controls are revisited ([requirements](../.ai/docs/project-requirements.md) — authentication). |
| **Assumption** | Default Rails bind and deployment are developer-local until documented otherwise. |
| **Verification (Check)** | Confirm documented run instructions use local access only; if the server listens on `0.0.0.0`, document the risk and restrict usage to trusted networks or bind to localhost. |

---

## Checks not performed in this document

- No dynamic analysis, dependency CVE scan, or Rails-specific secure-headers review (stack not bootstrapped).
- No verification of CSRF protections, rate limiting, or SQLite file permissions (to be confirmed during implementation).

---

## Open questions (material only)

1. **SQLite file location and permissions** — Should the checklist require a explicit path under the project with restrictive file mode once bootstrap records it?
2. **CSRF** — For a local unauthenticated demo, is Rails default CSRF protection sufficient without additional threat modeling?

---

## Suggested reviewer focus

Confirm each row maps to an acceptance criterion, that Req vs Check labeling is honest, that relative links from `docs/` resolve, and that the adapter boundary matches [repository-specification.md](repository-specification.md) without expanding product scope.
