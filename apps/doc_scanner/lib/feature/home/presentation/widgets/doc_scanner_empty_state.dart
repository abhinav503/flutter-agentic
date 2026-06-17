import 'package:flutter/material.dart';

import 'package:doc_scanner/constants/value_const.dart';
import 'package:core/core/ui/atoms/button.dart';
import 'package:core/core/ui/molecules/empty_state.dart';

class DocScannerEmptyState extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const DocScannerEmptyState({
    super.key,
    required this.onCamera,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      iconData: Icons.receipt_long_outlined,
      title: ValueConst.docScannerEmptyTitle,
      subtitle: ValueConst.docScannerEmptySubtitle,
      actions: [
        AppButton(
          label: ValueConst.docScannerPickCamera,
          variant: AppButtonVariant.secondary,
          leadingIcon: const Icon(Icons.camera_alt_outlined, size: 18),
          onTap: onCamera,
        ),
        AppButton(
          label: ValueConst.docScannerPickGallery,
          variant: AppButtonVariant.secondary,
          leadingIcon: const Icon(Icons.photo_library_outlined, size: 18),
          onTap: onGallery,
        ),
      ],
    );
  }
}
