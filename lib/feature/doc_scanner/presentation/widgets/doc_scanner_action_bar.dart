import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/button.dart';
import '../../../../core/ui/atoms/loading_indicator.dart';

class DocScannerActionBar extends StatelessWidget {
  final bool isGenerating;
  final bool canGenerate;
  final bool canShowLedger;
  final VoidCallback onCamera;
  final VoidCallback onGallery;
  final VoidCallback onGeneratePdf;
  final VoidCallback onShowLedger;

  const DocScannerActionBar({
    super.key,
    required this.isGenerating,
    required this.canGenerate,
    required this.canShowLedger,
    required this.onCamera,
    required this.onGallery,
    required this.onGeneratePdf,
    required this.onShowLedger,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.base,
        bottom: AppSpacing.base + bottomInset,
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: ValueConst.docScannerPickCamera,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              leadingIcon: const Icon(Icons.camera_alt_outlined, size: 16),
              state: isGenerating ? AppButtonState.disabled : AppButtonState.idle,
              onTap: onCamera,
            ),
            const SizedBox(width: AppSpacing.xs),
            AppButton(
              label: ValueConst.docScannerPickGallery,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              leadingIcon: const Icon(Icons.photo_library_outlined, size: 16),
              state: isGenerating ? AppButtonState.disabled : AppButtonState.idle,
              onTap: onGallery,
            ),
            const SizedBox(width: AppSpacing.xs),
            AppButton(
              label: ValueConst.docScannerLedger,
              variant: AppButtonVariant.secondary,
              size: AppButtonSize.small,
              state: canShowLedger ? AppButtonState.idle : AppButtonState.disabled,
              onTap: onShowLedger,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: isGenerating
                  ? const Center(child: LoadingIndicator(size: 24))
                  : AppButton(
                      label: ValueConst.docScannerGeneratePdf,
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.small,
                      fullWidth: true,
                      state: canGenerate ? AppButtonState.idle : AppButtonState.disabled,
                      onTap: onGeneratePdf,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
