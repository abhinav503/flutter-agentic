import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../view/legal_document_content.dart';
import 'legal_document_screen.dart';

class LegalDocumentPage extends BasePage {
  final LegalDocumentContent content;

  const LegalDocumentPage({super.key, required this.content});

  @override
  State<LegalDocumentPage> createState() => _LegalDocumentPageState();
}

class _LegalDocumentPageState extends BasePageState<LegalDocumentPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) =>
      LegalDocumentScreen(content: widget.content);
}
