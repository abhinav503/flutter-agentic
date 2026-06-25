import 'package:core/core/base/base_repository.dart';
import 'package:core/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/entities/terminal_output_entity.dart';
import '../../domain/repository/terminal_repository.dart';
import '../data_source/terminal_remote_data_source.dart';

class TerminalRepositoryImpl with BaseRepository implements TerminalRepository {
  final TerminalRemoteDataSource _dataSource;
  const TerminalRepositoryImpl(this._dataSource);

  @override
  Stream<Either<Failure, TerminalOutputEntity>> connect() => handleStream(
      () => _dataSource.connect().map((model) => model.toEntity()));

  @override
  void sendInput(String data) => _dataSource.sendInput(data);

  @override
  void resize(int cols, int rows) => _dataSource.resize(cols, rows);

  @override
  Future<void> disconnect() => _dataSource.disconnect();
}
