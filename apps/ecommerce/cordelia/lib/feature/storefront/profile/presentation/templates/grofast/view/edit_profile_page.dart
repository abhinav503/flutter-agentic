import 'package:flutter/material.dart';

import 'package:core/core/base/base_page.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc_provider.dart';
import 'edit_profile_screen.dart';

class EditProfilePage extends BasePage {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends BasePageState<EditProfilePage>
    with ChromelessPage {
  /// The avatar picker and typed field values stay screen-local UI state —
  /// only the Save Changes submit goes through [EditProfileBloc], which owns
  /// the real network call.
  @override
  Widget buildBody(BuildContext context) => editProfileBlocProvider(
    child: EditProfileScreen(profile: widget.profile),
  );
}
