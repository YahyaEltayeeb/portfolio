# Portfolio Image Optimization & Lazy Loading Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Optimize all portfolio image assets for Flutter Web performance by converting PNG/JPG images to WebP format, updating all codebase references, enforcing lazy loading for gallery screenshots, and improving rendering performance while preserving visual quality and UI layout.

**Architecture:** A Python/Pillow conversion pipeline scales images to maximum dimension bounds (1600px for covers, 1200px for screenshots, 1200px height for profile) with WebP compression (quality 80 for project assets, 85 for profile RGBA). Dart asset constants in `app_assets.dart` and `projects_repository.dart` are updated to point to `.webp`. `PortfolioImage` is optimized with `RepaintBoundary` and a lightweight shimmer/pulse loading indicator. Old PNG/JPG files are safely removed only after tests and web build pass.

**Tech Stack:** Flutter Web, Dart 3.12+, Python 3.14 (Pillow 12.3.0), WebP, Git.

**Spec:** User request specifying 10 exact scan, conversion, code reference, lazy loading, performance, cleanup, verification, and reporting requirements.

## Global Constraints

- Do not change UI design, colors, content, ordering, or layout.
- Image optimization and lazy loading only.
- WebP quality: 80 for project images, 85 for profile/hero images.
- Covers: maximum 1600px on the longest side (do not upscale).
- Gallery screenshots: maximum 1200px on the longest side (do not upscale).
- Profile/hero image: maximum 1200px height (preserve RGBA transparency, do not upscale).
- Preserve original aspect ratios; do not crop or stretch.
- Clear filenames: `cover.webp`, `01.webp`, `02.webp`, etc.
- Old PNG/JPG versions removed only after reference updates, file verification, tests pass, and web build succeeds.
- Stop for user approval before committing or pushing.

---

### Task 1: Scan & Baseline Reporting

**Files:**
- Create: `tool/optimize_images.py`
- Read: `assets/images/`

**Interfaces:**
- Produces: Baseline scan data (total count, total MB, top 10 largest files, dimensions, formats).

- [ ] **Step 1: Write comprehensive image scanner and metadata extractor in Python**
- [ ] **Step 2: Run baseline scan and verify accurate accounting of all 55 existing images (91.51 MB)**
- [ ] **Step 3: Document initial baseline report in plan/log**

---

### Task 2: WebP Conversion Engine & Asset Generation

**Files:**
- Modify: `tool/optimize_images.py`
- Generate: 54 `.webp` files in `assets/images/` and subdirectories (`assets/images/projects/*/`, `assets/images/profile.webp`)

**Interfaces:**
- Consumes: PNG and JPG source files in `assets/images/`.
- Produces:
  - 6 covers: `cover.webp` (max 1600px longest side, Q=80).
  - 47 screenshots: `01.webp` .. `NN.webp` (max 1200px longest side, Q=80).
  - 1 profile: `profile.webp` (max 1200px height, Q=85, RGBA transparency preserved).

- [ ] **Step 1: Implement conversion logic in `tool/optimize_images.py` adhering to sizing and quality rules**
- [ ] **Step 2: Run conversion script to generate all 54 `.webp` files**
- [ ] **Step 3: Verify all 54 WebP files exist, are valid images, have correct dimensions, and preserve RGBA on `profile.webp`**

---

### Task 3: Dart References & Asset Configuration Updates

**Files:**
- Modify: `lib/core/constants/app_assets.dart`
- Modify: `lib/portfolio/repositories/projects_repository.dart`
- Modify: `test/repositories/repositories_test.dart`

**Interfaces:**
- Consumes: Generated `.webp` files.
- Produces: Updated Dart constants and repositories referencing `.webp` files instead of `.png` and `.jpg`.

- [ ] **Step 1: Update `AppAssets` constants in `lib/core/constants/app_assets.dart` to `.webp`**
- [ ] **Step 2: Update all screenshot asset paths in `lib/portfolio/repositories/projects_repository.dart` to `.webp`**
- [ ] **Step 3: Update repository tests in `test/repositories/repositories_test.dart` to expect `.webp` covers and screenshots**
- [ ] **Step 4: Run `flutter test test/repositories/repositories_test.dart` to verify all 54 asset files exist on disk and pass tests**

---

### Task 4: Performance & Lazy Loading Enhancements

**Files:**
- Modify: `lib/portfolio/presentation/widgets/portfolio_image.dart`
- Inspect: `lib/portfolio/presentation/screens/project_details_screen.dart`
- Inspect: `lib/portfolio/presentation/widgets/full_screen_image_viewer.dart`
- Inspect: `lib/portfolio/presentation/sections/hero/portrait_container.dart`

**Interfaces:**
- Consumes: `PortfolioImage` widget.
- Produces: Optimized `PortfolioImage` with `RepaintBoundary` isolation and a lightweight skeleton loading state.

- [ ] **Step 1: Enhance `PortfolioImage` with `RepaintBoundary` to prevent unnecessary repaints during scrolling**
- [ ] **Step 2: Add a lightweight skeleton loading indicator while the image decodes**
- [ ] **Step 3: Verify that screenshots are only loaded in `ProjectDetailsScreen` and not preloaded on the homepage**
- [ ] **Step 4: Verify full test suite passes with `flutter test`**

---

### Task 5: Old Asset Cleanup

**Files:**
- Delete: 53 old `.png` and 1 `.jpg` files in `assets/images/` (total 54 old files).
- Keep: Generated `.webp` files and `.gitkeep` files.

**Interfaces:**
- Consumes: Verification that all references use `.webp` and tests pass.
- Produces: Cleaned directory containing only optimized `.webp` assets.

- [ ] **Step 1: Verify all 54 `.webp` files exist and are verified**
- [ ] **Step 2: Delete old PNG/JPG files in `assets/images/`**
- [ ] **Step 3: Run `flutter test` to ensure zero missing asset errors**

---

### Task 6: Verification & Final Report Generation

**Files:**
- Workspace root

**Interfaces:**
- Consumes: Completed migration.
- Produces: Verification outputs and final metrics report.

- [ ] **Step 1: Run `dart format .`**
- [ ] **Step 2: Run `flutter analyze`**
- [ ] **Step 3: Run `flutter test`**
- [ ] **Step 4: Run `flutter build web --release --base-href "/portfolio/"`**
- [ ] **Step 5: Calculate before/after size metrics and print comprehensive summary**
- [ ] **Step 6: Stop for user approval before committing or pushing**
