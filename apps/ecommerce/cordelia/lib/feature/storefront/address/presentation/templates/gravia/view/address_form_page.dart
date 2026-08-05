import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../../../../geo/presentation/bloc/address_lookup_bloc_provider.dart';
import '../../../../domain/entities/address_entity.dart';
import 'address_form_screen.dart';

class AddressFormPage extends BasePage {
  /// Null → Add New Address; non-null → Edit Address, prefilled from it.
  final AddressEntity? address;

  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends BasePageState<AddressFormPage> {
  // No AppBar: the screen renders its own coloured hero header (per the
  // pack's "coloured header canvas" composition, same as AddressPage). The
  // form fields stay screen-local UI state; only the geo lookups ("use my
  // location", address search, pincode autofill) run through a BLoC —
  // screen-scoped here in buildBody, not buildBlocProviders, since nothing
  // above the body reads it.
  @override
  Widget buildBody(BuildContext context) => addressLookupBlocProvider(
    child: AddressFormScreen(address: widget.address),
  );
}
