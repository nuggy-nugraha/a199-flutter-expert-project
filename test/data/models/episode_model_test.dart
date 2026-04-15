import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEpisodeModel = EpisodeModel(
    airDate: '2021-03-19',
    episodeNumber: 1,
    id: 1234567,
    name: 'New World Order',
    overview: 'Sam and Bucky navigate their time as the new Captain America.',
    stillPath: '/still_path.jpg',
    voteAverage: 7.5,
    voteCount: 100,
    seasonNumber: 1,
  );

  const tEpisodeModelJson = {
    'air_date': '2021-03-19',
    'episode_number': 1,
    'id': 1234567,
    'name': 'New World Order',
    'overview': 'Sam and Bucky navigate their time as the new Captain America.',
    'still_path': '/still_path.jpg',
    'vote_average': 7.5,
    'vote_count': 100,
    'season_number': 1,
  };

  group('EpisodeModel', () {
    test('fromJson should return a valid model', () {
      final result = EpisodeModel.fromJson(tEpisodeModelJson);
      expect(result, tEpisodeModel);
    });

    test('toJson should return a proper map', () {
      final result = tEpisodeModel.toJson();
      expect(result, tEpisodeModelJson);
    });

    test('toEntity should return Episode entity', () {
      const expectedEpisode = Episode(
        airDate: '2021-03-19',
        episodeNumber: 1,
        id: 1234567,
        name: 'New World Order',
        overview:
            'Sam and Bucky navigate their time as the new Captain America.',
        stillPath: '/still_path.jpg',
        voteAverage: 7.5,
        voteCount: 100,
        seasonNumber: 1,
      );
      final result = tEpisodeModel.toEntity();
      expect(result, expectedEpisode);
    });

    test('props should contain all fields', () {
      expect(tEpisodeModel.props, [
        '2021-03-19',
        1,
        1234567,
        'New World Order',
        'Sam and Bucky navigate their time as the new Captain America.',
        '/still_path.jpg',
        7.5,
        100,
        1,
      ]);
    });

    test('should support null airDate and stillPath', () {
      const episodeWithNulls = EpisodeModel(
        airDate: null,
        episodeNumber: 1,
        id: 1234567,
        name: 'New World Order',
        overview: 'Overview.',
        stillPath: null,
        voteAverage: 7.5,
        voteCount: 100,
        seasonNumber: 1,
      );
      final result = EpisodeModel.fromJson({
        'air_date': null,
        'episode_number': 1,
        'id': 1234567,
        'name': 'New World Order',
        'overview': 'Overview.',
        'still_path': null,
        'vote_average': 7.5,
        'vote_count': 100,
        'season_number': 1,
      });
      expect(result, episodeWithNulls);
    });
  });
}
