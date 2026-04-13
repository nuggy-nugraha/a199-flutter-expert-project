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
      'emits [Loading, Error] when fetch fails',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        return makeBloc();
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Server Failure'),
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
}
