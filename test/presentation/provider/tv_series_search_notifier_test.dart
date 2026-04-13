import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late TVSeriesSearchNotifier provider;
  late MockSearchTVSeries mockSearchTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVSeries = MockSearchTVSeries();
    provider = TVSeriesSearchNotifier(searchTVSeries: mockSearchTVSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  const tTVSeries = TVSeries(
    backdropPath: '/backdropPath',
    firstAirDate: '2021-03-19',
    genreIds: [10765, 10759],
    id: 88396,
    name: 'The Falcon and the Winter Soldier',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'The Falcon and the Winter Soldier',
    overview: 'Following the events of Avengers: Endgame.',
    popularity: 78.978,
    posterPath: '/6kbAMLteGO8yyewYau6bJ683sw7.jpg',
    voteAverage: 7.9,
    voteCount: 5765,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];
  const tQuery = 'falcon';

  group('search tv series', () {
    test('should change state to loading when usecase is called', () async {
      when(
        mockSearchTVSeries.execute(tQuery),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchTVSeriesSearch(tQuery);
      expect(provider.state, RequestState.loading);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        when(
          mockSearchTVSeries.execute(tQuery),
        ).thenAnswer((_) async => Right(tTVSeriesList));
        await provider.fetchTVSeriesSearch(tQuery);
        expect(provider.state, RequestState.loaded);
        expect(provider.searchResult, tTVSeriesList);
        expect(listenerCallCount, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(
        mockSearchTVSeries.execute(tQuery),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchTVSeriesSearch(tQuery);
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
