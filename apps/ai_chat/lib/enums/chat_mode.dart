/// How the assistant reply is delivered.
///
/// - [streaming]: tokens arrive one-by-one over SSE (`"stream": true`) and the
///   bubble fills in live.
/// - [oneShot]: a single complete response (`"stream": false`) shown at once.
///
/// Both hit the same Groq endpoint; the user picks the mode in the app.
enum ChatMode { streaming, oneShot }
