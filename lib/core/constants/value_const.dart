abstract final class ValueConst {
  // ── App ───────────────────────────────────────────────────────────────────
  static const appTitle = 'FlutterAgentic';

  // ── Jokes feature ─────────────────────────────────────────────────────────
  static const jokeAppBarTitle   = 'Dad Jokes';
  static const jokeFabTooltip    = 'Random joke';
  static const jokeSheetTitle    = 'Dad Joke';
  static const jokeCardBadge     = 'Dad Joke';
  static const jokeEmptyTitle    = 'Ready for a laugh?';
  static const jokeEmptySubtitle = 'Search above or tap below for a random joke.';
  static const jokeEmptyButton   = 'Get a Random Joke';
  static const jokeSearchHint    = 'Search jokes...';
  static const jokeLoadMore      = 'Load More';

  static String jokeResultsCount(int count) => '$count jokes found';

  static const List<String> jokeQuickFilters = [
    'cat', 'dog', 'math', 'music', 'computer',
  ];

  // ── For You tab ───────────────────────────────────────────────────────────
  static const jokeForYouTabTitle  = 'For You';
  static const jokeSearchTabTitle  = 'Search';
  static const jokeTapForMore      = 'Tap for more';
  static const jokeSheetKeepButton = 'Keep this one';
  static const jokeSearchEmptyHint = 'Search for a joke above';

  // ── Shared UI ─────────────────────────────────────────────────────────────
  static const retryButton = 'Retry';

  // ── Image picker ─────────────────────────────────────────────────────────
  static const imagePickerQuality  = 90;
  static const imagePickerMaxWidth  = 1600;
  static const imagePickerMaxHeight = 2000;

  // ── Doc Scanner feature ───────────────────────────────────────────────────
  static const docScannerAppBarTitle   = 'Scan Receipts';
  static const docScannerPickCamera    = 'Camera';
  static const docScannerPickGallery   = 'Gallery';
  static const docScannerGeneratePdf   = 'Generate PDF';
  static const docScannerTotalLabel    = 'Total';
  static const docScannerEmptyTitle    = 'No receipts yet';
  static const docScannerEmptySubtitle = 'Add images from camera or gallery to get started.';
  static const docScannerExtracting    = 'Extracting…';
  static const docScannerPdfSuccess    = 'PDF ready — opening share sheet';
  static const docScannerPdfError      = 'Failed to generate PDF';
  static const docScannerExtractFailed   = 'Could not read receipt';
  static const docScannerDateIncomplete  = 'Date on receipt is incomplete — year, month and day must all be visible';
  static const docScannerExtractButton  = 'Extract Data';
  static const docScannerStatusPending    = 'Pending';
  static const docScannerStatusReading    = 'Reading…';
  static const docScannerStatusDone       = 'Done';
  static const docScannerStatusFailed     = 'Failed';
  static const docScannerLedger        = 'Ledger';
  static const docScannerLedgerTitle   = 'Receipt Ledger';
  static const docScannerLedgerEmpty   = 'No extracted receipts selected';
  static const docScannerLedgerColName   = 'Name';
  static const docScannerLedgerColDate   = 'Date';
  static const docScannerLedgerColAmount = 'Amount';
  static String docScannerLedgerTotal(String currency) =>
      currency.isEmpty ? docScannerTotalLabel : '$docScannerTotalLabel ($currency)';

  static String docScannerReceiptCount(int count) =>
      '$count receipt${count == 1 ? '' : 's'}';

  static String docScannerDuplicatesSkipped(int count) =>
      '$count duplicate image${count == 1 ? '' : 's'} skipped';

  static const docScannerEditTitle           = 'Edit Receipt';
  static const docScannerEditNameLabel       = 'Store / Restaurant';
  static const docScannerEditNameHint        = 'e.g. Starbucks';
  static const docScannerEditAmountLabel     = 'Total amount';
  static const docScannerEditAmountHint      = 'e.g. 12.50';
  static const docScannerEditDateLabel       = 'Date';
  static const docScannerEditDatePlaceholder = 'Tap to pick a date';
  static const docScannerEditSaved           = 'Receipt updated';
  static const saveButton                    = 'Save';
  static const cancelButton                  = 'Cancel';

  static const docScannerModelSelectorTitle = 'Choose AI Model';
  static const docScannerModelSelectorTooltip = 'Select AI model';
  static const docScannerApiKeyLabel = 'Add API key';
  static const docScannerApiKeyCopied = 'API key copied';
  static const docScannerApiKeySave = 'Save';
  static const docScannerApiKeyCancel = 'Cancel';
  static const docScannerApiKeyDialogHint = 'Paste your API key here';

  // ── AI scan models ────────────────────────────────────────────────────────────
  static const aiModelGroqId          = 'groq-llama-4-scout';
  static const aiModelGroqName        = 'Llama 4 Scout 17B';
  static const aiModelGroqSubtitle    = 'Fast · Free tier · Groq';
  static const aiModelGroqModelId     = 'meta-llama/llama-4-scout-17b-16e-instruct';

  static const aiModelClaudeId        = 'claude-haiku-4-5';
  static const aiModelClaudeName      = 'Claude Haiku 4.5';
  static const aiModelClaudeSubtitle  = 'Paid · Anthropic';
  static const aiModelClaudeModelId   = 'claude-haiku-4-5-20251001';

  static const aiModelGeminiId        = 'gemini-flash';
  static const aiModelGeminiName      = 'Gemini Flash';
  static const aiModelGeminiSubtitle  = '1,500 req/day · Google';
  static const aiModelGeminiModelId   = 'gemini-2.5-flash';

  static const docScannerSelectedModelKey = 'selected_scan_model';
  static const docScannerApiKeyPrefix = 'api_key_';

  static const docScannerReceiptPrompt =
      'Receipt image. Reply ONLY with JSON, no markdown:\n'
      '{"restaurant_name":"<string|null>","date":"<YYYY-MM-DD|null>",'
      '"total_amount":<number|null>,"currency":"<symbol like ₹ or \$ or € or null>"}\n'
      'Return null for any field not clearly visible in the image.';

  static const docScannerReceiptPromptGemini =
      'Extract the following fields from this receipt image: '
      'restaurant or store name, date of the transaction in YYYY-MM-DD format, '
      'total amount as a number without currency symbol, and currency symbol. '
      'Return null for any field that is not clearly visible in the image.';
}
