import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cordelia/di/injection_container.dart';

import 'change_password_bloc.dart';

/// The canonical [ChangePasswordBloc] construction, shared by every
/// template's Change Password page so the wiring can't drift per pack. No
/// started dispatch: the bloc only acts on the form's submit.
BlocProvider<ChangePasswordBloc> changePasswordBlocProvider({
  required Widget child,
}) => BlocProvider(
  create: (_) => ChangePasswordBloc(changePasswordUseCase: sl()),
  child: child,
);
