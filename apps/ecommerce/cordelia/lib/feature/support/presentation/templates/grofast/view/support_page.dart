import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';
import 'package:cordelia/feature/storefront/presentation/chromeless_page.dart';

import '../../../view/support_channels.dart';
import 'support_screen.dart';

class SupportPage extends BasePage {
  final SupportChannels channels;

  const SupportPage({super.key, required this.channels});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends BasePageState<SupportPage>
    with ChromelessStorefrontPage {
  @override
  Widget buildBody(BuildContext context) =>
      SupportScreen(channels: widget.channels);
}
