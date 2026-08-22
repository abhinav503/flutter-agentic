/// Why a shopper is reporting someone else's review.
///
/// A fixed list, not free text: the store owner groups complaints by it in
/// the console, and a free-form field on a "report abuse" flow is somewhere
/// to write abuse.
enum ReviewReportReason { offensive, spam, irrelevant, personalInfo }

extension ReviewReportReasonX on ReviewReportReason {
  /// Wire value, matching the backend's `REVIEW_REPORT_REASONS`
  /// (`admin/src/lib/types.ts`). Spelled out rather than `.name` so a Dart
  /// rename can't silently change what the API is sent.
  String get wireValue => switch (this) {
    ReviewReportReason.offensive => 'offensive',
    ReviewReportReason.spam => 'spam',
    ReviewReportReason.irrelevant => 'irrelevant',
    ReviewReportReason.personalInfo => 'personalInfo',
  };
}
