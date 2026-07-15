import 'package:flutter/material.dart';

enum AppCheckboxShape { circle, square }

class AppCheckbox extends StatelessWidget {
  final bool value;
  final double size;
  final AppCheckboxShape shape;

  /// Checked state shows a check glyph by default. Set false for a plain
  /// filled dot — e.g. a radio row, where the fill alone communicates
  /// selection (same reasoning as `AppChip.showCheckIcon`).
  final bool showCheckIcon;

  const AppCheckbox({
    super.key,
    required this.value,
    this.size = 22,
    this.shape = AppCheckboxShape.circle,
    this.showCheckIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape == AppCheckboxShape.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        borderRadius: shape == AppCheckboxShape.square
            ? BorderRadius.circular(4)
            : null,
        color: value ? cs.primary : Colors.transparent,
        border: Border.all(
          color: value ? cs.primary : cs.outline,
          width: 2,
        ),
      ),
      child: value && showCheckIcon
          ? Icon(Icons.check, size: size * 0.64, color: cs.onPrimary)
          : null,
    );
  }
}
