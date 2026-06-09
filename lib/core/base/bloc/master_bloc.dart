import 'package:flutter_bloc/flutter_bloc.dart';

part 'master_event.dart';
part 'master_state.dart';

/// Page-scoped BLoC for driving a full-screen loader overlay.
///
/// Created by [BasePage] — emit [ShowLoader] / [HideLoader] from any descendant
/// to show or hide a loading state without touching feature BLoC states.
class MasterBloc extends Bloc<MasterEvent, MasterState> {
  MasterBloc() : super(MasterInitial()) {
    on<ShowLoader>((_, emit) => emit(MasterLoading()));
    on<HideLoader>((_, emit) => emit(MasterIdle()));
  }
}
