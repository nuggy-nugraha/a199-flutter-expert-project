import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
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
  const tQuery = 'spiderman';

  group('MovieSearchBloc', () {
    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Loaded] when OnMovieQueryChanged is added and succeeds',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => Right(tMovieList));
        return MovieSearchBloc(searchMovies: mockSearchMovies);
      },
      act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect: () => [MovieSearchLoading(), MovieSearchLoaded(tMovieList)],
    );

    blocTest<MovieSearchBloc, MovieSearchState>(
      'emits [Loading, Error] when OnMovieQueryChanged fails',
      build: () {
        when(
          mockSearchMovies.execute(tQuery),
        ).thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return MovieSearchBloc(searchMovies: mockSearchMovies);
      },
      act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        MovieSearchLoading(),
        const MovieSearchError('Server Failure'),
      ],
    );
  });
}
