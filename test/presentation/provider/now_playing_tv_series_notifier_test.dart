import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tv_series_notifier_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries])
void main() {
  late NowPlayingTVSeriesNotifier notifier;
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    notifier =
        NowPlayingTVSeriesNotifier(
          getNowPlayingTVSeries: mockGetNowPlayingTVSeries,
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
    test('should change state to loading when usecase is called', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      notifier.fetchNowPlayingTVSeries();
      expect(notifier.state, RequestState.loading);
    });

    test('should change data when data is gotten successfully', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      await notifier.fetchNowPlayingTVSeries();
      expect(notifier.state, RequestState.loaded);
      expect(notifier.tvSeries, tTVSeriesList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(
        mockGetNowPlayingTVSeries.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await notifier.fetchNowPlayingTVSeries();
      expect(notifier.state, RequestState.error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
