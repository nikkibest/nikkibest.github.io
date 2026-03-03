# CLAUDE.md

Guidance for Claude Code when working in this repository.

---

## Project Overview

This is a GitHub Pages site built with Jekyll, using the `github-pages` gem and the `jekyll-theme-minimal` theme.  
It serves as a personal résumé and portfolio, with special support for C++/Emscripten WebAssembly demos.

Key content:
- `index.md` – Home page / brief intro and links
- `cv.md` – CV / résumé page
- `projects.md` – Project listing with cards, including WebAssembly demos
- `projects/ball-balancer` and `projects/my-cpp-game` – Example WASM projects

---

## Local Development

The project is configured via `Gemfile` to use `github-pages` and `webrick`. Always run Jekyll through Bundler.

### Setup (first time)

```bash
cd /home/nds/Projects/nikkibest.github.io
bundle install
```

### Serve locally

```bash
bundle exec jekyll serve
```

Notes:
- The site is available at `http://localhost:4000`.
- `_plugins/mime_types.rb` registers the `application/wasm` MIME type so `.wasm` files work correctly in local dev.
- Use `bundle exec jekyll serve` instead of `jekyll serve` so plugins and the `github-pages` version of Jekyll are used.

### Build

```bash
# Standard build (outputs to _site/)
bundle exec jekyll build

# Production-optimized build
JEKYLL_ENV=production bundle exec jekyll build
```

Do **not** edit anything inside `_site/`; it is generated output.

---

## Jekyll Configuration & Navigation

Configuration lives in `_config.yml`:
- `theme: jekyll-theme-minimal`
- `title`, `description`, and `author` metadata
- `plugins`: `jekyll-feed`, `jekyll-seo-tag`
- `navigation`: array defining the main nav links (Home, CV, Projects)

When adding new top-level pages that should appear in the nav, update the `navigation` array in `_config.yml` with:

```yaml
navigation:
  - title: Home
    url: /
  - title: CV
    url: /cv.html
  - title: Projects
    url: /projects.html
  # - title: New Page
  #   url: /new-page.html
```

`CLAUDE.md` is listed in `_config.yml` under `exclude`, so it will not be published to the site.

---

## Layouts, Includes, and Styles

Custom layout and styling relevant to this project:

- `_layouts/default.html`
  - Base layout for most pages.
  - Renders site title/description, main navigation (`site.navigation`), GitHub links, and `{{ content }}`.

- `_layouts/wasm-project.html`
  - Layout for WebAssembly project pages that embed a canvas plus descriptive text.
  - Uses:
    - `assets/css/wasm-demo.css` for demo styling and project cards.
    - `_includes/wasm-loader.html` to configure the global `Module` object and show a loading overlay/progress bar.
  - Expects front matter such as:
    - `canvas_width`, `canvas_height`
    - `show_controls` (optional)
    - `technologies` (list)
    - `github_url`, `download_url` (optional)
    - `wasm_js_file` – path to the Emscripten-generated JS glue file.

- `_layouts/fullscreen.html`
  - Alternative layout used by `projects/ball-balancer.html` for a full-window canvas experience with a simple top bar.
  - Manually defines its own `Module` configuration and loads the JS glue script directly.

- `_includes/wasm-loader.html`
  - Shared WebAssembly loader: defines the global `Module` object, progress handling, error overlay, and canvas visibility toggling.

- `assets/css/wasm-demo.css`
  - Styles for:
    - The WASM demo container, loading overlay, progress bar, and error states.
    - The project information section and tech tags.
    - Project cards and grid used on `projects.md`.
    - Responsive layout and print behavior.

Any new WebAssembly layout or page should generally reuse `_layouts/wasm-project.html` and `_includes/wasm-loader.html` unless there is a strong reason to duplicate logic (as in the custom fullscreen example).

---

## WebAssembly Projects Workflow

Dedicated documentation exists in:
- `WASM_PROJECTS_GUIDE.md` – detailed, step-by-step guide to integrating C++/Emscripten projects.
- `QUICK_REFERENCE.md` – short cheat sheet for adding a new WASM project and updating `projects.md`.
- `projects/my-cpp-game/README.md` – per-project instructions for dropping in compiled artifacts.

Conventions:
- One WASM project per directory under `projects/` (e.g., `projects/ball-balancer`, `projects/my-cpp-game`).
- Emscripten output (`.js`, `.wasm`, `.data`) lives inside that directory.
- Project page:
  - For typical projects: `projects/<name>/index.html` with `layout: wasm-project`.
  - For special fullscreen pages: optionally use `layout: fullscreen` (like `projects/ball-balancer.html`).
- `projects.md` contains the project cards. Each card:
  - Links to the project page.
  - Uses a thumbnail in `assets/images/` (see the CSS for sizing).

When adding or modifying WASM integrations:
- Keep file paths consistent with front matter (`wasm_js_file`) and the loader’s `locateFile` behavior.
- Prefer updating existing layouts/includes rather than duplicating loader logic across many pages.
- If you need new project types, consider creating new layouts that extend `wasm-project.html`.

---

## Content Pages

Main content entry points:
- `index.md` – Home page; simple markdown content rendered via `default` layout.
- `cv.md` – Résumé content, including a link to `assets/cv.pdf`.
- `projects.md` – Project overview, including a `project-grid` of cards styled by `wasm-demo.css`.

Template-style sections in `projects.md` and some project pages are intentionally left as placeholders and can be safely edited or replaced with real content.

---

## GitHub Pages Deployment

Deployment is managed by GitHub Pages:
- The `github-pages` gem in `Gemfile` pins a compatible Jekyll + plugin stack.
- Pushing to the `main` branch triggers GitHub Pages to build and deploy using its own environment.

Guidelines:
- Do **not** commit `_site/`.
- Respect GitHub file size limits for large `.wasm`/`.data` files; use Git LFS or external hosting if needed (see the WASM guides).
- When changing dependencies or plugins, keep compatibility with `github-pages` (avoid adding arbitrary Jekyll plugins that are not supported).

---

## Safe Change Guidelines for Claude

When making changes in this repo:
- Prefer editing markdown content (`index.md`, `cv.md`, `projects.md`, project pages) and existing layouts/includes over introducing new complex structures.
- Keep navigation in sync with available top-level pages by editing `_config.yml`.
- Avoid editing:
  - `_site/` (generated)
  - GitHub Pages build configuration on the GitHub side (not present in this repo)
- For WebAssembly projects:
  - Follow `WASM_PROJECTS_GUIDE.md` and `QUICK_REFERENCE.md`.
  - Maintain the directory-per-project structure and keep file names consistent with Emscripten output and front matter.

If in doubt about how to integrate a new C++/WebAssembly demo, start by duplicating an existing working example (e.g., `projects/my-cpp-game/index.html`) and adapting it.

