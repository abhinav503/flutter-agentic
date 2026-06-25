import 'package:core/core/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/app_entity.dart';
import '../../domain/usecase/list_apps_usecase.dart';
import '../../domain/usecase/run_app_usecase.dart';
import '../../domain/usecase/stop_app_usecase.dart';

/// The app list, the selected preview target, and each app's run status. Read
/// by the left-pane selector and the right-pane preview.
class AppsState {
  final List<AppEntity> apps;
  final AppEntity? selected;

  const AppsState({this.apps = const [], this.selected});

  AppsState copyWith({List<AppEntity>? apps, AppEntity? selected}) =>
      AppsState(apps: apps ?? this.apps, selected: selected ?? this.selected);
}

class AppsCubit extends Cubit<AppsState> {
  final ListAppsUseCase _listApps;
  final RunAppUseCase _runApp;
  final StopAppUseCase _stopApp;

  // Bumped on every run/stop so a stale readiness poll cancels itself.
  int _gen = 0;

  AppsCubit({
    required ListAppsUseCase listAppsUseCase,
    required RunAppUseCase runAppUseCase,
    required StopAppUseCase stopAppUseCase,
  })  : _listApps = listAppsUseCase,
        _runApp = runAppUseCase,
        _stopApp = stopAppUseCase,
        super(const AppsState());

  // On failure leaves the list empty — the preview falls back to its default
  // URL and the selector hides itself.
  Future<void> load() async {
    final result = await _listApps(const NoParams());
    result.fold((_) => emit(const AppsState()), _emitApps);
  }

  void select(AppEntity app) => emit(state.copyWith(selected: app));

  // Select it (so the preview follows), then poll until its dev server serves.
  Future<void> run(AppEntity app) async {
    final gen = ++_gen;
    emit(state.copyWith(selected: app));
    final result = await _runApp(app.name);
    result.fold((_) {}, (started) {
      _replace(started);
      _pollUntilSettled(app.name, gen);
    });
  }

  Future<void> stop(AppEntity app) async {
    _gen++; // cancel any in-flight readiness poll
    final result = await _stopApp(app.name);
    result.fold((_) {}, _replace);
  }

  // Re-fetches the list every 2s until the named app leaves `starting`
  // (becomes running, or stops because the build failed), then stops polling.
  Future<void> _pollUntilSettled(String name, int gen) async {
    for (var i = 0; i < 90; i++) {
      await Future.delayed(const Duration(seconds: 2));
      if (isClosed || gen != _gen) return;
      final result = await _listApps(const NoParams());
      final apps = result.fold<List<AppEntity>?>((_) => null, (r) => r);
      if (apps == null) continue;
      _emitApps(apps);
      final me = _byName(apps, name);
      if (me == null || me.status != AppRunStatus.starting) return;
    }
  }

  // Emit a fresh list while keeping the current selection (by name).
  void _emitApps(List<AppEntity> apps) {
    final name = state.selected?.name;
    final selected = apps.isEmpty ? null : (_byName(apps, name) ?? apps.first);
    emit(AppsState(apps: apps, selected: selected));
  }

  // Replace one app in the list (and the selection if it's that app).
  void _replace(AppEntity updated) {
    final apps = [
      for (final a in state.apps) a.name == updated.name ? updated : a,
    ];
    final selected =
        state.selected?.name == updated.name ? updated : state.selected;
    emit(AppsState(apps: apps, selected: selected));
  }

  static AppEntity? _byName(List<AppEntity> apps, String? name) {
    for (final a in apps) {
      if (a.name == name) return a;
    }
    return null;
  }
}
