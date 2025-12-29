# Quick Reference: Adding WebAssembly Projects

## TL;DR - Fast Track

```bash
# 1. Create project directory
mkdir -p projects/my-game

# 2. Compile with Emscripten
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -O3

# 3. Copy files
cp game.js game.wasm projects/my-game/

# 4. Create projects/my-game/index.html (see template below)

# 5. Add thumbnail to projects.md (see template below)

# 6. Test and deploy
bundle exec jekyll serve
git add . && git commit -m "Add game" && git push
```

## Minimal Project Page Template

File: `projects/my-game/index.html`

```html
---
layout: wasm-project
title: "My Game Title"
wasm_js_file: "/projects/my-game/game.js"
github_url: "https://github.com/nikkibest/my-game"
---

## About

Your game description here.

## Controls

- Arrow keys: Move
- Space: Action
```

## Projects.md Card Template

Add to `projects.md` in the `<div class="project-grid">` section:

```html
<div class="project-card">
  <a href="/projects/my-game/" class="project-link">
    <div class="project-thumbnail">
      <img src="/assets/images/my-game-thumb.png" alt="My Game">
      <div class="project-overlay">
        <span class="play-icon">▶ Play Demo</span>
      </div>
    </div>
    <div class="project-details">
      <h3>My Game Title</h3>
      <p class="project-tech">C++ • WebAssembly • SDL2</p>
      <p class="project-description">
        Brief description of your game.
      </p>
    </div>
  </a>
</div>
```

## Emscripten Commands Cheat Sheet

```bash
# Basic
emcc game.cpp -o game.js -s WASM=1

# With SDL2
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2

# With assets
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 --preload-file assets

# Production (optimized)
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -O3 -s ASSERTIONS=0

# Debug
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -g
```

## File Locations

```
projects/my-game/index.html          - Project page
projects/my-game/game.js             - Emscripten JS glue code
projects/my-game/game.wasm           - WebAssembly binary
assets/images/my-game-thumb.png      - Thumbnail (400x300)
```

## Testing

```bash
# Local server
bundle exec jekyll serve

# View at:
http://localhost:4000/projects/my-game/
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Canvas not showing | Check `wasm_js_file` path in front matter |
| Loading stuck | Verify .wasm file exists, check browser console |
| Memory error | Add `-s ALLOW_MEMORY_GROWTH=1` to emcc |
| File too large | Use `-O3` and `--closure 1`, or Git LFS |

For detailed help, see `WASM_PROJECTS_GUIDE.md`
