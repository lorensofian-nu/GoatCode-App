# Workspace instructions — Flutter learning platform

## Mission
Build a responsive Flutter Web platform that teaches programming fundamentals through a guided, progressive learning experience. Treat the supplied product description and wireframes as primary input; do not invent product requirements when they can be discovered from those sources.

## Leadership and approvals
- `project-lead` is the primary coordinator and integration owner.
- Work in a hybrid-autonomy mode: research, inspect, decompose, compare options, and prepare a recommendation autonomously.
- Obtain explicit user approval before committing to consequential architecture decisions: state management, routing strategy, persistence/database, authentication/authorization, backend boundaries, payment/monetization, analytics/telemetry involving user data, deployment topology, or a paid/externally billed service.
- Do not ask for approval for ordinary implementation details that follow an approved architecture and existing conventions.
- Keep a visible decision log. Every proposal must include context, alternatives, trade-offs, recommendation, cost/security implications, and what becomes harder to change later.

## Multi-agent collaboration
- Delegate bounded, independent work to the registered specialist agents when Antigravity exposes its supported subagent invocation capability.
- Do not claim parallel delegation unless subagents were actually invoked and their results inspected.
- Use isolated worktrees for parallel code changes where available. Avoid concurrent writes to the same files. The lead owns integration and conflict resolution.
- When subagents are unavailable, execute the same work sequentially and record the limitation.

## Product and learning quality
- Target beginner learners. Explain concepts simply without being inaccurate or patronizing.
- Design learning around progression, small explanations, worked examples, hands-on practice, feedback, review, and observable mastery.
- Do not turn the platform into a passive article catalogue unless the product brief explicitly requires that.
- Distinguish learning content from application code. Keep lesson content structured and maintainable outside large UI widgets.
- Avoid unsupported claims, fabricated references, and fake learner metrics.

## Flutter and responsive UX
- Use Flutter Web and adaptive layouts based on available constraints, not device-name assumptions.
- Validate at narrow mobile, tablet, laptop, and wide desktop widths.
- Keep widgets focused, reusable, testable, and accessible. Avoid giant page widgets and over-engineered abstractions.
- Prefer feature-first organization with clear separation of presentation, domain logic, and data access where complexity justifies it.
- Do not choose state-management, routing, backend or persistence packages until the architect has reviewed project needs and presented the options requiring approval.

## Visual assets and Gemini API
- Use Gemini image generation (Nano Banana family) only for visual assets that benefit from illustration: characters, learning-scene art, empty states, decorative backgrounds, badges, and similar assets.
- Do not generate raster images for text, buttons, forms, navigation, code editors, or other functional UI controls.
- Maintain an asset manifest with prompt, model, aspect ratio, intended use, source references, output path, status, and revision notes.
- Preserve consistent characters, palette, line style, lighting, and composition across related assets.
- Generate assets through a local/private tool or server-side service. Never expose Gemini credentials in the browser bundle or commit secrets.

## Engineering standards
- Inspect the existing repository before creating, moving, or overwriting files.
- Preserve existing conventions and user work. Never replace a non-empty file without reviewing it and explaining the reason.
- Make small, coherent, testable changes. Avoid speculative dependencies.
- Add tests for meaningful logic and state transitions. Test loading, empty, success, error, validation, and responsive states as applicable.
- Run formatter, analyzer, relevant tests, and a web build when the Flutter app exists. Report commands and actual outcomes; never claim a test passed if it was not run.
- Do not silently suppress warnings, remove tests, weaken checks, or replace real behavior with placeholders to make a build pass.

## Required project records
Maintain these files as the project evolves:
- `docs/00-context-input.md`
- `docs/01-requirements.md`
- `docs/02-user-journeys.md`
- `docs/03-design-system.md`
- `docs/04-architecture.md`
- `docs/05-learning-roadmap.md`
- `docs/06-asset-manifest.csv`
- `docs/07-quality-gates.md`
- `docs/08-decision-log.md`
- `docs/09-backlog.md`
- `docs/10-project-status.md`

## Delivery discipline
At the end of each milestone, report: completed work, changed files, validation performed and results, unresolved issues, decisions needing approval, and next recommended milestone. Separate facts, assumptions, recommendations, and blockers.
