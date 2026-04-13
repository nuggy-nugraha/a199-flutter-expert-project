import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const apiKey = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const baseUrl = 'https://api.themoviedb.org/3';

  late TVSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Series', () {
    final tvSeriesList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/now_playing_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of TVSeriesModel when response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/now_playing_tv_series.json'),
            200,
          ),
        );

        final result = await dataSource.getNowPlayingTVSeries();

        expect(result, equals(tvSeriesList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getNowPlayingTVSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tvSeriesList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/popular_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of TVSeriesModel when response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/popular_tv_series.json'), 200),
        );

        final result = await dataSource.getPopularTVSeries();

        expect(result, equals(tvSeriesList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularTVSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tvSeriesList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv_series.json')),
    ).tvSeriesList;

    test(
      'should return list of TVSeriesModel when response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/top_rated_tv_series.json'),
            200,
          ),
        );

        final result = await dataSource.getTopRatedTVSeries();

        expect(result, equals(tvSeriesList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTopRatedTVSeries();

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Detail', () {
    const id = 88396;
    final tvSeriesDetail = TVSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series_detail.json')),
    );

    test('should return tv series detail when response code is 200', () async {
      when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$id?$apiKey'))).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/tv_series_detail.json'), 200),
      );

      final result = await dataSource.getTVSeriesDetail(id);

      expect(result, equals(tvSeriesDetail));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$baseUrl/tv/$id?$apiKey')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTVSeriesDetail(id);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get TV Series Recommendations', () {
    final tvSeriesList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/now_playing_tv_series.json')),
    ).tvSeriesList;
    const id = 88396;

    test(
      'should return list of TVSeriesModel when response code is 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/now_playing_tv_series.json'),
            200,
          ),
        );

        final result = await dataSource.getTVSeriesRecommendations(id);

        expect(result, equals(tvSeriesList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getTVSeriesRecommendations(id);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search TV Series', () {
    final tvSeriesList = TVSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv_series.json')),
    ).tvSeriesList;
    const query = 'falcon';

    test(
      'should return list of TVSeriesModel when response code is 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/search_tv_series.json'), 200),
        );

        final result = await dataSource.searchTVSeries(query);

        expect(result, equals(tvSeriesList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(
          Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
        ),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.searchTVSeries(query);

      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
