import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tMovieTable = MovieTable(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  final tMovieTableMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  group('fromEntity', () {
    test('should return a MovieTable from MovieDetail entity', () {
      final result = MovieTable.fromEntity(testMovieDetail);
      expect(result.id, testMovieDetail.id);
      expect(result.title, testMovieDetail.title);
      expect(result.posterPath, testMovieDetail.posterPath);
      expect(result.overview, testMovieDetail.overview);
    });
  });

  group('fromMap', () {
    test('should return a valid MovieTable from map', () {
      final result = MovieTable.fromMap(tMovieTableMap);
      expect(result, tMovieTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tMovieTable.toJson();
      expect(result, tMovieTableMap);
    });
  });

  group('toEntity', () {
    test('should return a Movie (watchlist) entity', () {
      final result = tMovieTable.toEntity();
      expect(result, isA<Movie>());
      expect(result.id, 1);
      expect(result.title, 'title');
    });
  });

  group('props', () {
    test('should return correct equality based on props', () {
      const tMovieTable2 = MovieTable(
        id: 1,
        title: 'title',
        posterPath: 'posterPath',
        overview: 'overview',
      );
      expect(tMovieTable, tMovieTable2);
    });
  });
}
