import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/value_const.dart';
import '../../domain/entities/ai_scan_model.dart';
import '../bloc/model_selector_cubit.dart';
import 'model_tile.dart';

class ModelSelectorSheetContent extends StatelessWidget {
  const ModelSelectorSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ModelSelectorCubit, ModelSelectorState>(
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.min,
        children: AiScanModel.all
            .map((model) => ModelTile(
                  model: model,
                  selected: state.selectedModel,
                  apiKey: state.apiKeyFor(model),
                  onSelect: () =>
                      context.read<ModelSelectorCubit>().select(model),
                  onApiKeySaved: (key) =>
                      context.read<ModelSelectorCubit>().setApiKey(model, key),
                  onCopyKey: state.apiKeyFor(model) != null
                      ? () async {
                          await Clipboard.setData(
                            ClipboardData(text: state.apiKeyFor(model)!),
                          );
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(ValueConst.docScannerApiKeyCopied),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      : null,
                ))
            .toList(),
      ),
    );
  }
}
