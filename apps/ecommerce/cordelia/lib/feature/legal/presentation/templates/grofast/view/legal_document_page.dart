import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../../view/legal_document_content.dart';
import 'legal_document_screen.dart';

class LegalDocumentPage extends BasePage {
  final LegalDocumentContent content;

  const LegalDocumentPage({super.key, required this.content});

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends BasePageState<LegalDocumentPage> {
  /// No app bar anywhere in this pack — the screen renders its own header row
  /// as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) =>
      LegalDocumentScreen(content: widget.content);
}
