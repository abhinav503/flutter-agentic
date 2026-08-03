import 'package:flutter/material.dart';

import 'package:core/core/ui/blocks/section_header.dart';

import 'package:cordelia/templates/grofast/constants/grofast_text_style_const.dart';

/// GROFAST's section header — core's [SectionHeader] with the pack's 20/700
/// title and its lowercase Montserrat link (spec sheet §13), so no screen
/// re-types the style pair.
class GrofastSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const GrofastSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return SectionHeader(
      title: title,
      actionLabel: actionLabel,
      onAction: onAction,
      titleStyle: GrofastTextStyleConst.sectionBold(
        tt,
      ).copyWith(color: cs.onSurface),
      actionStyle: GrofastTextStyleConst.link(tt).copyWith(color: cs.primary),
    );
  }
}
