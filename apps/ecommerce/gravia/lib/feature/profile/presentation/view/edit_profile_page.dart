import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../domain/entities/profile_entity.dart';
import 'edit_profile_screen.dart';

class EditProfilePage extends BasePage {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends BasePageState<EditProfilePage> {
  // No AppBar/DI/BLoC needed: the screen renders its own coloured hero
  // header (per the pack's "coloured header canvas" composition, same as
  // AddressFormPage) and the form is pure screen-local UI state.
  @override
  Widget buildBody(BuildContext context) =>
      EditProfileScreen(profile: widget.profile);
}
