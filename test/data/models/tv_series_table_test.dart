import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  const tTVSeriesTable = TVSeriesTable(
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    overview:
        'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
  );

  final tTVSeriesTableMap = {
    'id': 88396,
    'name': 'The Falcon and the Winter Soldier',
    'posterPath': '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    'overview':
        'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
  };

  group('fromEntity', () {
    test('should return a TVSeriesTable from TVSeriesDetail entity', () {
      final result = TVSeriesTable.fromEntity(testTVSeriesDetail);
      expect(result.id, testTVSeriesDetail.id);
      expect(result.name, testTVSeriesDetail.name);
      expect(result.posterPath, testTVSeriesDetail.posterPath);
      expect(result.overview, testTVSeriesDetail.overview);
    });
  });

  group('fromMap', () {
    test('should return a valid TVSeriesTable from map', () {
      final result = TVSeriesTable.fromMap(tTVSeriesTableMap);
      expect(result, tTVSeriesTable);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tTVSeriesTable.toJson();
      expect(result, tTVSeriesTableMap);
    });
  });

  group('toEntity', () {
    test('should return a TVSeries (watchlist) entity', () {
      final result = tTVSeriesTable.toEntity();
      expect(result, isA<TVSeries>());
      expect(result.id, 88396);
      expect(result.name, 'The Falcon and the Winter Soldier');
    });
  });

  group('props', () {
    test('should return correct equality based on props', () {
      const tTVSeriesTable2 = TVSeriesTable(
        id: 88396,
        name: 'The Falcon and the Winter Soldier',
        posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
        overview:
            'Following the events of Avengers: Endgame, Sam Wilson/Falcon and Bucky Barnes/Winter Soldier team up in a global adventure.',
      );
      expect(tTVSeriesTable, tTVSeriesTable2);
    });
  });
}
