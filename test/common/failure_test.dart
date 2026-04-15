import 'package:ditonton/common/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServerFailure', () {
    test('props should contain message', () {
      const failure = ServerFailure('Server error');
      expect(failure.props, ['Server error']);
    });

    test('should be equal when messages are the same', () {
      const f1 = ServerFailure('error');
      const f2 = ServerFailure('error');
      expect(f1, equals(f2));
    });
  });

  group('ConnectionFailure', () {
    test('props should contain message', () {
      const failure = ConnectionFailure('No connection');
      expect(failure.props, ['No connection']);
    });

    test('should be equal when messages are the same', () {
      const f1 = ConnectionFailure('No connection');
      const f2 = ConnectionFailure('No connection');
      expect(f1, equals(f2));
    });
  });

  group('DatabaseFailure', () {
    test('props should contain message', () {
      const failure = DatabaseFailure('DB error');
      expect(failure.props, ['DB error']);
    });

    test('should be equal when messages are the same', () {
      const f1 = DatabaseFailure('DB error');
      const f2 = DatabaseFailure('DB error');
      expect(f1, equals(f2));
    });
  });
}
