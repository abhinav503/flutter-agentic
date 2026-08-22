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

class _AddressFormPageState extends BasePageState<AddressFormPage>
    with ChromelessPage {
  @override
  Widget buildBody(BuildContext context) =>
      AddressFormScreen(address: widget.address);
}
