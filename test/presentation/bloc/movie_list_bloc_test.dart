import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
  });

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('NowPlayingMoviesBloc', () {
    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [Loading, Loaded] when FetchNowPlayingMovies is added and succeeds',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return NowPlayingMoviesBloc(
          getNowPlayingMovies: mockGetNowPlayingMovies,
        );
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMoviesLoading(),
        NowPlayingMoviesLoaded(tMovieList),
      ],
    );

    blocTest<NowPlayingMoviesBloc, NowPlayingMoviesState>(
      'emits [Loading, Error] when FetchNowPlayingMovies fails',
      build: () {
        when(
          mockGetNowPlayingMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return NowPlayingMoviesBloc(
          getNowPlayingMovies: mockGetNowPlayingMovies,
        );
      },
      act: (bloc) => bloc.add(FetchNowPlayingMovies()),
      expect: () => [
        NowPlayingMoviesLoading(),
        const NowPlayingMoviesError('Server Failure'),
      ],
    );
  });

  group('PopularMoviesBloc', () {
    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Loaded] when FetchPopularMovies is added and succeeds',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [PopularMoviesLoading(), PopularMoviesLoaded(tMovieList)],
    );

    blocTest<PopularMoviesBloc, PopularMoviesState>(
      'emits [Loading, Error] when FetchPopularMovies fails',
      build: () {
        when(
          mockGetPopularMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return PopularMoviesBloc(getPopularMovies: mockGetPopularMovies);
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      expect: () => [
        PopularMoviesLoading(),
        const PopularMoviesError('Server Failure'),
      ],
    );
  });

  group('TopRatedMoviesBloc', () {
    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [Loading, Loaded] when FetchTopRatedMovies is added and succeeds',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => Right(tMovieList));
        return TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [TopRatedMoviesLoading(), TopRatedMoviesLoaded(tMovieList)],
    );

    blocTest<TopRatedMoviesBloc, TopRatedMoviesState>(
      'emits [Loading, Error] when FetchTopRatedMovies fails',
      build: () {
        when(
          mockGetTopRatedMovies.execute(),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return TopRatedMoviesBloc(getTopRatedMovies: mockGetTopRatedMovies);
      },
      act: (bloc) => bloc.add(FetchTopRatedMovies()),
      expect: () => [
        TopRatedMoviesLoading(),
        const TopRatedMoviesError('Server Failure'),
      ],
    );
  });
}
