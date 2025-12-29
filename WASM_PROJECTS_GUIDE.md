# WebAssembly Projects Integration Guide

This guide explains how to add C++/Emscripten WebAssembly projects to your Jekyll portfolio site.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Directory Structure](#directory-structure)
3. [Adding a New WASM Project](#adding-a-new-wasm-project)
4. [Customizing the Project Page](#customizing-the-project-page)
5. [Adding Project Thumbnails](#adding-project-thumbnails)
6. [Emscripten Compilation Guide](#emscripten-compilation-guide)
7. [Troubleshooting](#troubleshooting)
8. [Best Practices](#best-practices)

---

## Quick Start

To add a new WebAssembly game/project to your portfolio:

1. **Create project directory**: `mkdir -p projects/your-project-name/`
2. **Compile your C++ code** with Emscripten
3. **Copy WASM files** to the project directory
4. **Create project page** (copy from template below)
5. **Add thumbnail** to projects.md
6. **Test locally** with `bundle exec jekyll serve`
7. **Commit and push** to GitHub

---

## Directory Structure

Your WebAssembly projects should follow this structure:

```
nikkibest.github.io/
├── _layouts/
│   ├── default.html
│   └── wasm-project.html          # Layout for WASM project pages
├── _includes/
│   └── wasm-loader.html            # Reusable WASM loading component
├── assets/
│   ├── css/
│   │   └── wasm-demo.css           # Styling for WASM demos
│   └── images/
│       ├── game-thumbnail.png      # Thumbnail for projects page
│       └── project2-thumb.png
├── projects/
│   ├── my-cpp-game/                # Example project 1
│   │   ├── index.html              # Project page
│   │   ├── game.js                 # Emscripten JS glue code
│   │   ├── game.wasm               # Compiled WebAssembly
│   │   ├── game.data               # Preloaded assets (optional)
│   │   └── README.md               # Project-specific notes
│   └── another-project/            # Example project 2
│       ├── index.html
│       ├── app.js
│       └── app.wasm
└── projects.md                     # Projects listing page
```

---

## Adding a New WASM Project

### Step 1: Create Project Directory

```bash
cd /home/nds/Projects/nikkibest.github.io
mkdir -p projects/your-project-name
```

### Step 2: Compile Your C++ Code

Use Emscripten to compile your C++ game/application:

```bash
# Navigate to your C++ project source
cd /path/to/your/cpp/project

# Compile with Emscripten
emcc main.cpp -o output.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  -O3 \
  -s ALLOW_MEMORY_GROWTH=1
```

This generates:
- `output.js` - JavaScript glue code
- `output.wasm` - WebAssembly binary

**Important**: The name you use in `-o output.js` determines all output filenames. Use a descriptive name like `game.js`, `physics-sim.js`, etc.

### Step 3: Copy Files to Project Directory

```bash
# Copy generated files to Jekyll project
cp output.js /home/nds/Projects/nikkibest.github.io/projects/your-project-name/
cp output.wasm /home/nds/Projects/nikkibest.github.io/projects/your-project-name/

# If you used --preload-file, also copy the .data file
cp output.data /home/nds/Projects/nikkibest.github.io/projects/your-project-name/
```

### Step 4: Create Project Page

Create `projects/your-project-name/index.html`:

```html
---
layout: wasm-project
title: "Your Project Name"
canvas_width: 800
canvas_height: 600
show_controls: true
technologies:
  - "C++"
  - "Emscripten"
  - "WebAssembly"
  - "SDL2"
github_url: "https://github.com/nikkibest/your-project-repo"
wasm_js_file: "/projects/your-project-name/output.js"
---

## About This Project

[Describe what your project does, why you built it, and what makes it interesting]

## How to Use

- **Controls**: [Describe how to interact with your project]
- **Features**: [List key features]

## Technical Details

[Explain the technical implementation, algorithms used, challenges overcome, etc.]

### Build Information

Compiled with the following Emscripten flags:

```bash
emcc main.cpp -o output.js -s WASM=1 -s USE_SDL=2 -O3
```

## Performance

- **Target FPS**: 60
- **WASM Size**: X KB
- **Load Time**: ~X seconds
```

### Step 5: Add Thumbnail to Projects Page

Edit `projects.md` and add a new project card:

```html
<div class="project-card">
  <a href="/projects/your-project-name/" class="project-link">
    <div class="project-thumbnail">
      <img src="/assets/images/your-project-thumb.png" alt="Your Project">
      <div class="project-overlay">
        <span class="play-icon">▶ Play Demo</span>
      </div>
    </div>
    <div class="project-details">
      <h3>Your Project Name</h3>
      <p class="project-tech">C++ • WebAssembly • SDL2</p>
      <p class="project-description">
        Brief description of your project.
      </p>
    </div>
  </a>
</div>
```

---

## Customizing the Project Page

### Front Matter Options

The YAML front matter in your project's `index.html` controls various aspects:

```yaml
---
layout: wasm-project              # Required: Use the WASM layout
title: "Project Title"            # Required: Page title
canvas_width: 800                 # Optional: Canvas width (default: 800)
canvas_height: 600                # Optional: Canvas height (default: 600)
show_controls: true               # Optional: Show controls panel (default: false)
technologies:                     # Optional: List of technologies
  - "C++17"
  - "OpenGL"
  - "Emscripten"
github_url: "https://github..."   # Optional: Link to source code
download_url: "/path/to/zip"      # Optional: Download link
wasm_js_file: "/projects/.../app.js"  # Required: Path to JS file
---
```

### Canvas Size Considerations

- **Desktop games**: 800x600, 1024x768
- **Mobile-friendly**: 640x480 or responsive (adjust in CSS)
- **Portrait mode**: 480x640
- **Widescreen**: 1280x720

The canvas automatically scales to fit smaller screens via CSS.

### Adding Custom Controls

If you set `show_controls: true`, you can inject custom UI controls:

```javascript
// In your C++ code, export a function to JavaScript
EM_JS(void, setupControls, (), {
  var controlsDiv = document.getElementById('game-controls');
  controlsDiv.innerHTML = `
    <button onclick="resetGame()">Reset</button>
    <button onclick="pauseGame()">Pause</button>
  `;
});
```

---

## Adding Project Thumbnails

### Creating Thumbnails

1. **Take a screenshot** of your game/app running
2. **Resize to 400x300** (or maintain 4:3 aspect ratio)
3. **Optimize the image** (use PNG or JPG, keep under 100KB)
4. **Save to** `/assets/images/your-project-thumb.png`

### Screenshot Methods

**Option 1: From Browser**
```bash
# Run your project locally
bundle exec jekyll serve

# Navigate to http://localhost:4000/projects/your-project-name/
# Take screenshot using browser DevTools or screenshot tool
```

**Option 2: Using ImageMagick**
```bash
# Resize existing screenshot
convert screenshot.png -resize 400x300^ -gravity center -extent 400x300 thumbnail.png

# Optimize
optipng thumbnail.png
```

**Option 3: Placeholder**

The project card includes a fallback SVG placeholder if the image is missing, so you can add the thumbnail later.

---

## Emscripten Compilation Guide

### Basic Compilation

```bash
emcc main.cpp -o game.js -s WASM=1
```

### With SDL2 (for games)

```bash
emcc game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  -O3
```

### With Preloaded Assets

```bash
emcc game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  --preload-file assets \
  -O3
```

This creates `game.data` containing packed assets.

### Production Build (Optimized)

```bash
emcc game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  -O3 \
  -s ASSERTIONS=0 \
  -s ELIMINATE_DUPLICATE_FUNCTIONS=1 \
  --closure 1
```

### Debug Build

```bash
emcc game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  -g \
  -s ASSERTIONS=1 \
  -s SAFE_HEAP=1
```

### Common Emscripten Flags

| Flag | Description |
|------|-------------|
| `-s WASM=1` | Enable WebAssembly output |
| `-s USE_SDL=2` | Link SDL2 library |
| `-O3` | Maximum optimization |
| `-g` | Include debug symbols |
| `-s ALLOW_MEMORY_GROWTH=1` | Allow memory to grow dynamically |
| `-s INITIAL_MEMORY=XXX` | Set initial memory (in bytes) |
| `--preload-file DIR` | Pack directory into .data file |
| `-s ASSERTIONS=0` | Disable runtime assertions (smaller size) |
| `--closure 1` | Use Closure Compiler for minification |

---

## Troubleshooting

### Issue: Canvas Not Displaying

**Symptoms**: Black screen, no canvas visible

**Solutions**:
1. Check browser console for errors
2. Verify `wasm_js_file` path in front matter matches actual file
3. Ensure `.wasm` file exists alongside `.js` file
4. Check that files were committed to Git

```bash
# Verify files exist
ls -lh projects/your-project-name/
```

### Issue: WASM Loading Stuck at 0%

**Symptoms**: Progress bar stays at 0%, infinite loading

**Solutions**:
1. Check Network tab in DevTools for 404 errors
2. Verify file paths are correct (should start with `/`)
3. Ensure files are in the `_site` directory after build

```bash
# Build and check _site
bundle exec jekyll build
ls -lh _site/projects/your-project-name/
```

### Issue: Memory Errors

**Symptoms**: RuntimeError: memory access out of bounds

**Solutions**:
1. Add `-s ALLOW_MEMORY_GROWTH=1` to emcc command
2. Increase initial memory: `-s INITIAL_MEMORY=67108864` (64MB)
3. Check for memory leaks in C++ code

### Issue: File Size Too Large

**Symptoms**: GitHub rejects push, slow loading

**Solutions**:
1. Optimize build with `-O3` and `--closure 1`
2. Remove debug symbols (don't use `-g` flag)
3. Use Git LFS for files over 10MB:

```bash
git lfs track "*.wasm"
git lfs track "*.data"
git add .gitattributes
git commit -m "Track WASM files with LFS"
```

### Issue: Crashes on Mobile

**Symptoms**: Works on desktop, crashes on mobile browsers

**Solutions**:
1. Reduce canvas size for mobile
2. Limit memory usage
3. Test with reduced quality settings
4. Add mobile-specific code paths:

```cpp
#ifdef __EMSCRIPTEN__
  #include <emscripten.h>
  bool isMobile = EM_ASM_INT({
    return /iPhone|iPad|Android/i.test(navigator.userAgent);
  });
#endif
```

---

## Best Practices

### Performance

1. **Optimize build size**
   - Use `-O3` for production
   - Strip debug symbols
   - Enable closure compiler

2. **Lazy load assets**
   - Don't preload everything upfront
   - Load assets on-demand when possible

3. **Target 60 FPS**
   - Use browser DevTools to profile
   - Optimize hot paths in C++ code
   - Consider using WebAssembly SIMD

### User Experience

1. **Show loading progress**
   - The loader already handles this automatically
   - Provide estimated load time in description

2. **Add clear controls documentation**
   - List all keyboard/mouse inputs
   - Show on-screen instructions if applicable

3. **Graceful error handling**
   - Check WebAssembly support
   - Provide fallback message for unsupported browsers

4. **Mobile considerations**
   - Test on mobile devices
   - Add touch controls if applicable
   - Consider orientation (portrait/landscape)

### Code Organization

1. **One project per directory**
   - Keep each WASM project isolated
   - Don't share .wasm files between projects

2. **Use descriptive filenames**
   - `physics-sim.js` better than `output.js`
   - Helps with debugging and organization

3. **Document build process**
   - Add README.md to each project directory
   - Include exact emcc command used
   - Note any special dependencies

### Git Management

1. **Commit WASM files**
   - Binary files are OK for small projects (<10MB)
   - Use Git LFS for larger files

2. **Ignore build artifacts**
   - Add to `.gitignore`: `*.o`, `*.a`, build directories
   - Keep only final `.js`, `.wasm`, `.data` files

3. **Version your builds**
   - Tag releases in Git
   - Update project page when rebuilding

---

## Example: Complete Workflow

Here's a complete example of adding a new physics simulation project:

```bash
# 1. Setup
cd /home/nds/Projects/nikkibest.github.io
mkdir -p projects/physics-sim

# 2. Compile C++ code (from your source directory)
cd /path/to/physics-sim-source
emcc physics.cpp -o physics.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  --preload-file assets \
  -O3 \
  -s ALLOW_MEMORY_GROWTH=1

# 3. Copy to Jekyll project
cp physics.js physics.wasm physics.data \
   /home/nds/Projects/nikkibest.github.io/projects/physics-sim/

# 4. Create project page
cat > /home/nds/Projects/nikkibest.github.io/projects/physics-sim/index.html << 'EOF'
---
layout: wasm-project
title: "Physics Simulation"
canvas_width: 1024
canvas_height: 768
technologies:
  - "C++17"
  - "SDL2"
  - "WebAssembly"
github_url: "https://github.com/nikkibest/physics-sim"
wasm_js_file: "/projects/physics-sim/physics.js"
---

## Real-Time Physics Engine

A 2D rigid body physics simulation with collision detection and resolution.

[... rest of content ...]
EOF

# 5. Add thumbnail
# (Create/copy thumbnail image)
cp screenshot.png /home/nds/Projects/nikkibest.github.io/assets/images/physics-thumb.png

# 6. Update projects.md
# (Edit to add new project card - see template above)

# 7. Test locally
cd /home/nds/Projects/nikkibest.github.io
bundle exec jekyll serve
# Visit http://localhost:4000/projects/physics-sim/

# 8. Commit and push
git add projects/physics-sim/ assets/images/physics-thumb.png projects.md
git commit -m "Add physics simulation WebAssembly project"
git push origin main
```

---

## Advanced Topics

### Custom Layouts

You can create specialized layouts by extending `wasm-project.html`:

```html
<!-- _layouts/3d-demo.html -->
---
layout: wasm-project
---

<!-- Add WebGL-specific controls or info -->
<div class="webgl-info">
  <p>Requires WebGL 2.0 support</p>
</div>

{{ content }}
```

### Multiple Canvas Elements

If your project needs multiple canvases, modify the layout:

```html
---
layout: wasm-project
---

<canvas id="main-canvas" width="800" height="600"></canvas>
<canvas id="ui-canvas" width="800" height="100"></canvas>
```

Update your Emscripten code to target the correct canvas.

### Analytics Integration

Track demo interactions by adding analytics to your project pages:

```html
<script>
  // Track when WASM loads successfully
  Module.onRuntimeInitialized = function() {
    gtag('event', 'wasm_loaded', {'project': '{{ page.title }}'});
  };
</script>
```

---

## Resources

### Documentation
- [Emscripten Documentation](https://emscripten.org/docs/)
- [WebAssembly Specification](https://webassembly.github.io/spec/)
- [Jekyll Documentation](https://jekyllrb.com/docs/)

### Tools
- [Emscripten Compiler](https://emscripten.org/docs/getting_started/downloads.html)
- [WebAssembly Studio](https://webassembly.studio/) - Online WASM IDE
- [wasm-opt](https://github.com/WebAssembly/binaryen) - WASM optimizer

### Community
- [r/WebAssembly](https://reddit.com/r/WebAssembly)
- [Emscripten GitHub](https://github.com/emscripten-core/emscripten)
- [WebAssembly Discord](https://discord.gg/webassembly)

---

## Getting Help

If you encounter issues not covered in this guide:

1. **Check browser console** for error messages
2. **Review Emscripten docs** for compilation flags
3. **Test with minimal example** to isolate the issue
4. **Search GitHub Issues** for similar problems
5. **Ask on Stack Overflow** with tags: `webassembly`, `emscripten`, `jekyll`

---

**Last Updated**: 2025-12-29
**Maintained By**: Nikkibest
