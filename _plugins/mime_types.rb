require 'webrick'

# Add WASM MIME type support for Jekyll's local server
WEBrick::HTTPUtils::DefaultMimeTypes['wasm'] = 'application/wasm'
