# Private Gemini asset pipeline — specification

This folder documents the intended private asset-generation tool. It is not wired into Flutter Web yet.

## Security boundary

```text
Private local script or private backend
  -> reads GEMINI_API_KEY from process environment / local .env
  -> calls official Gemini SDK / API
  -> validates image output
  -> writes approved asset into assets/generated/
  -> updates docs/06-asset-manifest.csv

Flutter Web -> serves approved, static assets only
```

Never put a Gemini API key in Dart code, `web/`, browser local storage, frontend build-time public variables, or a committed config file.

## Initial configuration

```env
GEMINI_API_KEY=...
GEMINI_IMAGE_MODEL=gemini-nano-banana-2.1
```

The model ID is a dated starting point from the official Gemini image generation documentation consulted on 2026-10-31. Verify model availability, pricing, quotas, supported aspect ratios, SDK version, and terms before implementation or bulk generation.

## Planned responsibilities

1. Read a prompt manifest entry.
2. Verify private credentials and selected model.
3. Generate one sample asset, never an unapproved bulk batch.
4. Save output using stable, descriptive names.
5. Validate file format, dimensions, size and transparency.
6. Update manifest with model, prompt revision, date, output path and review status.
7. Keep generated files out of application code until visual review passes.

## Official reference

https://ai.google.dev/gemini-api/docs/image-generation
