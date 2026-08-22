import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'profile_bloc.dart';

/// The canonical [ProfileBloc] construction + started dispatch, shared by
/// every template's shell (or Profile tab) so the wiring can't drift per
/// pack.
///
/// Dispatched unconditionally, guest or not: [ProfileBloc] answers a
/// signed-out caller with `signedOut` without touching the network, so the
/// decision lives in one place rather than at every provider.
BlocProvider<ProfileBloc> profileBlocProvider({required Widget child}) =>
    BlocProvider(
      create: (_) =>
          ProfileBloc(getProfileUseCase: sl(), authSession: sl())
            ..add(const ProfileEvent.started()),
      child: child,
    );
