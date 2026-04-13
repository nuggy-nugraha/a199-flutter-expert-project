import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_list_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late TVSeriesListNotifier provider;
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    provider =
        TVSeriesListNotifier(
          getNowPlayingTVSeries: mockGetNowPlayingTVSeries,
          getPopularTVSeries: mockGetPopularTVSeries,
          getTopRatedTVSeries: mockGetTopRatedTVSeries,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  const tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    firstAirDate: '2021-03-19',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalLanguage: 'en',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  group('now playing tv series', () {
    test('initialState should be Empty', () {
      expect(provider.nowPlayingState, equals(RequestState.empty));
    });

    test('should get data from the usecase', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchNowPlayingTVSeries();
      verify(mockGetNowPlayingTVSeries.execute());
    });

    test('should change state to Loading when usecase is called', () {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchNowPlayingTVSeries();
      expect(provider.nowPlayingState, RequestState.loading);
    });

    test('should change tv series when data is gotten successfully', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchNowPlayingTVSeries();
      expect(provider.nowPlayingState, RequestState.loaded);
      expect(provider.nowPlayingTVSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchNowPlayingTVSeries();
      expect(provider.nowPlayingState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tv series', () {
    test('should change state to loading when usecase is called', () async {
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.loaded);
      expect(provider.popularTVSeries, tTVSeriesList);
    });

    test('should return error when data is unsuccessful', () async {
      when(
        mockGetPopularTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchPopularTVSeries();
      expect(provider.popularTVSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('top rated tv series', () {
    test('should change state to loading when usecase is called', () async {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.loaded);
      expect(provider.topRatedTVSeries, tTVSeriesList);
    });

    test('should return error when data is unsuccessful', () async {
      when(
        mockGetTopRatedTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchTopRatedTVSeries();
      expect(provider.topRatedTVSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
    });
  });
}
