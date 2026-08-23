import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/app_update_requirement_entity.dart';
import '../../domain/usecase/get_update_requirement_usecase.dart';

part 'app_update_bloc.freezed.dart';
part 'app_update_event.dart';
part 'app_update_state.dart';

/// Decides at launch whether this build may go on. Fails open: a config
/// that can't be fetched or parsed lets the shopper in, because a gate that
/// locks everyone out on a network blip is worse than one old build
/// slipping through.
class AppUpdateBloc extends Bloc<AppUpdateEvent, AppUpdateState> {
  final GetUpdateRequirementUseCase _getRequirement;

  AppUpdateBloc({
    required GetUpdateRequirementUseCase getUpdateRequirementUseCase,
  }) : _getRequirement = getUpdateRequirementUseCase,
       super(const AppUpdateState.checking()) {
    on<AppUpdateStarted>(_onStarted);
  }

  Future<void> _onStarted(
    AppUpdateStarted event,
    Emitter<AppUpdateState> emit,
  ) async {
    final result = await _getRequirement(const NoParams());
    result.fold((_) => emit(const AppUpdateState.proceed()), (requirement) {
      if (requirement.requiresUpdate(event.installedVersion)) {
        emit(AppUpdateState.updateRequired(requirement: requirement));
      } else {
        emit(const AppUpdateState.proceed());
      }
    });
  }
}
