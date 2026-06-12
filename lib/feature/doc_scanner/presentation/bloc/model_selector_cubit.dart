import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/ai_scan_model.dart';
import '../../domain/usecase/get_api_keys_usecase.dart';
import '../../domain/usecase/get_selected_model_usecase.dart';
import '../../domain/usecase/save_api_key_usecase.dart';
import '../../domain/usecase/select_model_usecase.dart';

class ModelSelectorState {
  final AiScanModel selectedModel;
  final Map<String, String> apiKeys;

  const ModelSelectorState({
    required this.selectedModel,
    this.apiKeys = const {},
  });

  ModelSelectorState copyWith({
    AiScanModel? selectedModel,
    Map<String, String>? apiKeys,
  }) =>
      ModelSelectorState(
        selectedModel: selectedModel ?? this.selectedModel,
        apiKeys: apiKeys ?? this.apiKeys,
      );

  String? apiKeyFor(AiScanModel model) => apiKeys[model.id];
}

class ModelSelectorCubit extends Cubit<ModelSelectorState> {
  final GetSelectedModelUseCase _getSelectedModel;
  final SelectModelUseCase _selectModel;
  final GetApiKeysUseCase _getApiKeys;
  final SaveApiKeyUseCase _saveApiKey;

  ModelSelectorCubit({
    required GetSelectedModelUseCase getSelectedModelUseCase,
    required SelectModelUseCase selectModelUseCase,
    required GetApiKeysUseCase getApiKeysUseCase,
    required SaveApiKeyUseCase saveApiKeyUseCase,
  })  : _getSelectedModel = getSelectedModelUseCase,
        _selectModel = selectModelUseCase,
        _getApiKeys = getApiKeysUseCase,
        _saveApiKey = saveApiKeyUseCase,
        super(ModelSelectorState(selectedModel: AiScanModel.defaultModel)) {
    _init();
  }

  Future<void> _init() async {
    final model = await _getSelectedModel(const NoParams());
    final apiKeys = await _getApiKeys(const NoParams());
    emit(ModelSelectorState(selectedModel: model, apiKeys: apiKeys));
  }

  Future<void> select(AiScanModel model) async {
    await _selectModel(SelectModelParams(model: model));
    emit(state.copyWith(selectedModel: model));
  }

  Future<void> setApiKey(AiScanModel model, String apiKey) async {
    await _saveApiKey(SaveApiKeyParams(model: model, apiKey: apiKey));
    final trimmed = apiKey.trim();
    if (trimmed.isEmpty) {
      emit(state.copyWith(
        apiKeys: Map.from(state.apiKeys)..remove(model.id),
      ));
    } else {
      emit(state.copyWith(
        apiKeys: Map.from(state.apiKeys)..[model.id] = trimmed,
      ));
    }
  }
}
