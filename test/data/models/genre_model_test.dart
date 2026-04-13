import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenreModel = GenreModel(id: 28, name: 'Action');
  const tGenre = Genre(id: 28, name: 'Action');
  final tGenreMap = {'id': 28, 'name': 'Action'};

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final result = GenreModel.fromJson(tGenreMap);
      expect(result.id, tGenreModel.id);
      expect(result.name, tGenreModel.name);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tGenreModel.toJson();
      expect(result, tGenreMap);
    });
  });

  group('toEntity', () {
    test('should return a Genre entity with correct properties', () {
      final result = tGenreModel.toEntity();
      expect(result, tGenre);
    });
  });

  group('props', () {
    test('should return correct props list', () {
      expect(tGenreModel.props, [28, 'Action']);
    });
  });
}
