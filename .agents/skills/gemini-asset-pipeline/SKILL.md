---
name: gemini-asset-pipeline
description: "Plans and validates secure Gemini API Nano Banana image-generation workflows, prompts, asset manifests, consistency, and image QA."
---


# Gemini image asset pipeline procedure

1. Inspect design system and reference images. Define reusable visual style and character sheet before creating a batch.
2. Read current official Gemini image generation documentation. Verify exact model ID, SDK/API method, output sizes/aspect ratios, quotas, pricing, limits and terms.
3. Configure model through `GEMINI_IMAGE_MODEL`; do not assume a model ID remains available.
4. Read API credentials only from a private process environment or ignored local `.env`. Never expose them in Flutter Web or source control.
5. Create one prompt per asset: intent, subject, pose/action, composition, camera, palette, line/render style, lighting, background, target crop, aspect ratio, resolution, transparency and exclusions.
6. Produce one sample first and obtain visual approval before generating a large or billable batch.
7. Validate file type, dimensions, file size, background/transparency, subject clipping, consistency and usability.
8. Export to `assets/generated/<category>/` with stable descriptive names.
9. Update `docs/06-asset-manifest.csv` with prompt revision, model, date, parameters, output, status and reviewer.
10. Keep an audit trail; never claim an asset exists unless its output file is present and verified.
