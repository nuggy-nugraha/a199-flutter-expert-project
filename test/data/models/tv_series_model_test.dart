import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  const tTVSeriesModel = TVSeriesModel(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview: 'Overview',
    popularity: 78.978,
    posterPath: '/poster.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  const tTVSeries = TVSeries(
    backdropPath: '/path.jpg',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview: 'Overview',
    popularity: 78.978,
    posterPath: '/poster.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );

  group('TVSeriesModel', () {
    test('should be a subclass of TVSeries entity', () {
      final result = tTVSeriesModel.toEntity();
      expect(result, tTVSeries);
    });

    test('should return correct props', () {
      expect(tTVSeriesModel.props, [
        '/path.jpg',
        '2021-03-19',
        [10765, 10759],
        88396,
        'The Falcon and the Winter Soldier',
        ['US'],
        'en',
        'The Falcon and the Winter Soldier',
        'Overview',
        78.978,
        '/poster.jpg',
        7.9,
        5765,
      ]);
    });
  });

  group('TVSeriesResponse', () {
    test('fromJson should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = json.decode(
        readJson('dummy_data/now_playing_tv_series.json'),
      );
      final result = TVSeriesResponse.fromJson(jsonMap);
      expect(result.tvSeriesList, isA<List<TVSeriesModel>>());
    });

    test('toJson should return a JSON map containing proper data', () {
      const tTVSeriesResponse = TVSeriesResponse(
        tvSeriesList: [tTVSeriesModel],
      );
      final result = tTVSeriesResponse.toJson();
      expect(result['results'], isA<List>());
    });

    test('props should contain tvSeriesList', () {
      const tTVSeriesResponse = TVSeriesResponse(
        tvSeriesList: [tTVSeriesModel],
      );
      expect(tTVSeriesResponse.props, [
        const [tTVSeriesModel],
      ]);
    });

    test('two responses with same list are equal', () {
      const r1 = TVSeriesResponse(tvSeriesList: [tTVSeriesModel]);
      const r2 = TVSeriesResponse(tvSeriesList: [tTVSeriesModel]);
      expect(r1, equals(r2));
    });
  });
}
