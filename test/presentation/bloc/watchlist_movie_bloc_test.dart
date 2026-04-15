import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
  });

  group('WatchlistMovieBloc', () {
    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Loaded] when FetchWatchlistMovies succeeds',
      build: () {
        when(
          mockGetWatchlistMovies.execute(),
        ).thenAnswer((_) async => Right(testMovieList));
        return WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieLoaded(testMovieList),
      ],
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'emits [Loading, Error] when FetchWatchlistMovies fails',
      build: () {
        when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => const Left(DatabaseFailure('Cannot get watchlist data')),
        );
        return WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
      },
      act: (bloc) => bloc.add(FetchWatchlistMovies()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError('Cannot get watchlist data'),
      ],
    );
  });

  group('Event props', () {
    test('FetchWatchlistMovies props returns empty list', () {
      expect(FetchWatchlistMovies().props, []);
    });

    test('FetchWatchlistMovies equality', () {
      expect(FetchWatchlistMovies(), equals(FetchWatchlistMovies()));
    });
  });
}
