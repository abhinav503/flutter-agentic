import 'package:flutter/material.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/button.dart';
import '../../../../core/ui/atoms/checkbox.dart';
import '../../../../core/ui/molecules/dialog.dart';
import '../../domain/entities/ai_scan_model.dart';
import 'model_api_key_row.dart';

class ModelTile extends StatelessWidget {
  final AiScanModel model;
  final AiScanModel selected;
  final String? apiKey;
  final VoidCallback onSelect;
  final void Function(String) onApiKeySaved;
  final VoidCallback? onCopyKey;

  const ModelTile({
    super.key,
    required this.model,
    required this.selected,
    required this.apiKey,
    required this.onSelect,
    required this.onApiKeySaved,
    this.onCopyKey,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = model == selected;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: onSelect,
        title: Text(
          model.displayName,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isSelected ? cs.primary : cs.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              model.subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            ModelApiKeyRow(
              apiKey: apiKey,
              onEdit: () => _showApiKeyDialog(context),
              onCopy: onCopyKey,
            ),
          ],
        ),
        isThreeLine: true,
        trailing: AppCheckbox(value: isSelected),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    String value = apiKey ?? '';
    AppDialog.show(
      context,
      title: 'API Key — ${model.displayName}',
      child: TextFormField(
        initialValue: apiKey,
        onChanged: (v) => value = v,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          hintText: ValueConst.docScannerApiKeyDialogHint,
        ),
      ),
      actions: [
        AppButton(
          label: ValueConst.docScannerApiKeyCancel,
          variant: AppButtonVariant.text,
          size: AppButtonSize.small,
          onTap: () => Navigator.pop(context),
        ),
        AppButton(
          label: ValueConst.docScannerApiKeySave,
          variant: AppButtonVariant.text,
          size: AppButtonSize.small,
          onTap: () {
            onApiKeySaved(value);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
