import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/value_const.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/atoms/button.dart';
import '../../../../core/ui/atoms/text_field.dart';
import '../../domain/entities/scanned_receipt_entity.dart';

class ReceiptEditSheetContent extends StatefulWidget {
  final ScannedReceiptEntity receipt;
  final void Function({
    required String? restaurantName,
    required double? amount,
    required String? date,
  }) onSave;

  const ReceiptEditSheetContent({
    super.key,
    required this.receipt,
    required this.onSave,
  });

  @override
  State<ReceiptEditSheetContent> createState() =>
      _ReceiptEditSheetContentState();
}

class _ReceiptEditSheetContentState extends State<ReceiptEditSheetContent> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.receipt.restaurantName ?? '');
    _amountController = TextEditingController(
      text: widget.receipt.amount?.toStringAsFixed(2) ?? '',
    );
    _selectedDate = widget.receipt.date != null
        ? DateTime.tryParse(widget.receipt.date!)
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xs,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: ValueConst.docScannerEditNameLabel,
            hint: ValueConst.docScannerEditNameHint,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.base),
          AppTextField(
            controller: _amountController,
            label: ValueConst.docScannerEditAmountLabel,
            hint: ValueConst.docScannerEditAmountHint,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
          ),
          const SizedBox(height: AppSpacing.base),
          _DatePickerField(
            selected: _selectedDate,
            onPicked: (date) => setState(() => _selectedDate = date),
          ),
          const SizedBox(height: AppSpacing.xl2),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: ValueConst.cancelButton,
                  variant: AppButtonVariant.secondary,
                  fullWidth: true,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: AppButton(
                  label: ValueConst.saveButton,
                  variant: AppButtonVariant.primary,
                  fullWidth: true,
                  onTap: _onSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final amountRaw = _amountController.text.trim();
    widget.onSave(
      restaurantName: name.isEmpty ? null : name,
      amount: amountRaw.isEmpty ? null : double.tryParse(amountRaw),
      date: _selectedDate?.toIso8601String().substring(0, 10),
    );
    Navigator.pop(context);
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime? selected;
  final ValueChanged<DateTime?> onPicked;

  const _DatePickerField({required this.selected, required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          ValueConst.docScannerEditDateLabel,
          style: tt.labelMedium!.copyWith(color: cs.onSurface),
        ),
        const SizedBox(height: AppSpacing.xs3),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selected ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            onPicked(picked);
          },
          borderRadius: BorderRadius.circular(AppRadius.mdValue),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.mdValue),
              border: Border.all(color: cs.outline),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: cs.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  selected != null
                      ? _format(selected!)
                      : ValueConst.docScannerEditDatePlaceholder,
                  style: tt.bodyMedium!.copyWith(
                    color: selected != null
                        ? cs.onSurface
                        : cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static String _format(DateTime d) =>
      '${d.day} ${ValueConst.docScannerMonthAbbreviations[d.month - 1]} ${d.year}';
}
