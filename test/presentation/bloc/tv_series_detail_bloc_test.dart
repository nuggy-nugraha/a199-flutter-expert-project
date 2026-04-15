import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/episode.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchlistTVSeriesStatus,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
  GetSeasonDetail,
])
void main() {
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchlistTVSeriesStatus mockGetWatchlistTVSeriesStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlistTVSeries;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlistTVSeries;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistTVSeriesStatus = MockGetWatchlistTVSeriesStatus();
    mockSaveWatchlistTVSeries = MockSaveWatchlistTVSeries();
    mockRemoveWatchlistTVSeries = MockRemoveWatchlistTVSeries();
    mockGetSeasonDetail = MockGetSeasonDetail();
  });

  TVSeriesDetailBloc makeBloc() => TVSeriesDetailBloc(
    getTVSeriesDetail: mockGetTVSeriesDetail,
    getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
    getWatchlistTVSeriesStatus: mockGetWatchlistTVSeriesStatus,
    saveWatchlistTVSeries: mockSaveWatchlistTVSeries,
    removeWatchlistTVSeries: mockRemoveWatchlistTVSeries,
    getSeasonDetail: mockGetSeasonDetail,
  );

  const tId = 88396;
  const tEpisodes = <Episode>[];

  group('FetchTVSeriesDetail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          mockGetTVSeriesDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testTVSeriesDetail));
        when(
          mockGetTVSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTVSeriesList));
        when(
          mockGetWatchlistTVSeriesStatus.execute(tId),
        ).thenAnswer((_) async => false);
        when(
          mockGetSeasonDetail.execute(tId, 1),
        ).thenAnswer((_) async => const Right(tEpisodes));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailLoading(),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loading,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: tEpisodes,
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loaded,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits [Loading, Error] when fetch detail fails',
      build: () {
        when(
          mockGetTVSeriesDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetTVSeriesRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTVSeriesList));
        when(
          mockGetWatchlistTVSeriesStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailLoading(),
        const TVSeriesDetailError('Server Failure'),
      ],
    );
  });

  group('AddTVSeriesToWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits Loaded with success message when add watchlist succeeds',
      build: () {
        when(
          mockSaveWatchlistTVSeries.execute(testTVSeriesDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) => bloc.add(const AddTVSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: true,
          watchlistMessage: TVSeriesDetailBloc.watchlistAddSuccessMessage,
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
      ],
    );
  });

  group('RemoveTVSeriesFromWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits Loaded with success message when remove watchlist succeeds',
      build: () {
        when(
          mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: true,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) =>
          bloc.add(const RemoveTVSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: TVSeriesDetailBloc.watchlistRemoveSuccessMessage,
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits Loaded with failure message when remove watchlist fails',
      build: () {
        when(
          mockRemoveWatchlistTVSeries.execute(testTVSeriesDetail),
        ).thenAnswer(
          (_) async =>
              const Left(DatabaseFailure('Cannot remove from Watchlist')),
        );
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: true,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) =>
          bloc.add(const RemoveTVSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: true,
          watchlistMessage: 'Cannot remove from Watchlist',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'does nothing when state is not Loaded',
      build: () => makeBloc(),
      act: (bloc) =>
          bloc.add(const RemoveTVSeriesFromWatchlist(testTVSeriesDetail)),
      expect: () => [],
    );
  });

  group('AddTVSeriesToWatchlist', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits Loaded with failure message when add watchlist fails',
      build: () {
        when(
          mockSaveWatchlistTVSeries.execute(testTVSeriesDetail),
        ).thenAnswer(
          (_) async =>
              const Left(DatabaseFailure('Cannot add data to Watchlist')),
        );
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) => bloc.add(const AddTVSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: 'Cannot add data to Watchlist',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'does nothing when state is not Loaded',
      build: () => makeBloc(),
      act: (bloc) => bloc.add(const AddTVSeriesToWatchlist(testTVSeriesDetail)),
      expect: () => [],
    );
  });

  group('LoadTVSeriesWatchlistStatus', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits updated Loaded state with watchlist status',
      build: () {
        when(
          mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) =>
          bloc.add(LoadTVSeriesWatchlistStatus(testTVSeriesDetail.id)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: true,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'does nothing when state is not Loaded',
      build: () {
        when(
          mockGetWatchlistTVSeriesStatus.execute(testTVSeriesDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      act: (bloc) =>
          bloc.add(LoadTVSeriesWatchlistStatus(testTVSeriesDetail.id)),
      expect: () => [],
    );
  });

  group('FetchTVSeriesDetail with recommendations failure', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits Loaded with empty recommendations when recommendations fail',
      build: () {
        when(
          mockGetTVSeriesDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testTVSeriesDetail));
        when(
          mockGetTVSeriesRecommendations.execute(tId),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        when(
          mockGetWatchlistTVSeriesStatus.execute(tId),
        ).thenAnswer((_) async => false);
        when(
          mockGetSeasonDetail.execute(tId, 1),
        ).thenAnswer((_) async => const Right(tEpisodes));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchTVSeriesDetail(tId)),
      expect: () => [
        TVSeriesDetailLoading(),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.empty,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loading,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: const [],
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: tEpisodes,
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loaded,
          episodeMessage: '',
        ),
      ],
    );
  });

  group('FetchTVSeriesSeasonDetail', () {
    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits loading then loaded when season detail fetch succeeds',
      build: () {
        when(
          mockGetSeasonDetail.execute(tId, 1),
        ).thenAnswer((_) async => const Right(tEpisodes));
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) =>
          bloc.add(const FetchTVSeriesSeasonDetail(tvId: tId, seasonNumber: 1)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loading,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: tEpisodes,
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loaded,
          episodeMessage: '',
        ),
      ],
    );

    blocTest<TVSeriesDetailBloc, TVSeriesDetailState>(
      'emits loading then error when season detail fetch fails',
      build: () {
        when(
          mockGetSeasonDetail.execute(tId, 1),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Server Failure')),
        );
        return makeBloc();
      },
      seed: () => TVSeriesDetailLoaded(
        tvSeries: testTVSeriesDetail,
        recommendations: testTVSeriesList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
        seasonEpisodes: const [],
        selectedSeason: 1,
        episodeState: TVSeriesEpisodeState.empty,
        episodeMessage: '',
      ),
      act: (bloc) =>
          bloc.add(const FetchTVSeriesSeasonDetail(tvId: tId, seasonNumber: 1)),
      expect: () => [
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.loading,
          episodeMessage: '',
        ),
        TVSeriesDetailLoaded(
          tvSeries: testTVSeriesDetail,
          recommendations: testTVSeriesList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
          seasonEpisodes: const [],
          selectedSeason: 1,
          episodeState: TVSeriesEpisodeState.error,
          episodeMessage: 'Server Failure',
        ),
      ],
    );
  });

  group('Event props', () {
    test('FetchTVSeriesDetail props contains id', () {
      expect(const FetchTVSeriesDetail(tId).props, [tId]);
    });

    test('AddTVSeriesToWatchlist props contains tvSeries', () {
      expect(
        const AddTVSeriesToWatchlist(testTVSeriesDetail).props,
        [testTVSeriesDetail],
      );
    });

    test('RemoveTVSeriesFromWatchlist props contains tvSeries', () {
      expect(
        const RemoveTVSeriesFromWatchlist(testTVSeriesDetail).props,
        [testTVSeriesDetail],
      );
    });

    test('LoadTVSeriesWatchlistStatus props contains id', () {
      expect(LoadTVSeriesWatchlistStatus(tId).props, [tId]);
    });

    test('FetchTVSeriesSeasonDetail props contains tvId and seasonNumber', () {
      expect(
        const FetchTVSeriesSeasonDetail(tvId: tId, seasonNumber: 1).props,
        [tId, 1],
      );
    });

    test('Event equality via props', () {
      expect(
        const FetchTVSeriesDetail(tId),
        equals(const FetchTVSeriesDetail(tId)),
      );
    });
  });
}
