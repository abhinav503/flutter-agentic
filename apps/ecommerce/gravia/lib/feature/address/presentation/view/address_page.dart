import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:gravia/di/injection_container.dart';

import '../bloc/address_bloc.dart';
import 'address_screen.dart';

/// `SharedPreferenceService` key for the id of the address the user last
/// confirmed on this screen — read back by [AddressBloc] to pre-select the
/// same address next time, and by `HomeHeroHeader` (via
/// [kSelectedAddressLabelPrefKey]) to know whether any address has ever been
/// picked at all.
const kSelectedAddressIdPrefKey = 'selected_address_id';

/// The confirmed address's display line, persisted alongside its id so Home
/// can show it without re-fetching the address list.
const kSelectedAddressLabelPrefKey = 'selected_address_label';

class AddressPage extends BasePage {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends BasePageState<AddressPage> {
  // No AppBar: the screen renders its own coloured hero header (back +
  // centered title), per the pack's "coloured header canvas" composition —
  // same reasoning as Product Details/Category Details.
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
        create: (_) => AddressBloc(getAddressesUseCase: sl())
          ..add(const AddressEvent.started()),
        child: const AddressScreen(),
      );
}
