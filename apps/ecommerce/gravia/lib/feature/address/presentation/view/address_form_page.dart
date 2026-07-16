import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../domain/entities/address_entity.dart';
import 'address_form_screen.dart';

class AddressFormPage extends BasePage {
  /// Null → Add New Address; non-null → Edit Address, prefilled from it.
  final AddressEntity? address;

  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends BasePageState<AddressFormPage> {
  // No AppBar/DI/BLoC needed: the screen renders its own coloured hero
  // header (per the pack's "coloured header canvas" composition, same as
  // AddressPage) and the form is pure screen-local UI state — there's
  // nothing here for a BlocProvider to own.
  @override
  Widget buildBody(BuildContext context) =>
      AddressFormScreen(address: widget.address);
}
