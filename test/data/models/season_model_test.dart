import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2021-03-19',
    episodeCount: 6,
    id: 134006,
    name: 'Season 1',
    overview: 'Season overview.',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  const tSeason = Season(
    airDate: '2021-03-19',
    episodeCount: 6,
    id: 134006,
    name: 'Season 1',
    overview: 'Season overview.',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  final tSeasonMap = {
    'air_date': '2021-03-19',
    'episode_count': 6,
    'id': 134006,
    'name': 'Season 1',
    'overview': 'Season overview.',
    'poster_path': '/poster.jpg',
    'season_number': 1,
  };

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final result = SeasonModel.fromJson(tSeasonMap);
      expect(result, tSeasonModel);
    });

    test(
      'should return null airDate and posterPath when they are null in JSON',
      () {
        final jsonWithNulls = Map<String, dynamic>.from(tSeasonMap)
          ..['air_date'] = null
          ..['poster_path'] = null;
        final result = SeasonModel.fromJson(jsonWithNulls);
        expect(result.airDate, isNull);
        expect(result.posterPath, isNull);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tSeasonModel.toJson();
      expect(result, tSeasonMap);
    });
  });

  group('toEntity', () {
    test('should return a Season entity with correct properties', () {
      final result = tSeasonModel.toEntity();
      expect(result, tSeason);
    });
  });

  group('props', () {
    test('should return correct props list', () {
      expect(tSeasonModel.props, [
        '2021-03-19',
        6,
        134006,
        'Season 1',
        'Season overview.',
        '/poster.jpg',
        1,
      ]);
    });
  });
}
