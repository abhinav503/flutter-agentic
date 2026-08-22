import 'package:flutter/material.dart';

import 'package:cordelia/feature/support/presentation/support_channels.dart';

/// The glyph a support row leads with.
///
/// Material icons rather than pack SVGs: no kit ships a support frame, so
/// none of the three bundles a mail, phone or external-link mark. Same call
/// the Language row made on Profile — and made once here, since three packs
/// choosing independently is how the same row ends up looking like three
/// different affordances.
IconData supportChannelGlyph(SupportChannelKind kind) => switch (kind) {
  SupportChannelKind.email => Icons.mail_outline_rounded,
  SupportChannelKind.phone => Icons.call_outlined,
  SupportChannelKind.link => Icons.open_in_new_rounded,
};

/// The leading disc's diameter, and the glyph inside it — matched to
/// [AppMenuTile]'s defaults so a support row sits at the same rhythm as the
/// Profile rows it is reached from.
const double supportGlyphCircleSize = 44;
const double supportGlyphSize = 20;
