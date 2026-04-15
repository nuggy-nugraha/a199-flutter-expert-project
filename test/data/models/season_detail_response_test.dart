import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_detail_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    airDate: '2021-03-19',
    episodeNumber: 1,
    id: 1234567,
    name: 'New World Order',
    overview: 'Overview.',
    stillPath: '/still_path.jpg',
    voteAverage: 7.5,
    voteCount: 100,
    seasonNumber: 1,
  );

  const tSeasonDetailResponse = SeasonDetailResponse(
    id: 134006,
    name: 'Season 1',
    overview: 'Sam and Bucky team up for global adventure.',
    posterPath: '/poster.jpg',
    seasonNumber: 1,
    episodes: [tEpisodeModel],
  );

  final tSeasonDetailJson = {
    'id': 134006,
    'name': 'Season 1',
    'overview': 'Sam and Bucky team up for global adventure.',
    'poster_path': '/poster.jpg',
    'season_number': 1,
    'episodes': [
      {
        'air_date': '2021-03-19',
        'episode_number': 1,
        'id': 1234567,
        'name': 'New World Order',
        'overview': 'Overview.',
        'still_path': '/still_path.jpg',
        'vote_average': 7.5,
        'vote_count': 100,
        'season_number': 1,
      },
    ],
  };

  group('SeasonDetailResponse', () {
    test('fromJson should return a valid model', () {
      final result = SeasonDetailResponse.fromJson(tSeasonDetailJson);
      expect(result, tSeasonDetailResponse);
    });

    test('props should contain all fields', () {
      expect(tSeasonDetailResponse.props, [
        134006,
        'Season 1',
        'Sam and Bucky team up for global adventure.',
        '/poster.jpg',
        1,
        [tEpisodeModel],
      ]);
    });

    test('should support null posterPath', () {
      final json = Map<String, dynamic>.from(tSeasonDetailJson);
      json['poster_path'] = null;
      final result = SeasonDetailResponse.fromJson(json);
      expect(result.posterPath, isNull);
    });
  });
}
