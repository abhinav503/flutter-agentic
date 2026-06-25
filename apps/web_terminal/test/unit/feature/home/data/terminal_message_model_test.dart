import 'package:flutter_test/flutter_test.dart';
import 'package:web_terminal/feature/home/data/models/terminal_message_model.dart';

void main() {
  group('TerminalMessageModel', () {
    test('parses an output frame and maps to an output entity', () {
      final model = TerminalMessageModel.fromJson({
        'type': 'output',
        'data': 'hello\r\n',
      });

      expect(model.isExit, isFalse);

      final entity = model.toEntity();
      expect(entity.data, 'hello\r\n');
      expect(entity.isExit, isFalse);
      expect(entity.exitCode, isNull);
    });

    test('parses an exit frame and maps to an exit entity', () {
      final model = TerminalMessageModel.fromJson({'type': 'exit', 'code': 137});

      expect(model.isExit, isTrue);

      final entity = model.toEntity();
      expect(entity.isExit, isTrue);
      expect(entity.exitCode, 137);
      expect(entity.data, isEmpty);
    });

    test('defaults missing fields safely', () {
      final model = TerminalMessageModel.fromJson(const {});
      expect(model.type, 'output');
      expect(model.data, isEmpty);
      expect(model.toEntity().isExit, isFalse);
    });
  });
}
