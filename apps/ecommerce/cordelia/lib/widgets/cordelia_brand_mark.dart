import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';
import 'package:core/core/ui/atoms/svg_image.dart';

import 'package:cordelia/constants/cordelia_dimen_const.dart';
import 'package:cordelia/constants/cordelia_text_style_const.dart';
import 'package:cordelia/constants/image_const.dart';
import 'package:cordelia/constants/value_const.dart';

/// The brand mark on a light disc, optionally followed by the name — the
/// lockup every coloured header opens with (auth, discovery).
///
/// The disc is not decoration: the mark is a fixed green gradient (its own
/// colours, not tintable), and the header canvas it sits on is
/// `colorScheme.primary` — now the same green. `onPrimary` is the disc fill
/// for exactly that reason, so the mark keeps a light backing in whichever
/// theme is active rather than dissolving into the canvas.
///
/// The name is live text, not an asset — the mark has no wordmark SVG
/// on purpose (see [ImageConst.cordeliaBrandIcon]), so it picks up the
/// theme's typeface.
class CordeliaBrandMark extends StatelessWidget {
  /// Renders [ValueConst.appTitle] beside the disc. Off for a standalone
  /// mark, e.g. a header that already carries the screen's own title.
  final bool showName;

  const CordeliaBrandMark({super.key, this.showName = true});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: CordeliaDimenConst.brandMarkDisc,
          height: CordeliaDimenConst.brandMarkDisc,
          decoration: BoxDecoration(
            color: cs.onPrimary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const AppSvgImage.asset(
            ImageConst.cordeliaBrandIcon,
            width: CordeliaDimenConst.brandMarkGlyph,
            height: CordeliaDimenConst.brandMarkGlyph,
          ),
        ),
        if (showName) ...[
          const SizedBox(width: AppSpacing.sm),
          Text(
            ValueConst.appTitle,
            style: CordeliaTextStyleConst.textMdBold(
              tt,
            ).copyWith(color: cs.onPrimary),
          ),
        ],
      ],
    );
  }
}
