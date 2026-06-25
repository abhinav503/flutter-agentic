import '../models/terminal_message_model.dart';

abstract interface class TerminalRemoteDataSource {
  Stream<TerminalMessageModel> connect();

  void sendInput(String data);
  void resize(int cols, int rows);
  Future<void> disconnect();
}
