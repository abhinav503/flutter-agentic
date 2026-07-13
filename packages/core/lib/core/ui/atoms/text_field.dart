import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_shapes_extension.dart';
import '../../theme/app_spacing.dart';

enum AppTextFieldState { idle, error, disabled }

/// General-purpose text field with label, hint, error message, and focus-aware
/// border. All colours come from [ColorScheme] and all text styles from
/// [TextTheme]. Border radius comes from the theme's [AppShapes] extension.
///
/// ```dart
/// AppTextField(
///   controller: _emailController,
///   label: 'Email',
///   hint: 'you@example.com',
///   state: hasError ? AppTextFieldState.error : AppTextFieldState.idle,
///   errorText: 'Invalid email address',
///   keyboardType: TextInputType.emailAddress,
///   onChanged: (v) => bloc.add(EmailChanged(v)),
/// )
/// ```
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final AppTextFieldState state;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? suffix;

  /// Overrides the theme's default hint colour (`InputDecorationTheme.hintStyle`)
  /// — for a field sitting on a coloured/glass surface instead of the
  /// standard surface background, e.g. `colorScheme.onPrimary`.
  final Color? hintColor;

  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  /// Compact variant: tighter vertical padding + `isDense`, for tight spots
  /// like a chat input bar. Default keeps the standard comfortable height.
  final bool dense;

  /// Set false when this field sits inside something that already paints its
  /// own edge (e.g. [CommonGlassSurface]) — the default idle border would
  /// otherwise stack on top of that edge into one over-thick outline. Focus
  /// and error borders stay on regardless, since those are meaningful state
  /// changes, not a redundant idle-state outline.
  final bool showBorder;

  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.state = AppTextFieldState.idle,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.prefix,
    this.suffix,
    this.hintColor,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.dense = false,
    this.showBorder = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isDisabled = widget.state == AppTextFieldState.disabled;
    final isError = widget.state == AppTextFieldState.error;

    final borderColor = isError
        ? cs.error
        : _isFocused
            ? cs.primary
            : cs.outline;

    final shapes = Theme.of(context).extension<AppShapes>() ?? AppShapes.standard;
    final radius = BorderRadius.circular(shapes.inputRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: tt.labelMedium!.copyWith(
              color: isError ? cs.error : cs.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs3),
        ],
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: !isDisabled,
          // Flutter's default onTapOutside cancels the outside tap without
          // unfocusing — every field in the app should dismiss the keyboard
          // on an outside tap, so this is the default here, not per-caller.
          onTapOutside: (_) => _focusNode.unfocus(),
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: tt.bodyMedium!.copyWith(
            color: isDisabled
                ? cs.onSurface.withValues(alpha: 0.38)
                : cs.onSurface,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
                widget.hintColor != null ? TextStyle(color: widget.hintColor) : null,
            prefixIcon: widget.prefix,
            suffixIcon: widget.suffix,
            // Default prefix/suffix slots are tight at kMinInteractiveDimension
            // (48x48), which clamps a smaller prefix/suffix widget back up to
            // 48x48 regardless of its own declared size. Loosening removes the
            // forced minimum so prefix/suffix render at their natural size,
            // centered by InputDecorator as usual.
            prefixIconConstraints: const BoxConstraints(),
            suffixIconConstraints: const BoxConstraints(),
            isDense: widget.dense,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: widget.dense ? AppSpacing.xs : AppSpacing.sm,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide:
                  widget.showBorder ? BorderSide(color: borderColor) : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: cs.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: cs.error, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide:
                  BorderSide(color: cs.onSurface.withValues(alpha: 0.12)),
            ),
            filled: isDisabled,
            fillColor:
                isDisabled ? cs.onSurface.withValues(alpha: 0.04) : null,
          ),
        ),
        if (isError && widget.errorText != null) ...[
          const SizedBox(height: AppSpacing.xs3),
          Row(
            children: [
              Icon(Icons.error_outline, size: 14, color: cs.error),
              const SizedBox(width: AppSpacing.xs3),
              Text(
                widget.errorText!,
                style: tt.labelSmall!.copyWith(color: cs.error),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
