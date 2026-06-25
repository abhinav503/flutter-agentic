// Platform indirection: the `<iframe>` impl on web, a no-op stub elsewhere (the
// app only ships to web; the stub just keeps the workspace compiling).
export 'preview_platform_stub.dart'
    if (dart.library.js_interop) 'preview_platform_web.dart';
