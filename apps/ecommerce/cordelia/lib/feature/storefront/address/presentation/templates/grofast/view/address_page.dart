import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../bloc/address_bloc.dart';
import 'address_screen.dart';

class AddressPage extends BasePage {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends BasePageState<AddressPage> {
  /// No app bar anywhere in this pack — the screen renders its own header row
  /// as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => AddressBloc(
      getAddressesUseCase: sl(),
      createAddressUseCase: sl(),
      updateAddressUseCase: sl(),
      deleteAddressUseCase: sl(),
    )..add(const AddressEvent.started()),
    child: const AddressScreen(),
  );
}
