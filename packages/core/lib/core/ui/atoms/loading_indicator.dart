import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.size, this.strokeWidth});

  /// When set, renders as a fixed-size square without a [Center] wrapper.
  /// Leave null for the default full-area centred indicator.
  final double? size;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(strokeWidth: strokeWidth);
    if (size != null) return SizedBox.square(dimension: size, child: indicator);
    return Center(child: indicator);
  }
}
