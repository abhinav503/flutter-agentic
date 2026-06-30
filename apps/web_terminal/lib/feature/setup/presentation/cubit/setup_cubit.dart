import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/setup_item_entity.dart';
import '../../domain/usecase/get_setup_status_usecase.dart';

/// Drives the topbar Setup button (the missing-count badge) and the right-pane
/// checklist (whether it's open + the detected prerequisites). Page-level so
/// both read the same state.
class SetupState {
  final List<SetupItemEntity> items;
  final bool loading;
  final String? error;
  final bool isOpen;

  /// True once a detection has completed, so reopening the panel doesn't
  /// re-probe every time.
  final bool loaded;

  const SetupState({
    this.items = const [],
    this.loading = false,
    this.error,
    this.isOpen = false,
    this.loaded = false,
  });

  int get missingCount => items.where((i) => !i.installed).length;

  SetupState copyWith({
    List<SetupItemEntity>? items,
    bool? loading,
    String? error,
    bool? isOpen,
    bool? loaded,
  }) =>
      SetupState(
        items: items ?? this.items,
        loading: loading ?? this.loading,
        // Pass `clearError: true`-style by allowing an explicit null reset.
        error: error,
        isOpen: isOpen ?? this.isOpen,
        loaded: loaded ?? this.loaded,
      );
}

class SetupCubit extends Cubit<SetupState> {
  final GetSetupStatusUseCase _getSetupStatus;

  SetupCubit({required GetSetupStatusUseCase getSetupStatusUseCase})
      : _getSetupStatus = getSetupStatusUseCase,
        super(const SetupState());

  // Open lazily probes once; close just hides the panel (keeps results cached).
  void toggle() {
    final opening = !state.isOpen;
    emit(state.copyWith(isOpen: opening));
    if (opening && !state.loaded && !state.loading) load();
  }

  void hide() => emit(state.copyWith(isOpen: false));

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final result = await _getSetupStatus(const NoParams());
    result.fold(
      (failure) =>
          emit(state.copyWith(loading: false, loaded: true, error: failure.message)),
      (items) =>
          emit(state.copyWith(items: items, loading: false, loaded: true)),
    );
  }

  // Re-probe after the user runs an install step, to refresh the ✅/❌ marks.
  Future<void> refresh() => load();
}
