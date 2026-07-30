import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:core/core/base/base_page.dart';

import 'package:cordelia/di/injection_container.dart';

import '../../../../domain/entities/profile_entity.dart';
import '../../../bloc/edit_profile_bloc.dart';
import 'edit_profile_screen.dart';

class EditProfilePage extends BasePage {
  final ProfileEntity profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends BasePageState<EditProfilePage> {
  /// No app bar anywhere in this pack — the screen renders its own header
  /// row as the first item of its scroll view (spec sheet §8).
  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Color? backgroundColor(BuildContext context) =>
      Theme.of(context).colorScheme.surface;

  /// The avatar picker and typed field values stay screen-local UI state —
  /// only the Save Changes submit goes through [EditProfileBloc], which owns
  /// the real network call (Firebase Auth + Firestore).
  @override
  Widget buildBody(BuildContext context) => BlocProvider(
    create: (_) => EditProfileBloc(updateProfileUseCase: sl()),
    child: EditProfileScreen(profile: widget.profile),
  );
}
