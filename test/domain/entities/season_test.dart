import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tSeason = Season(
    airDate: '2021-03-19',
    episodeCount: 6,
    id: 134006,
    name: 'Season 1',
    overview: 'Overview of season 1.',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
  );

  const tSeasonNullFields = Season(
    airDate: null,
    episodeCount: 6,
    id: 134006,
    name: 'Season 1',
    overview: 'Overview.',
    posterPath: null,
    seasonNumber: 1,
  );

  group('Season entity', () {
    test('should support value equality', () {
      const tSeason2 = Season(
        airDate: '2021-03-19',
        episodeCount: 6,
        id: 134006,
        name: 'Season 1',
        overview: 'Overview of season 1.',
        posterPath: '/poster.jpg',
        seasonNumber: 1,
      );
      expect(tSeason, tSeason2);
    });

    test('should return correct props', () {
      expect(tSeason.props, [
        '2021-03-19',
        6,
        134006,
        'Season 1',
        'Overview of season 1.',
        '/poster.jpg',
        1,
      ]);
    });

    test('should handle null fields correctly', () {
      expect(tSeasonNullFields.airDate, isNull);
      expect(tSeasonNullFields.posterPath, isNull);
    });
  });
}
