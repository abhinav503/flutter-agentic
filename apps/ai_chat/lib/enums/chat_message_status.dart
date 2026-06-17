/// Lifecycle of a single message.
///
/// A user message is always [done]. An assistant message starts [streaming]
/// while tokens arrive, becomes [done] when the stream completes, or [error]
/// if the stream fails mid-response.
enum ChatMessageStatus { streaming, done, error }
