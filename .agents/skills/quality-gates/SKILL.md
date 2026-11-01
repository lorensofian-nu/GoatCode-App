---
name: quality-gates
description: "Runs independent quality gates for Flutter code, responsive UX, accessibility, testing, performance, security, and release readiness."
---


# Quality gates procedure

1. Read acceptance criteria and identify changed behavior.
2. Inspect diff and surrounding implementation.
3. Verify code formatting, analyzer, tests and web build; record commands and outputs.
4. Check mobile/tablet/laptop/desktop with explicit viewport sizes.
5. Review accessibility, semantic labels, keyboard and focus, contrast and text scaling.
6. Check empty/loading/error/success and invalid-input paths.
7. Review secrets, dependencies, user data, network calls, logs and external services.
8. Review asset loading, dimensions, size, consistency and alt semantics.
9. Report BLOCKER/HIGH/MEDIUM/LOW with evidence and concrete reproduction.
10. Re-test fixes; do not mark closed without evidence.
