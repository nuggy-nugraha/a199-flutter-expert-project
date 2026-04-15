import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetSeasonDetail,
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchlistTVSeriesStatus,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TVSeriesDetailNotifier provider;
  late MockGetSeasonDetail mockGetSeasonDetail;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchlistTVSeriesStatus mockGetWatchlistTVSeriesStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlistTVSeries;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlistTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSeasonDetail = MockGetSeasonDetail();
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistTVSeriesStatus = MockGetWatchlistTVSeriesStatus();
    mockSaveWatchlistTVSeries = MockSaveWatchlistTVSeries();
    mockRemoveWatchlistTVSeries = MockRemoveWatchlistTVSeries();
    provider =
        TVSeriesDetailNotifier(
          getSeasonDetail: mockGetSeasonDetail,
          getTVSeriesDetail: mockGetTVSeriesDetail,
          getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
          getWatchlistTVSeriesStatus: mockGetWatchlistTVSeriesStatus,
          saveWatchlistTVSeries: mockSaveWatchlistTVSeries,
          removeWatchlistTVSeries: mockRemoveWatchlistTVSeries,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

  const tId = 88396;

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

  void arrangeUsecase() {
    when(
      mockGetTVSeriesDetail.execute(tId),
    ).thenAnswer((_) async => const Right(testTVSeriesDetail));
    when(
      mockGetTVSeriesRecommendations.execute(tId),
    ).thenAnswer((_) async => Right(tTVSeriesList));
    when(
      mockGetSeasonDetail.execute(tId, 1),
    ).thenAnswer((_) async => const Right(<Episode>[]));
  }

  group('Get TV Series Detail', () {
    test('should get data from the usecase', () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      arrangeUsecase();
      provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv series when data is gotten successfully', () async {
      arrangeUsecase();
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.loaded);
      expect(provider.tvSeries, testTVSeriesDetail);
      expect(listenerCallCount, 4);
    });

    test(
      'should change recommendations when data is gotten successfully',
      () async {
        arrangeUsecase();
        await provider.fetchTVSeriesDetail(tId);
        expect(provider.tvSeriesState, RequestState.loaded);
        expect(provider.tvSeriesRecommendations, tTVSeriesList);
      },
    );
  });

  group('Get TV Series Recommendations', () {
    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        arrangeUsecase();
        await provider.fetchTVSeriesDetail(tId);
        expect(provider.recommendationState, RequestState.loaded);
        expect(provider.tvSeriesRecommendations, tTVSeriesList);
      },
    );

    test('should update error message when request in successful', () async {
      when(
        mockGetTVSeriesDetail.execute(tId),
      ).thenAnswer((_) async => const Right(testTVSeriesDetail));
      when(
        mockGetTVSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => const Left(ServerFailure('Failed')));
      when(
        mockGetSeasonDetail.execute(tId, 1),
      ).thenAnswer((_) async => const Right(<Episode>[]));
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(
        mockGetWatchlistTVSeriesStatus.execute(tId),
      ).thenAnswer((_) async => true);
      await provider.loadWatchlistStatus(tId);
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(
        mockSaveWatchlistTVSeries.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Right('Success'));
      when(
        mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
      ).thenAnswer((_) async => true);
      await provider.addWatchlist(testTVSeriesDetail);
      verify(mockSaveWatchlistTVSeries.execute(testTVSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      when(
        mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Right('Removed'));
      when(
        mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
      ).thenAnswer((_) async => false);
      await provider.removeFromWatchlist(testTVSeriesDetail);
      verify(mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      when(
        mockSaveWatchlistTVSeries.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Right('Added to Watchlist'));
      when(
        mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
      ).thenAnswer((_) async => true);
      await provider.addWatchlist(testTVSeriesDetail);
      verify(mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      when(
        mockSaveWatchlistTVSeries.execute(testTVSeriesDetail),
      ).thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(
        mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
      ).thenAnswer((_) async => false);
      await provider.addWatchlist(testTVSeriesDetail);
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      when(
        mockGetTVSeriesDetail.execute(tId),
      ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(
        mockGetTVSeriesRecommendations.execute(tId),
      ).thenAnswer((_) async => Right(tTVSeriesList));
      await provider.fetchTVSeriesDetail(tId);
      expect(provider.tvSeriesState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('Season Episodes', () {
    test('should update episode state to loaded on success', () async {
      const tEpisode = Episode(
        airDate: '2021-03-19',
        episodeNumber: 1,
        id: 1,
        name: 'Episode 1',
        overview: 'overview',
        seasonNumber: 1,
        stillPath: '/still.jpg',
        voteAverage: 8.0,
        voteCount: 100,
      );
      when(
        mockGetSeasonDetail.execute(tId, 1),
      ).thenAnswer((_) async => const Right([tEpisode]));

      await provider.fetchSeasonEpisodes(tId, 1);

      expect(provider.episodeState, RequestState.loaded);
      expect(provider.seasonEpisodes, [tEpisode]);
      expect(provider.selectedSeason, 1);
    });

    test('should update episode state to error on failure', () async {
      when(
        mockGetSeasonDetail.execute(tId, 1),
      ).thenAnswer(
        (_) async => const Left(ServerFailure('Season Failure')),
      );

      await provider.fetchSeasonEpisodes(tId, 1);

      expect(provider.episodeState, RequestState.error);
      expect(provider.message, 'Season Failure');
    });

    test('should expose seasonEpisodes, episodeState, selectedSeason getters',
        () {
      expect(provider.seasonEpisodes, []);
      expect(provider.episodeState, RequestState.empty);
      expect(provider.selectedSeason, 1);
    });
  });

  group('Remove Watchlist', () {
    test('should update watchlist message when remove watchlist failed',
        () async {
      when(
        mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail),
      ).thenAnswer(
        (_) async => const Left(DatabaseFailure('Cannot remove data')),
      );
      when(
        mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
      ).thenAnswer((_) async => true);

      await provider.removeFromWatchlist(testTVSeriesDetail);

      expect(provider.watchlistMessage, 'Cannot remove data');
    });
  });
}
