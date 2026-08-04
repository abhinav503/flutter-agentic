import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'edit_profile_bloc.dart';

/// The canonical [EditProfileBloc] construction, shared by every template's
/// Edit Profile page so the wiring can't drift per pack. No started dispatch:
/// the screen's fields are local UI state and only the save submit goes
/// through the bloc.
BlocProvider<EditProfileBloc> editProfileBlocProvider({
  required Widget child,
}) => BlocProvider(
  create: (_) => EditProfileBloc(updateProfileUseCase: sl()),
  child: child,
);
