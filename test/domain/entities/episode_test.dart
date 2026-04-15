import 'package:ditonton/domain/entities/episode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tEpisode = Episode(
    airDate: '2021-03-19',
    episodeNumber: 1,
    id: 1234567,
    name: 'New World Order',
    overview: 'Sam and Bucky must navigate their time as the new Captain America.',
    stillPath: '/still_path.jpg',
    voteAverage: 7.5,
    voteCount: 100,
    seasonNumber: 1,
  );

  group('Episode entity', () {
    test('props should contain all fields', () {
      expect(tEpisode.props, [
        '2021-03-19',
        1,
        1234567,
        'New World Order',
        'Sam and Bucky must navigate their time as the new Captain America.',
        '/still_path.jpg',
        7.5,
        100,
        1,
      ]);
    });

    test('should be equal when all props are equal', () {
      const anotherEpisode = Episode(
        airDate: '2021-03-19',
        episodeNumber: 1,
        id: 1234567,
        name: 'New World Order',
        overview:
            'Sam and Bucky must navigate their time as the new Captain America.',
        stillPath: '/still_path.jpg',
        voteAverage: 7.5,
        voteCount: 100,
        seasonNumber: 1,
      );
      expect(tEpisode, equals(anotherEpisode));
    });

    test('should support null airDate and stillPath', () {
      const episodeWithNulls = Episode(
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
      expect(episodeWithNulls.props.contains(null), isTrue);
    });
  });
}
