import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:web_terminal/constants/value_const.dart';
import 'package:web_terminal/enums/device_platform.dart';
import 'package:web_terminal/feature/apps/domain/entities/app_entity.dart';
import 'package:web_terminal/feature/apps/domain/usecase/list_apps_usecase.dart';
import 'package:web_terminal/feature/apps/domain/usecase/run_app_usecase.dart';
import 'package:web_terminal/feature/apps/domain/usecase/stop_app_usecase.dart';
import 'package:web_terminal/feature/apps/presentation/cubit/apps_cubit.dart';
import 'package:web_terminal/feature/devices/domain/entities/device_entity.dart';
import 'package:web_terminal/feature/devices/domain/usecase/list_devices_usecase.dart';
import 'package:web_terminal/feature/devices/presentation/cubit/devices_cubit.dart';
import 'package:web_terminal/feature/home/presentation/widgets/terminal_apps_bar.dart';

import '../../../helpers/fake_apps_repository.dart';
import '../../../helpers/fake_devices_repository.dart';

void main() {
  late FakeAppsRepository appsRepo;
  late FakeDevicesRepository devicesRepo;

  const pixelEmulator = DeviceEntity(
    id: 'Pixel_7_Pro_API_35',
    name: 'Pixel 7 Pro API 35',
    platform: DevicePlatform.android,
    kind: DeviceKind.emulator,
    isEmulator: true,
  );

  setUp(() {
    appsRepo = FakeAppsRepository()
      ..apps = const [AppEntity(name: 'jokes', path: '/x', previewPort: 8080)];
    devicesRepo = FakeDevicesRepository()
      ..result = right([DevicesCubit.webPreview, pixelEmulator]);
  });

  Future<void> pumpBar(WidgetTester tester) async {
    final appsCubit = AppsCubit(
      listAppsUseCase: ListAppsUseCase(appsRepo),
      runAppUseCase: RunAppUseCase(appsRepo),
      stopAppUseCase: StopAppUseCase(appsRepo),
    )..load();
    final devicesCubit =
        DevicesCubit(listDevicesUseCase: ListDevicesUseCase(devicesRepo))
          ..load();

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appsCubit),
          BlocProvider.value(value: devicesCubit),
        ],
        child: const MaterialApp(
          home: Scaffold(body: TerminalAppsBar()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the app and the default web-preview target', (tester) async {
    await pumpBar(tester);

    expect(find.text('jokes'), findsOneWidget);
    expect(find.text(ValueConst.appRunLabel), findsOneWidget);
    // Web preview is the default device shown in the trigger.
    expect(find.text(DevicesCubit.webPreview.name), findsWidgets);
  });

  testWidgets('lists an offline emulator with its boot hint', (tester) async {
    await pumpBar(tester);

    // Open the device dropdown via its trigger icon.
    await tester.tap(find.byIcon(Icons.public).first);
    await tester.pumpAndSettle();

    expect(find.text(pixelEmulator.name), findsOneWidget);
    expect(find.text(ValueConst.deviceEmulatorHint), findsOneWidget);
  });

  testWidgets('runs the selected app on the chosen device', (tester) async {
    await pumpBar(tester);

    await tester.tap(find.text(ValueConst.appRunLabel));
    await tester.pump();

    // Defaulted to the web-preview target.
    expect(appsRepo.lastRunDeviceId, DevicesCubit.webPreview.id);
    expect(appsRepo.lastRunKind, DeviceKind.web.name);

    // Drain the cubit's readiness poll so no timer is pending at teardown.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
