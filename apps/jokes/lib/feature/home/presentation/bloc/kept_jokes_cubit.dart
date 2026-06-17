import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/joke_entity.dart';

class KeptJokesCubit extends Cubit<List<JokeEntity>> {
  KeptJokesCubit() : super([]);

  void keep(JokeEntity joke) {
    if (!state.any((j) => j.id == joke.id)) emit([...state, joke]);
  }

  void remove(String id) => emit(state.where((j) => j.id != id).toList());
}
