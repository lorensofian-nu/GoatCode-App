---
name: flutter-responsive
description: "Applies adaptive and responsive Flutter Web design, viewport-based layout decisions, accessibility, and cross-device validation."
---


# Flutter responsive implementation procedure

1. Inspect approved design tokens, reference wireframes and target content.
2. Identify layout constraints: minimum useful width, navigation collapse, columns, maximum content width, touch targets and overflow risks.
3. Use Flutter layout constraints and adaptive components rather than hardcoding device labels.
4. Define tested viewport matrix (small phone, large phone, tablet, laptop, wide desktop) using explicit pixel widths.
5. Check long labels, large text scale, keyboard focus, orientation, scroll behavior and loading/error/empty states.
6. Avoid rasterized functional interface elements; use real widgets.
7. Add widget tests for key breakpoints and interaction states; run browser checks when available.
8. Record actual viewports and results in the quality log.
