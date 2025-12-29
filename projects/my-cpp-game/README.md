# My C++ Game - WebAssembly Files

## Directory Structure

Place your compiled Emscripten output files in this directory:

```
projects/my-cpp-game/
├── index.html          # Game page (already created)
├── game.js             # Emscripten JavaScript glue code (place here)
├── game.wasm           # Compiled WebAssembly binary (place here)
├── game.data           # Preloaded assets (if using --preload-file)
└── README.md           # This file
```

## How to Add Your WASM Files

### Step 1: Compile Your C++ Game

Use Emscripten to compile your C++ code:

```bash
# Basic compilation
emcc your_game.cpp -o game.js -s WASM=1

# With SDL2 (for games)
emcc your_game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  -O3 \
  -s ALLOW_MEMORY_GROWTH=1

# With preloaded assets
emcc your_game.cpp -o game.js \
  -s WASM=1 \
  -s USE_SDL=2 \
  --preload-file assets \
  -O3
```

This will generate:
- `game.js` - JavaScript glue code
- `game.wasm` - WebAssembly binary
- `game.data` - Packed assets (if using --preload-file)

### Step 2: Copy Files to This Directory

Copy the generated files to this directory:

```bash
cp game.js /home/nds/Projects/nikkibest.github.io/projects/my-cpp-game/
cp game.wasm /home/nds/Projects/nikkibest.github.io/projects/my-cpp-game/
cp game.data /home/nds/Projects/nikkibest.github.io/projects/my-cpp-game/  # if applicable
```

### Step 3: Update index.html Front Matter

Make sure the `wasm_js_file` in `index.html` points to your JavaScript file:

```yaml
---
layout: wasm-project
title: "My C++ Game"
wasm_js_file: "/projects/my-cpp-game/game.js"  # Update this path
canvas_width: 800  # Adjust to your game's resolution
canvas_height: 600
---
```

### Step 4: Test Locally

```bash
cd /home/nds/Projects/nikkibest.github.io
bundle exec jekyll serve
```

Visit: http://localhost:4000/projects/my-cpp-game/

### Step 5: Commit and Push

```bash
git add projects/my-cpp-game/
git commit -m "Add C++ game WebAssembly build"
git push
```

## File Size Considerations

GitHub recommends keeping repository files under 100 MB. For large WASM files:

1. **Optimize your build** - Use `-O3` flag and size optimization:
   ```bash
   emcc game.cpp -o game.js -O3 -s ASSERTIONS=0 --closure 1
   ```

2. **Use Git LFS** - For files over 10 MB:
   ```bash
   git lfs track "*.wasm"
   git lfs track "*.data"
   git add .gitattributes
   ```

3. **Consider external hosting** - For very large games, host WASM files on CDN

## Emscripten Output Naming

The JavaScript file specified in `-o game.js` determines all output names:
- `-o game.js` creates: `game.js`, `game.wasm`, `game.data`
- `-o myapp.js` creates: `myapp.js`, `myapp.wasm`, `myapp.data`

Make sure your `wasm_js_file` front matter matches your output name.

## Troubleshooting

### Canvas Not Showing
- Check browser console for errors
- Verify WASM files are in the correct directory
- Ensure `wasm_js_file` path is correct in front matter

### Loading Stuck at 0%
- Check that `.wasm` file exists alongside `.js` file
- Verify file permissions (should be readable)
- Check browser console for 404 errors

### Memory Errors
- Add `-s ALLOW_MEMORY_GROWTH=1` to your emcc command
- Increase initial memory: `-s INITIAL_MEMORY=33554432` (32MB)

### Performance Issues
- Compile with optimizations: `-O3`
- Use `-s ASSERTIONS=0` for production builds
- Profile with browser DevTools

## Example Emscripten Command Reference

```bash
# Minimal game
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -O3

# Game with assets
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 --preload-file assets -O3

# Production build (optimized for size)
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -O3 -s ASSERTIONS=0 --closure 1

# Debug build
emcc game.cpp -o game.js -s WASM=1 -s USE_SDL=2 -g -s ASSERTIONS=1
```

## Next Steps

1. Replace placeholder content in `index.html` with your game details
2. Add a thumbnail image to `/assets/images/` for the projects page
3. Update the projects page to link to your game
4. Add game screenshots to the documentation
