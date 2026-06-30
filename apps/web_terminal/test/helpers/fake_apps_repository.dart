import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_terminal/feature/apps/domain/entities/app_entity.dart';
import 'package:web_terminal/feature/apps/domain/repository/apps_repository.dart';

/// Manual fake (no mockito/mocktail). [apps] backs listApps; run/stop echo the
/// named app back with the requested status so widget tests can drive the bar.
class FakeAppsRepository implements AppsRepository {
  List<AppEntity> apps = const [];
  String? lastRunDeviceId;
  String? lastRunKind;

  @override
  Future<Either<Failure, List<AppEntity>>> listApps() async => right(apps);

  @override
  Future<Either<Failure, AppEntity>> runApp(
    String name, {
    required String deviceId,
    required String platform,
    required String kind,
  }) async {
    lastRunDeviceId = deviceId;
    lastRunKind = kind;
    return right(_withStatus(name, AppRunStatus.starting));
  }

  @override
  Future<Either<Failure, AppEntity>> stopApp(String name) async =>
      right(_withStatus(name, AppRunStatus.stopped));

  AppEntity _withStatus(String name, AppRunStatus status) {
    final app = apps.firstWhere((a) => a.name == name);
    return AppEntity(
      name: app.name,
      path: app.path,
      previewPort: app.previewPort,
      status: status,
    );
  }
}
