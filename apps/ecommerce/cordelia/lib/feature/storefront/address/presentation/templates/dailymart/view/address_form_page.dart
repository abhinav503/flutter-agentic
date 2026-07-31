import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

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
  /// No app bar anywhere in this pack — the screen renders its own header
  /// row as the first item of its scroll view (spec sheet §8). No DI or
  /// BlocProvider either: the form is pure screen-local UI state until Save,
  /// which pops the result to Select Address.
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  @override
  Widget buildBody(BuildContext context) =>
      AddressFormScreen(address: widget.address);
}
