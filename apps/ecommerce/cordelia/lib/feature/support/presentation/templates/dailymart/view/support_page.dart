import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/feature/support/presentation/support_channels.dart';
import 'support_screen.dart';

class SupportPage extends BasePage {
  final SupportChannels channels;

  const SupportPage({super.key, required this.channels});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends BasePageState<SupportPage> with ChromelessPage {
  @override
  Widget buildBody(BuildContext context) =>
      SupportScreen(channels: widget.channels);
}
