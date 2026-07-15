import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:core/core/theme/app_spacing.dart';

import 'package:gravia/constants/text_style_const.dart';
import 'package:gravia/constants/value_const.dart';

/// "Key Information" section: bold heading + a description that truncates
/// to [maxLines] with an inline "Read More"/"Read Less" toggle appended
/// directly to the last visible line (not a separate button below the
/// text). [TextOverflow.ellipsis] alone can't guarantee that — it may clip
/// the toggle along with the rest of the overflow — so this measures the
/// laid-out text with a [TextPainter] to find the exact substring that fits
/// alongside the toggle before rendering it.
class ProductDetailKeyInfo extends StatefulWidget {
  final String description;
  final int maxLines;

  const ProductDetailKeyInfo({
    super.key,
    required this.description,
    this.maxLines = 3,
  });

  @override
  State<ProductDetailKeyInfo> createState() => _ProductDetailKeyInfoState();
}

class _ProductDetailKeyInfoState extends State<ProductDetailKeyInfo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final bodyStyle = TextStyleConst.textMdRegular(tt).copyWith(color: cs.onSurface);
    final toggleStyle = TextStyleConst.textMdRegular(tt).copyWith(color: cs.primary);
    final toggleRecognizer = TapGestureRecognizer()
      ..onTap = () => setState(() => _expanded = !_expanded);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ValueConst.keyInformationTitle,
          style: TextStyleConst.textLgBold(tt).copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (_expanded)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: widget.description, style: bodyStyle),
                TextSpan(
                  text: ' ${ValueConst.readLess}',
                  style: toggleStyle,
                  recognizer: toggleRecognizer,
                ),
              ],
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) => Text.rich(
              _truncatedSpan(
                maxWidth: constraints.maxWidth,
                bodyStyle: bodyStyle,
                toggleStyle: toggleStyle,
                toggleRecognizer: toggleRecognizer,
              ),
              maxLines: widget.maxLines,
              overflow: TextOverflow.clip,
            ),
          ),
      ],
    );
  }

  /// Finds the longest prefix of [widget.description] (by word) that, once
  /// followed by "… Read More", still fits within [widget.maxLines] at
  /// [maxWidth] — then builds the two-span (body + toggle) result.
  TextSpan _truncatedSpan({
    required double maxWidth,
    required TextStyle bodyStyle,
    required TextStyle toggleStyle,
    required TapGestureRecognizer toggleRecognizer,
  }) {
    final toggleSpan = TextSpan(
      text: '… ${ValueConst.readMore}',
      style: toggleStyle,
      recognizer: toggleRecognizer,
    );

    bool fits(String text) {
      final painter = TextPainter(
        text: TextSpan(
          children: [TextSpan(text: text, style: bodyStyle), toggleSpan],
        ),
        maxLines: widget.maxLines,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: maxWidth);
      return !painter.didExceedMaxLines;
    }

    // Full text (no toggle needed) fits within maxLines on its own.
    final fullPainter = TextPainter(
      text: TextSpan(text: widget.description, style: bodyStyle),
      maxLines: widget.maxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);
    if (!fullPainter.didExceedMaxLines) {
      return TextSpan(text: widget.description, style: bodyStyle);
    }

    final words = widget.description.split(' ');
    var lo = 0;
    var hi = words.length;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (fits(words.sublist(0, mid).join(' '))) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }

    return TextSpan(
      children: [
        TextSpan(text: words.sublist(0, lo).join(' '), style: bodyStyle),
        toggleSpan,
      ],
    );
  }
}
