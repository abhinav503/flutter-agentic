import 'package:flutter/material.dart';

import 'package:core/core/theme/app_radius.dart';
import 'package:core/core/ui/atoms/network_image.dart';

/// The pack's list-row thumbnail — a square [AppNetworkImage] clipped to
/// [AppRadius.lg]. Cart rows, order line items, and search suggestions all
/// render this instead of re-typing the ClipRRect recipe (three copies had
/// already drifted to different radii before this existed); only [size]
/// varies with the row's density.
class GraviaListThumbnail extends StatelessWidget {
  final String url;
  final double size;

  const GraviaListThumbnail({
    super.key,
    required this.url,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: AppRadius.lg,
    child: AppNetworkImage(url: url, width: size, height: size),
  );
}
