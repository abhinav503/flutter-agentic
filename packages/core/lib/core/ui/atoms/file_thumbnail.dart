import 'dart:io';

import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';

class AppFileThumbnail extends StatelessWidget {
  final String path;
  final double width;
  final double height;

  const AppFileThumbnail({
    super.key,
    required this.path,
    this.width = 72,
    this.height = 88,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: AppRadius.md,
      child: SizedBox(
        width: width,
        height: height,
        child: Image.file(
          File(path),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => ColoredBox(
            color: cs.surfaceContainerHighest,
            child: Icon(
              Icons.broken_image_outlined,
              color: cs.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
