import 'package:flutter/material.dart';

/// Pill toggle with a thumb that's the *same size* in both states.
///
/// Material's own `Switch` grows the thumb when selected (Material 3 spec:
/// active thumb radius 12, inactive 8) — correct for stock Material, but a
/// style pack whose spec calls for one fixed-size thumb throughout (no
/// growth animation) can't get that from `Switch`'s public API; the
/// active/inactive radii aren't independently overridable. This paints a
/// plain track + thumb instead, so the thumb only ever animates position,
/// never size.
///
/// ```dart
/// AppSwitch(value: isOn, onChanged: (v) => setState(() => isOn = v))
/// ```
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final double width;
  final double height;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.width = 44,
    this.height = 24,
  });

  static const _thumbPadding = 4.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final trackColor = value
        ? (activeTrackColor ?? cs.primary)
        : (inactiveTrackColor ?? cs.surfaceContainerHighest);
    final thumbSize = height - _thumbPadding * 2;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: width,
        height: height,
        padding: const EdgeInsets.all(_thumbPadding),
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: thumbColor ?? Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
