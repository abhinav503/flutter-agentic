import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'profile_bloc.dart';

/// The canonical [ProfileBloc] construction + started dispatch, shared by
/// every template's shell (or Profile tab) so the wiring can't drift per
/// pack.
BlocProvider<ProfileBloc> profileBlocProvider({required Widget child}) =>
    BlocProvider(
      create: (_) =>
          ProfileBloc(getProfileUseCase: sl())
            ..add(const ProfileEvent.started()),
      child: child,
    );
