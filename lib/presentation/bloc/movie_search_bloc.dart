import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(MovieSearchEmpty()) {
    on<OnMovieQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  Future<void> _onQueryChanged(
    OnMovieQueryChanged event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query;
    emit(MovieSearchLoading());
    final result = await searchMovies.execute(query);
    result.fold(
      (failure) => emit(MovieSearchError(failure.message)),
      (data) => emit(MovieSearchLoaded(data)),
    );
  }
}
