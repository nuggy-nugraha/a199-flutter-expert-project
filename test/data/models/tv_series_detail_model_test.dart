import 'dart:convert';

import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tTVSeriesDetailResponse = TVSeriesDetailResponse(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-03-19',
    genres: [GenreModel(id: 10765, name: 'Sci-Fi & Fantasy')],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    numberOfEpisodes: 6,
    numberOfSeasons: 1,
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview: 'Overview of the series.',
    popularity: 78.978,
    posterPath: '/poster.jpg',
    seasons: [
      SeasonModel(
        airDate: '2021-03-19',
        episodeCount: 6,
        id: 134006,
        name: 'Season 1',
        overview: 'Season overview.',
        posterPath: '/s_poster.jpg',
        seasonNumber: 1,
      ),
    ],
    status: 'Ended',
    tagline: 'The legacy of that shield is complicated.',
    type: 'Miniseries',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/tv_series_detail.json'),
      );
      final result = TVSeriesDetailResponse.fromJson(jsonMap);
      expect(result, isA<TVSeriesDetailResponse>());
      expect(result.id, isNotNull);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () {
      final result = tTVSeriesDetailResponse.toJson();
      expect(result['id'], 88396);
      expect(result['name'], 'The Falcon and the Winter Soldier');
      expect(result['backdrop_path'], '/path.jpg');
      expect(result['poster_path'], '/poster.jpg');
      expect(result['status'], 'Ended');
      expect(result['tagline'], 'The legacy of that shield is complicated.');
      expect(result['type'], 'Miniseries');
    });
  });

  group('toEntity', () {
    test('should return a TVSeriesDetail entity with correct properties', () {
      final result = tTVSeriesDetailResponse.toEntity();
      expect(result, isA<TVSeriesDetail>());
      expect(result.id, 88396);
      expect(result.name, 'The Falcon and the Winter Soldier');
      expect(result.genres, [const Genre(id: 10765, name: 'Sci-Fi & Fantasy')]);
      expect(result.seasons.first, isA<Season>());
    });
  });

  group('props', () {
    test('should return correct props list', () {
      final props = tTVSeriesDetailResponse.props;
      expect(props.length, greaterThan(0));
    });
  });
}
