import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
  });

  MovieDetailBloc makeBloc() => MovieDetailBloc(
    getMovieDetail: mockGetMovieDetail,
    getMovieRecommendations: mockGetMovieRecommendations,
    getWatchListStatus: mockGetWatchListStatus,
    saveWatchlist: mockSaveWatchlist,
    removeWatchlist: mockRemoveWatchlist,
  );

  const tId = 1;

  group('FetchMovieDetail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Loaded] when fetch succeeds',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Loaded] with empty recommendations when recommendations fail',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: [],
          isAddedToWatchlist: false,
          watchlistMessage: '',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Server Failure'),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits [Loading, Loaded] with isAddedToWatchlist true when movie is in watchlist',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: true,
          watchlistMessage: '',
        ),
      ],
    );
  });

  group('AddMovieToWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loaded with success message when add watchlist succeeds',
      build: () {
        when(
          mockSaveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
      ),
      act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: true,
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loaded with failure message when add watchlist fails',
      build: () {
        when(mockSaveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async =>
              const Left(DatabaseFailure('Cannot add data to Watchlist')),
        );
        return makeBloc();
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
      ),
      act: (bloc) => bloc.add(const AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: false,
          watchlistMessage: 'Cannot add data to Watchlist',
        ),
      ],
    );
  });

  group('RemoveMovieFromWatchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loaded with success message when remove watchlist succeeds',
      build: () {
        when(
          mockRemoveWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetWatchListStatus.execute(testMovieDetail.id),
        ).thenAnswer((_) async => false);
        return makeBloc();
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: true,
        watchlistMessage: '',
      ),
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: false,
          watchlistMessage: MovieDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits Loaded with failure message when remove watchlist fails',
      build: () {
        when(mockRemoveWatchlist.execute(testMovieDetail)).thenAnswer(
          (_) async =>
              const Left(DatabaseFailure('Cannot remove from Watchlist')),
        );
        return makeBloc();
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: true,
        watchlistMessage: '',
      ),
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: true,
          watchlistMessage: 'Cannot remove from Watchlist',
        ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'does nothing when state is not Loaded',
      build: () => makeBloc(),
      act: (bloc) => bloc.add(const RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [],
    );
  });

  group('LoadMovieWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits updated Loaded state with watchlist status',
      build: () {
        when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => true);
        return makeBloc();
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        recommendations: testMovieList,
        isAddedToWatchlist: false,
        watchlistMessage: '',
      ),
      act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [
        MovieDetailLoaded(
          movie: testMovieDetail,
          recommendations: testMovieList,
          isAddedToWatchlist: true,
          watchlistMessage: '',
        ),
      ],
    );
  });

  group('Event props', () {
    test('FetchMovieDetail props contains id', () {
      expect(const FetchMovieDetail(1).props, [1]);
    });

    test('AddMovieToWatchlist props contains movie', () {
      expect(const AddMovieToWatchlist(testMovieDetail).props, [
        testMovieDetail,
      ]);
    });

    test('RemoveMovieFromWatchlist props contains movie', () {
      expect(const RemoveMovieFromWatchlist(testMovieDetail).props, [
        testMovieDetail,
      ]);
    });

    test('LoadMovieWatchlistStatus props contains id', () {
      expect(const LoadMovieWatchlistStatus(1).props, [1]);
    });

    test('Event equality via props', () {
      expect(const FetchMovieDetail(1), equals(const FetchMovieDetail(1)));
    });
  });
}
