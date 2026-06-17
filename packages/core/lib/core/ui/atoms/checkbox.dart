import 'package:flutter/material.dart';

enum AppCheckboxShape { circle, square }

class AppCheckbox extends StatelessWidget {
  final bool value;
  final double size;
  final AppCheckboxShape shape;

  const AppCheckbox({
    super.key,
    required this.value,
    this.size = 22,
    this.shape = AppCheckboxShape.circle,
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
      child: value
          ? Icon(Icons.check, size: size * 0.64, color: cs.onPrimary)
          : null,
    );
  }
}
