import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:core/core/services/shared_pref_service/shared_preference_service.dart';
import 'package:fpdart/fpdart.dart';

import 'package:ai_chat/constants/value_const.dart';
import 'package:ai_chat/enums/chat_mode.dart';
import '../../domain/repository/chat_repository.dart';
import '../data_source/chat_remote_data_source.dart';

class ChatRepositoryImpl with BaseRepository implements ChatRepository {
  final ChatRemoteDataSource _dataSource;
  const ChatRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, String>> sendMessage(String prompt, ChatMode mode) {
    // Pull the saved key here and pass it down; the dispatcher routes to Groq
    // when it's set, the mock otherwise. handleStream maps deltas to
    // right(delta) and any error to a typed Failure — no exception escapes.
    final apiKey = SharedPreferenceService.instance
            .getString(ValueConst.groqApiKeyStorageKey) ??
        '';
    return handleStream(
      () => _dataSource.sendMessage(prompt: prompt, mode: mode, apiKey: apiKey),
    );
  }

  @override
  Future<String> getApiKey() async =>
      SharedPreferenceService.instance
          .getString(ValueConst.groqApiKeyStorageKey) ??
      '';

  @override
  Future<void> saveApiKey(String apiKey) {
    final trimmed = apiKey.trim();
    if (trimmed.isEmpty) {
      return SharedPreferenceService.instance
          .remove(ValueConst.groqApiKeyStorageKey);
    }
    return SharedPreferenceService.instance
        .setString(ValueConst.groqApiKeyStorageKey, trimmed);
  }
}
